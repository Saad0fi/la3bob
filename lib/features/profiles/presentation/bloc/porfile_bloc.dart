import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:la3bob/core/erors/failures/profiles_failures.dart';
import 'package:la3bob/features/auth/domain/entities/auth_user_entity.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:uuid/uuid.dart';

part 'porfile_event.dart';
part 'porfile_state.dart';

class PorfileBloc extends Bloc<PorfileEvent, PorfileState> {
  var uuid = Uuid();
  final ProfileUsecase _profileUsecase;
  final AuthUseCases _authUseCases;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final intersetsController = TextEditingController();

  PorfileBloc(this._profileUsecase, this._authUseCases)
    : super(PorfileInitial()) {
    on<SubmitChildForm>(_onSubmitChildForm);
    on<UpdateChildForm>(_onUpdateChildForm);
    on<LoadChildren>(_onLoadChildren);
    on<DeleteChild>(_onDeleteChild);
    on<LogoutRequested>(_onLogoutRequested);
    on<DeleteAcount>(_onDeletAcount);
    on<PopulateChildForm>(_onPopulateChildForm);
    on<ResetForm>(_onResetForm);
    on<ToggleChildLockMode>(_onToggleChildLockMode);
    on<SelectChild>(_onSelectChild);
    on<SaveSettingsProtectionEvent>(_onSaveSettingsProtection);
    on<ForceReload>(_onLoadChildren);
  }

  // ----------------------------------------------------------------------
  //    (Handler Methods) هنا الللعب

  //  حدث تحميل الأطفال
  Future<void> _onLoadChildren(
    PorfileEvent event,
    Emitter<PorfileState> emit,
  ) async {
    final bool isForceReload = event is ForceReload;
    // الكاش متاح إذا كانت الحالة السابقة PorfileChildrenLoaded والايفنت موب ForceReload
    final bool useCache = state is PorfileChildrenLoaded && !isForceReload;

    // جلب بيانات المستخدم الأب
    final parentUser = await _getParentUser(emit);
    if (parentUser == null) return;
    final parentId = parentUser.id;

    // جلب حالة الحماية Protecion Status
    final protectionResult = await _profileUsecase.getSettingsProtection(
      parentId,
    );
    bool isProtected = false;
    protectionResult.when((isSet) => isProtected = isSet, (failure) {
      print('حدث خطأ: ${failure.message}');
    });

    // نجيب بيانات الاطفال قبل عملية المصادقة
    List<ChildEntity> children = [];
    bool isKioskModeActive = false;
    String? selectedChildId;
    bool hasError = false;

    if (!useCache) {
      //  supabase نجيب البيانات  من ال (في حالة الدخول الأول أو ForceReload)
      emit(PorfileLoading());

      final kioskModeStatusResult = await _profileUsecase.getKioskModeStatus();
      final childrenResult = await _profileUsecase.getChildern(parentId);

      kioskModeStatusResult.when(
        (mode) => isKioskModeActive = (mode == KioskMode.enabled),
        (failure) => isKioskModeActive = false,
      );

      childrenResult.when(
        (data) {
          children = data;
        },
        (ProfilesFailure failure) {
          emit(PorfileError(failure));
          hasError = true;
        },
      );

      if (hasError) return;

      // نجيب الـ selectedChildId بعد التحميل
      selectedChildId = GetStorage().read<String>('selected_child_id');
    } else {
      //   استخدام البيانات المخزنة مؤقتاً (Cache) نستخدم
      final currentState = state as PorfileChildrenLoaded;
      children = currentState.children;
      selectedChildId = currentState.selectedChildId;

      // تحديث Kiosk Mode من الشبكة حتى مع الكاش
      final kioskModeStatusResult = await _profileUsecase.getKioskModeStatus();
      kioskModeStatusResult.when(
        (mode) => isKioskModeActive = (mode == KioskMode.enabled),
        // إذا فشل جلب حالة الكشك نستخدم الحالة القديمة من الكاش
        (failure) => isKioskModeActive = currentState.isChildLockModeActive,
      );
    }

    //  تطبيق المصادقة (القفل الأمني)

    bool accessGranted = true; // نفترض النجاح مبدئياً

    //  يتم تشغيل المصادقة البيومترية فقط إذا كانت الحماية مفعلة ولم يكن ForceReload
    if (isProtected && !isForceReload) {
      final authResult = await _profileUsecase.authenticateBiometrics();
      authResult.when((didAuth) => accessGranted = didAuth, (failure) {
        emit(PorfileError(failure));
        accessGranted = false;
      });
    }
    //  إصدار الحالة النهائية

    emit(
      PorfileChildrenLoaded(
        children,
        isChildLockModeActive: isKioskModeActive,
        selectedChildId: selectedChildId,
        currentParentUser: parentUser,
        isSettingsProtected: isProtected,
        accessStatus: accessGranted
            ? AccessStatus.granted
            : AccessStatus.denied,
      ),
    );
  }

  //  حدث إرسال نموذج طفل جديد
  Future<void> _onSubmitChildForm(
    SubmitChildForm event,
    Emitter<PorfileState> emit,
  ) async {
    if (event.childName.isEmpty ||
        event.childAge.isEmpty ||
        event.childIntersets.isEmpty) {
      emit(
        PorfileError(InputValidationFailure(message: 'الرجاء ملء جميع الحقول')),
      );
      return;
    }

    final parentuser = await _getParentUser(emit);
    if (parentuser == null) return;
    final parentId = parentuser.id;
    final age = int.tryParse(event.childAge);
    if (age == null || age < 1 || age > 12) {
      emit(
        PorfileError(
          InputValidationFailure(
            message: 'الرجاء إدخال عمر صحيح (من 1 إلى 12)',
          ),
        ),
      );
      return;
    }

    final intersets = event.childIntersets
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (intersets.isEmpty) {
      emit(
        PorfileError(
          InputValidationFailure(message: 'الرجاء إدخال اهتمامات صحيحة'),
        ),
      );
      return;
    }

    emit(PorfileLoading());

    final result = await _profileUsecase.addChild(
      parentId,
      event.childName,
      age,
      intersets,
    );

    result.when(
      (childId) {
        GetStorage().write('selected_child_id', childId);
        emit(PorfileSuccess('تم إضافة الطفل بنجاح'));
        add(const ForceReload());
      },
      (ProfilesFailure failure) {
        emit(PorfileError(failure));
      },
    );
  }

  //  حدث تحديث بيانات الطفل
  Future<void> _onUpdateChildForm(
    UpdateChildForm event,
    Emitter<PorfileState> emit,
  ) async {
    if (event.childName.isEmpty ||
        event.childAge.isEmpty ||
        event.childIntersets.isEmpty) {
      emit(
        PorfileError(InputValidationFailure(message: 'الرجاء ملء جميع الحقول')),
      );
      return;
    }

    final parentuser = await _getParentUser(emit);
    if (parentuser == null) return;
    final parentId = parentuser.id;

    final age = int.tryParse(event.childAge);
    if (age == null || age < 1 || age > 12) {
      emit(
        PorfileError(
          InputValidationFailure(
            message: 'الرجاء إدخال عمر صحيح (من 1 إلى 12)',
          ),
        ),
      );
      return;
    }

    final intersets = event.childIntersets
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (intersets.isEmpty) {
      emit(
        PorfileError(
          InputValidationFailure(message: 'الرجاء إدخال اهتمامات صحيحة'),
        ),
      );
      return;
    }

    emit(PorfileLoading());

    final result = await _profileUsecase.updateChild(
      ChildEntity(
        id: event.childId,
        name: event.childName,
        age: age,
        parentId: parentId,
        intersets: intersets,
      ),
    );

    result.when(
      (_) {
        emit(PorfileSuccess('تم تحديث بيانات الطفل بنجاح'));
        add(const ForceReload());
      },
      (ProfilesFailure failure) {
        emit(PorfileError(failure));
      },
    );
  }

  Future<void> _onDeleteChild(
    DeleteChild event,
    Emitter<PorfileState> emit,
  ) async {
    emit(PorfileLoading());

    final result = await _profileUsecase.deleteChild(event.childId);

    result.when((_) {
      emit(PorfileSuccess('تم حذف الطفل بنجاح'));
      add(const ForceReload());
    }, (ProfilesFailure failure) => emit(PorfileError(failure)));
  }

  //  حدث طلب تسجيل الخروج
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<PorfileState> emit,
  ) async {
    emit(PorfileLoading());
    final result = await _authUseCases.signOut();
    result.when(
      (_) => emit(PorfileSuccess('تم تسجيل الخروج بنجاح')),
      (failure) => emit(
        PorfileError(
          DatabaseFailure(message: 'فشل تسجيل الخروج: ${failure.message}'),
        ),
      ),
    );
  }

  Future<void> _onDeletAcount(
    DeleteAcount event,
    Emitter<PorfileState> emit,
  ) async {
    emit(PorfileLoading());
    final result = await _profileUsecase.deleteAccount();
    result.when(
      (_) => emit(
        PorfileSuccess('تم حذف الحساب بنجاح. نأمل أن نراك مرة أخرى قريبًا!'),
      ),
      (failure) => emit(PorfileError(failure)),
    );
  }

  //  حدث ملء نموذج الطفل (من أجل التحديث)
  void _onPopulateChildForm(
    PopulateChildForm event,
    Emitter<PorfileState> emit,
  ) {
    nameController.text = event.child.name;
    ageController.text = event.child.age.toString();
    intersetsController.text = event.child.intersets.join(', ');
    emit(
      PorfileForm(
        childName: event.child.name,
        childAge: event.child.age.toString(),
        childIntersets: event.child.intersets.join(', '),
      ),
    );
  }

  //  معالج حدث إعادة تعيين النموذج
  void _onResetForm(ResetForm event, Emitter<PorfileState> emit) {
    nameController.clear();
    ageController.clear();
    intersetsController.clear();
    emit(PorfileInitial());
  }

  Future<void> _onSelectChild(
    SelectChild event,
    Emitter<PorfileState> emit,
  ) async {
    await GetStorage().write('selected_child_id', event.child.id);

    if (state is PorfileChildrenLoaded) {
      final currentState = state as PorfileChildrenLoaded;
      emit(currentState.copyWith(selectedChildId: event.child.id));
    } else {
      emit(PorfileChildSelected(event.child));
    }
  }

  //  معالج حدث تبديل وضع القفل
  void _onToggleChildLockMode(
    ToggleChildLockMode event,
    Emitter<PorfileState> emit,
  ) async {
    if (state is PorfileChildrenLoaded) {
      final currentState = state as PorfileChildrenLoaded;

      final result = await _profileUsecase.toggleChildLockMode(
        shouldBeActive: event.isActive,
      );

      result.when(
        (_) {
          emit(currentState.copyWith(isChildLockModeActive: event.isActive));
        },
        (ProfilesFailure failure) {
          emit(PorfileError(failure));

          emit(currentState.copyWith(isChildLockModeActive: !event.isActive));
        },
      );
    }
  }

  //حفظ حالة سويتش حماية الاعدادات  الجديدة
  FutureOr<void> _onSaveSettingsProtection(
    SaveSettingsProtectionEvent event,
    Emitter<PorfileState> emit,
  ) async {
    if (state is PorfileChildrenLoaded) {
      final currentState = state as PorfileChildrenLoaded;

      final parentId = currentState.currentParentUser.id;
      //  إذا كان المستخدم يبغى السويتش من OFF إلى ON
      if (event.isProtected) {
        // هنا نتحقق اول مايظغط على السويتش  توفر المصادقة البيومترية
        final checkResult = await _profileUsecase.authenticateBiometrics();
        bool isAvailable = false;
        checkResult.when((available) => isAvailable = available, (failure) {
          emit(PorfileError(failure));
        });

        //  إذا لم تكن المصادقة متوفرة: منع التفعيل
        if (!isAvailable) {
          //     قراءة القيمة القديمة false وإرجاع الـ Switch إلى حالة OFF
          emit(
            currentState.copyWith(
              isSettingsProtected: false, // إرجاع القيمة القديمة
              accessStatus: AccessStatus.granted,
            ),
          );
          return; // إيقاف عملية الحفظ
        }
      }
      // نتابع عملية الحفظ
      emit(currentState.copyWith(accessStatus: AccessStatus.loading));

      final result = await _profileUsecase.saveSettingsProtection(
        parentId,
        event.isProtected,
      );

      result.when(
        (success) {
          // إذا نجح الحفظ
          emit(
            currentState.copyWith(
              isSettingsProtected: event.isProtected,
              accessStatus: AccessStatus.granted, // إعادة الوصول بعد الحفظ
            ),
          );
        },
        (failure) {
          // إذا فشل الحفظ
          emit(
            currentState.copyWith(
              accessStatus: AccessStatus.granted,
              accessErrorMessage: null,
            ),
          );
          emit(PorfileError(failure));
        },
      );
    }
  }

  /// ميثود مساعدة لجلب  (Parent ID)
  Future<AuthUserEntity?> _getParentUser(Emitter<PorfileState> emit) async {
    final userResult = await _authUseCases.getSignedInUser();
    AuthUserEntity? parentUser;
    userResult.when((user) {
      parentUser = user;
    }, (failure) {});

    if (parentUser == null) {
      emit(
        PorfileError(
          InputValidationFailure(
            message: 'الرجاء تسجيل الدخول أولاً لإكمال العملية.',
          ),
        ),
      );
    }
    return parentUser;
  }

  @override
  Future<void> close() {
    nameController.dispose();
    ageController.dispose();
    intersetsController.dispose();
    return super.close();
  }
}
