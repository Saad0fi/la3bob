import 'package:la3bob/core/erors/failures/auth_failures.dart';
import 'package:la3bob/features/auth/domain/entities/auth_user_entity.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class AuthRepositoryDomain {
  Future<Result<void, AuthFailure>> signUp({
    required String email,
    required String name,
  });

  Future<Result<void, AuthFailure>> signIn({required String email});

  Future<Result<AuthUserEntity, AuthFailure>> verifyOtp({
    required String email,
    required String token,
  });

  Future<Result<AuthUserEntity?, AuthFailure>> getSignedInUser();

  Future<Result<void, AuthFailure>> signOut();
}
