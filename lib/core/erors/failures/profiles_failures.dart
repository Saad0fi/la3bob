import 'package:equatable/equatable.dart';

abstract class ProfilesFailure extends Equatable {
  final String message;
  const ProfilesFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

//  فشل وضع القفل (Kiosk Mode)
class KioskModeFailure extends ProfilesFailure {
  const KioskModeFailure({required super.message});
}

//  فشل خاص بالاتصال أو العمليات على قاعدة البيانات (الـ CRUD)
class DatabaseFailure extends ProfilesFailure {
  const DatabaseFailure({required super.message});
}

//  فشل عند محاولة تحديث أو حذف طفل غير موجود
class ChildNotFoundFailure extends ProfilesFailure {
  const ChildNotFoundFailure({required super.message});
}

//  خطأ عام أو فشل في الخادم لم يتم تصنيفه بشكل محدد
class ProfilesServerFailure extends ProfilesFailure {
  const ProfilesServerFailure({required super.message});
}

// التحقق من البيانات المدخلة  validation
class InputValidationFailure extends ProfilesFailure {
  const InputValidationFailure({required super.message});
}
