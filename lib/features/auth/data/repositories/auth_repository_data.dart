import 'package:injectable/injectable.dart';
import 'package:la3bob/core/erors/failures/auth_failures.dart';
import 'package:la3bob/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:la3bob/features/auth/data/models/auth_user_model.dart';
import 'package:la3bob/features/auth/domain/entities/auth_user_entity.dart';
import 'package:la3bob/features/auth/domain/repositories/auth_repository_domain.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: AuthRepositoryDomain)
class AuthRepositoryImpl implements AuthRepositoryDomain {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  // دالة مساعدة لترجمة أخطاء Supabase إلى AuthFailure

  AuthFailure _handleSupabaseError(Object error) {
    if (error is AuthException) {
      if (error.message.contains('Email address already taken')) {
        return const EmailAlreadyInUseFailure(
          message: 'هذا البريد الإلكتروني مستخدم بالفعل.',
        );
      }
      if (error.message.contains('Invalid login credentials') ||
          error.message.contains('Invalid code')) {
        return const OtpValidationFailure(
          message: 'الرمز السري غير صالح أو منتهي الصلاحية.',
        );
      }
      // لأي خطأ مصادقة آخر غير معروف
      return ServerFailure(message: 'خطأ في المصادقة: ');
    }
    // لأي خطأ عام آخر (مثل مشاكل الشبكة)
    return ServerFailure(message: 'حدث خطأ غير متوقع: $error');
  }

  @override
  Future<Result<void, AuthFailure>> signUp({
    required String email,
    required String name,
  }) async {
    try {
      await remoteDataSource.signUp(email: email, name: name);
      return const Success(null);
    } catch (e) {
      return Error(_handleSupabaseError(e)); // تحويل Exception إلى Failure
    }
  }

  @override
  Future<Result<void, AuthFailure>> signIn({required String email}) async {
    try {
      await remoteDataSource.signIn(email: email);
      return const Success(null);
    } catch (e) {
      return Error(_handleSupabaseError(e));
    }
  }

  @override
  Future<Result<AuthUserEntity?, AuthFailure>> getSignedInUser() async {
    try {
      final user = await remoteDataSource.getSignedInUser();

      if (user == null) {
        return const Success(null);
      }

      // تحويل object User  إلى الموديل
      final userModel = AuthUserModel.fromSupabaseUser(user);
      return Success(userModel);
    } catch (e) {
      return Error(_handleSupabaseError(e));
    }
  }

  @override
  Future<Result<AuthUserEntity, AuthFailure>> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      // الـ Data Source ترجع AuthUserModel
      final userModel = await remoteDataSource.verifyOtp(
        email: email,
        token: token,
      );

      return Success(userModel);
    } catch (e) {
      return Error(_handleSupabaseError(e));
    }
  }

  @override
  Future<Result<void, AuthFailure>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Success(null);
    } catch (e) {
      return Error(_handleSupabaseError(e));
    }
  }
}
