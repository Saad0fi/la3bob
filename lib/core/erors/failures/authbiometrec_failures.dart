import 'package:equatable/equatable.dart';

//  جميع  أخطاء ال Authentication
abstract class AuthbiometrecFailures extends Equatable {
  final String message;
  const AuthbiometrecFailures({required this.message});
  @override
  List<Object?> get props => [message];
}

// الفشل الناتج عن خطأ في الإدخال (مثلاً: إيميل غير صالح)
class InvalidCredentialsFailure extends AuthbiometrecFailures {
  const InvalidCredentialsFailure({required super.message});
}

// الفشل الناتج عن رمز OTP غير صالح أو منتهي الصلاحية
class OtpValidationFailure extends AuthbiometrecFailures {
  const OtpValidationFailure({required super.message});
}

//  الفشل الناتج عن محاولة تسجيل بإيميل موجود
class EmailAlreadyInUseFailure extends AuthbiometrecFailures {
  const EmailAlreadyInUseFailure({required super.message});
}

// خطأ عام أو غير معروف (مثل مشكلة في الاتصال بالشبكة)
class ServerFailure extends AuthbiometrecFailures {
  const ServerFailure({required super.message});
}
