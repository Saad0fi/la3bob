import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  PorfileBloc(this._profileUsecase, this._authUseCases) : super(PorfileInitial()) {
    on<SubmitChildForm>((event, emit) async {
      if (event.childName.isEmpty ||
          event.childAge.isEmpty ||
          event.childIntersets.isEmpty) {
        emit(PorfileError('الرجاء ملء جميع الحقول'));
        return;
      }

      final userResult = await _authUseCases.getSignedInUser();
      String? parentId;
      userResult.when(
        (user) => parentId = user?.id,
        (failure) => parentId = null,
      );
      if (parentId == null) {
        emit(PorfileError('الرجاء تسجيل الدخول أولاً'));
        return;
      }

      final age = int.tryParse(event.childAge);
      if (age == null || age < 1 || age > 18) {
        emit(PorfileError('الرجاء إدخال عمر صحيح (من 1 إلى 18)'));
        return;
      }

      final intersets = event.childIntersets
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (intersets.isEmpty) {
        emit(PorfileError('الرجاء إدخال اهتمامات صحيحة'));
        return;
      }

      emit(PorfileLoading());

      final result = await _profileUsecase.addChild(
        parentId!,
        event.childName,
        age,
        intersets,
      );

      if (result.isSuccess()) {
        emit(PorfileSuccess('تم إضافة الطفل بنجاح'));
      } else {
        final error = result.exceptionOrNull();
        if (error != null) {
          emit(PorfileError(error.toString()));
        }
      }
    });

    on<UpdateChildForm>((event, emit) async {
      if (event.childName.isEmpty ||
          event.childAge.isEmpty ||
          event.childIntersets.isEmpty) {
        emit(PorfileError('الرجاء ملء جميع الحقول'));
        return;
      }

      final userResult = await _authUseCases.getSignedInUser();
      String? parentId;
      userResult.when(
        (user) => parentId = user?.id,
        (failure) => parentId = null,
      );
      if (parentId == null) {
        emit(PorfileError('الرجاء تسجيل الدخول أولاً'));
        return;
      }

      final age = int.tryParse(event.childAge);
      if (age == null || age < 1 || age > 18) {
        emit(PorfileError('الرجاء إدخال عمر صحيح (من 1 إلى 18)'));
        return;
      }

      final intersets = event.childIntersets
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (intersets.isEmpty) {
        emit(PorfileError('الرجاء إدخال اهتمامات صحيحة'));
        return;
      }

      emit(PorfileLoading());

      final result = await _profileUsecase.updateChild(
        ChildEntity(
          id: event.childId,
          name: event.childName,
          age: age,
          parentId: parentId!,
          intersets: intersets,
        ),
      );

      if (result.isSuccess()) {
        emit(PorfileSuccess('تم تحديث بيانات الطفل بنجاح'));
      } else {
        final error = result.exceptionOrNull();
        if (error != null) {
          emit(PorfileError(error.toString()));
        }
      }
    });

    on<LoadChildren>((event, emit) async {
      emit(PorfileLoading());

      final userResult = await _authUseCases.getSignedInUser();
      String? parentId;
      userResult.when(
        (user) => parentId = user?.id,
        (failure) => parentId = null,
      );
      if (parentId == null) {
        emit(PorfileError('الرجاء تسجيل الدخول أولاً'));
        return;
      }

      final result = await _profileUsecase.getChildern(parentId!);

      result.fold(
        (children) => emit(PorfileChildrenLoaded(children)),
        (error) => emit(PorfileError(error.toString())),
      );
    });

    on<DeleteChild>((event, emit) async {
      emit(PorfileLoading());

      final result = await _profileUsecase.deleteChild(event.childId);

      result.fold((_) {
        emit(PorfileSuccess('تم حذف الطفل بنجاح'));
        add(const LoadChildren());
      }, (error) => emit(PorfileError(error.toString())));
    });

    on<LogoutRequested>((event, emit) async {
      emit(PorfileLoading());
      final result = await _authUseCases.signOut();
      result.when(
        (_) => emit(PorfileSuccess('تم تسجيل الخروج بنجاح')),
        (failure) => emit(PorfileError(failure.message)),
      );
    });

    on<PopulateChildForm>((event, emit) {
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
    });

    on<ResetForm>((event, emit) {
      nameController.clear();
      ageController.clear();
      intersetsController.clear();
      emit(PorfileInitial());
    });
  }

  @override
  Future<void> close() {
    nameController.dispose();
    ageController.dispose();
    intersetsController.dispose();
    return super.close();
  }
}
