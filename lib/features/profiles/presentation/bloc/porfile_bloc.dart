import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'porfile_event.dart';
part 'porfile_state.dart';

class PorfileBloc extends Bloc<PorfileEvent, PorfileState> {
  final ProfileUsecase _profileUsecase;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final interestsController = TextEditingController();

  PorfileBloc(this._profileUsecase) : super(const PorfileInitial()) {
    on<SubmitChildForm>((event, emit) async {
      if (event.childName.isEmpty ||
          event.childAge.isEmpty ||
          event.childInterests.isEmpty) {
        emit(const PorfileError('الرجاء ملء جميع الحقول'));
        return;
      }

      final parentId = Supabase.instance.client.auth.currentUser?.id;
      if (parentId == null) {
        emit(const PorfileError('الرجاء تسجيل الدخول أولاً'));
        return;
      }

      final age = int.tryParse(event.childAge);
      if (age == null || age < 1 || age > 18) {
        emit(const PorfileError('الرجاء إدخال عمر صحيح (من 1 إلى 18)'));
        return;
      }

      final interests = event.childInterests
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (interests.isEmpty) {
        emit(const PorfileError('الرجاء إدخال اهتمامات صحيحة'));
        return;
      }

      emit(const PorfileLoading());

      final result = await _profileUsecase.addChild(
        parentId,
        event.childName,
        age,
        interests,
      );

      result.when(
        success: (data) {
          emit(const PorfileSuccess('تم إضافة الطفل بنجاح'));
        },
        failure: (error) {
          emit(PorfileError(error.toString()));
        },
      );
    });

    on<ResetForm>((event, emit) {
      nameController.clear();
      ageController.clear();
      interestsController.clear();
      emit(const PorfileInitial());
    });
  }

  @override
  Future<void> close() {
    nameController.dispose();
    ageController.dispose();
    interestsController.dispose();
    return super.close();
  }
}
