part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

// حالة التحميل
class AuthLoading extends AuthState {
  const AuthLoading();
}

// حالة تم إرسال الرمز السري بنجاح (OTP Sent)
class OtpSent extends AuthState {
  const OtpSent();
}

// حالة المستخدم غير مسجل دخول
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

// حالة تسجيل الدخول/التأكيد الناجح
class Authenticated extends AuthState {
  final AuthUserEntity user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthenticatedWithChildren extends Authenticated {
  const AuthenticatedWithChildren({required AuthUserEntity user})
      : super(user: user);
}

class AuthenticatedNoChildren extends Authenticated {
  const AuthenticatedNoChildren({required AuthUserEntity user})
      : super(user: user);
}

// حالة الفشل
class AuthFailureState extends AuthState {
  final AuthFailure failure;

  const AuthFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
