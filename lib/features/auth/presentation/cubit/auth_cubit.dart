import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la3bob/core/erors/failures/auth_failures.dart';
import 'package:la3bob/features/auth/domain/entities/auth_user_entity.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthUseCases _authUseCases;
  AuthCubit(this._authUseCases) : super(AuthInitial());

  // method فحص حالة المستخدم عند بدء التطبيق

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await _authUseCases.getSignedInUser();
    result.when(
      (user) {
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(const Unauthenticated());
        }
      },
      (failure) {
        emit(AuthFailureState(failure: failure));
      },
    );
  }

  //    إنشاء حساب جديد
  Future<void> signUp({required String email, required String name}) async {
    emit(AuthLoading());
    final result = await _authUseCases.signUp(email: email, name: name);
    result.when(
      (_) => emit(const OtpSent()),
      (failure) => emit(AuthFailureState(failure: failure)),
    );
  }

  //  التحقق من الرمز السري (OTP)
  Future<void> verifyOtp({required String email, required String token}) async {
    emit(const AuthLoading());

    final result = await _authUseCases.verifyOtp(email: email, token: token);

    result.when(
      (user) => emit(Authenticated(user: user)),
      (failure) => emit(AuthFailureState(failure: failure)),
    );
  }

  //  تسجيل الخروج
  Future<void> signOut() async {
    emit(const AuthLoading());

    final result = await _authUseCases.signOut();

    result.when(
      (_) => emit(const Unauthenticated()),
      (failure) => emit(AuthFailureState(failure: failure)),
    );
  }
}
