import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'porfile_event.dart';
part 'porfile_state.dart';

class PorfileBloc extends Bloc<PorfileEvent, PorfileState> {
  var uuid = Uuid();
  final ProfileUsecase _profileUsecase;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final interestsController = TextEditingController();

  PorfileBloc(this._profileUsecase) : super(PorfileInitial()) {
    on<SubmitChildForm>((event, emit) async {
      if (event.childName.isEmpty ||
          event.childAge.isEmpty ||
          event.childInterests.isEmpty) {
        emit(PorfileError('الرجاء ملء جميع الحقول'));
        return;
      }

      final parentId = uuid.v4();
      if (parentId == null) {
        emit(PorfileError('الرجاء تسجيل الدخول أولاً'));
        return;
      }

      final age = int.tryParse(event.childAge);
      if (age == null || age < 1 || age > 18) {
        emit(PorfileError('الرجاء إدخال عمر صحيح (من 1 إلى 18)'));
        return;
      }

      final interests = event.childInterests
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (interests.isEmpty) {
        emit(PorfileError('الرجاء إدخال اهتمامات صحيحة'));
        return;
      }

      emit(PorfileLoading());

      final result = await _profileUsecase.addChild(
        parentId,
        event.childName,
        age,
        interests,
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

    on<ResetForm>((event, emit) {
      nameController.clear();
      ageController.clear();
      interestsController.clear();
      emit(PorfileInitial());
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
