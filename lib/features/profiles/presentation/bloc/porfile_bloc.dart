import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:la3bob/core/erors/failures/profiles_failures.dart';
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
    on<PopulateChildForm>(_onPopulateChildForm);
    on<ResetForm>(_onResetForm);
    on<ToggleChildLockMode>(_onToggleChildLockMode);
    on<SelectChild>(_onSelectChild);
    on<SaveSettingsProtectionEvent>(_onSaveSettingsProtection);
  }

  // ----------------------------------------------------------------------
  //    معالجات الأحداث (Handler Methods)

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

  // معالج حدث إرسال نموذج طفل جديد
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

    final parentId = await _getParentId(emit);
    if (parentId == null) return;

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
      (_) {
        emit(PorfileSuccess('تم إضافة الطفل بنجاح'));
        add(const LoadChildren());
      },
      (ProfilesFailure failure) {
        emit(PorfileError(failure));
      },
    );
  }

  //  معالج حدث تحديث بيانات الطفل
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

    final parentId = await _getParentId(emit);
    if (parentId == null) return;

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
        add(const LoadChildren());
      },
      (ProfilesFailure failure) {
        emit(PorfileError(failure));
      },
    );
  }

  //  معالج حدث تحميل الأطفال
  Future<void> _onLoadChildren(
    LoadChildren event,
    Emitter<PorfileState> emit,
  ) async {
    final parentId = await _getParentId(emit);
    if (parentId == null) return;

    emit(PorfileLoading());

    //  جلب حالة الحماية (لتحديد القيمة الأولية للـ Switch وللمصادقة)
    final protectionResult = await _profileUsecase.getSettingsProtection(
      parentId,
    );
    bool isProtected = false;
    protectionResult.when((isSet) => isProtected = isSet, (failure) {
      print('Failed to get protection settings: ${failure.message}');
    });

    //   المصادقة شرط إظهار محتوى الإعدادات
    bool accessGranted = false;
    if (isProtected) {
      // هنا تكون المصادقة مفعلة: نستدعي المصادقة البيومترية
      final authResult = await _profileUsecase.authenticateBiometrics();
      await authResult.when((didAuth) => accessGranted = didAuth, (failure) {
        print('Biometrics authentication failed: ${failure.message}');
        // لا نمنح الوصول ونصدر رسالة خطأ
      });
    } else {
      // المصادقة غير مفعلة: ندخل المستحدم  مباشرة
      accessGranted = true;
    }

    //  إذا فشلت المصادقة: إصدار حالة الوصول الممنوع
    if (!accessGranted) {
      emit(
        PorfileChildrenLoaded(
          const [],
          currentParentId: parentId,
          isSettingsProtected: isProtected,
          accessStatus: AccessStatus.denied, // منع الوصول
          isChildLockModeActive: false,
          selectedChildId: null,
        ),
      );
      return; //  إيقاف التحميل
    }

    //   تم منح الوصول: نجيب باقي البيانات
    final kioskModeStatusResult = await _profileUsecase.getKioskModeStatus();
    final childrenResult = await _profileUsecase.getChildern(parentId);

    bool isKioskModeActive = false;

    kioskModeStatusResult.when(
      (mode) {
        isKioskModeActive = (mode == KioskMode.enabled);
      },
      (failure) {
        print('Failed to get Kiosk Mode status: ${failure.message}');
      },
    );

    // إصدار الحالة النهائية (الوصول ممنوح)
    childrenResult.when(
      (children) {
        final selectedChildId = GetStorage().read<String>('selected_child_id');
        emit(
          PorfileChildrenLoaded(
            children,
            isChildLockModeActive: isKioskModeActive,
            selectedChildId: selectedChildId,
            currentParentId: parentId,
            isSettingsProtected: isProtected, // نمرر القيمة الصحيحة
            accessStatus: AccessStatus.granted, // الحالى تكون تم منح الوصول
          ),
        );
      },
      (ProfilesFailure failure) {
        emit(PorfileError(failure));
      },
    );
  }

  //  معالج حدث حذف الطفل
  Future<void> _onDeleteChild(
    DeleteChild event,
    Emitter<PorfileState> emit,
  ) async {
    emit(PorfileLoading());

    final result = await _profileUsecase.deleteChild(event.childId);

    result.when((_) {
      emit(PorfileSuccess('تم حذف الطفل بنجاح'));
      add(const LoadChildren());
    }, (ProfilesFailure failure) => emit(PorfileError(failure)));
  }

  //  معالج حدث طلب تسجيل الخروج
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

  //  معالج حدث ملء نموذج الطفل (من أجل التحديث)
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

  //       حفظ حالة سويتش حماية الاعدادات  الجديدة
  FutureOr<void> _onSaveSettingsProtection(
    SaveSettingsProtectionEvent event,
    Emitter<PorfileState> emit,
  ) async {
    if (state is PorfileChildrenLoaded) {
      final currentState = state as PorfileChildrenLoaded;

      final parentId = currentState.currentParentId;
      if (parentId == null) return;

      emit(currentState.copyWith(accessStatus: AccessStatus.loading));

      final result = await _profileUsecase.saveSettingsProtection(
        parentId,
        event.isProtected,
      );

      result.when(
        (success) {
          emit(
            currentState.copyWith(
              isSettingsProtected: event.isProtected,
              accessStatus: AccessStatus.granted, // إعادة الوصول بعد الحفظ
            ),
          );
        },
        (failure) {
          emit(
            currentState.copyWith(
              accessStatus: AccessStatus.denied,
              accessErrorMessage: failure.message,
            ),
          );
        },
      );
    }
  }

  /// ميثود مساعدة لجلب  (Parent ID)
  Future<String?> _getParentId(Emitter<PorfileState> emit) async {
    final userResult = await _authUseCases.getSignedInUser();
    String? parentId;

    userResult.when((user) => parentId = user?.id, (failure) {});

    if (parentId == null) {
      emit(
        PorfileError(
          InputValidationFailure(
            message: 'الرجاء تسجيل الدخول أولاً لإكمال العملية.',
          ),
        ),
      );
    }
    return parentId;
  }

  @override
  Future<void> close() {
    nameController.dispose();
    ageController.dispose();
    intersetsController.dispose();
    return super.close();
  }
}
