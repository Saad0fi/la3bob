import 'package:la3bob/core/erors/failures/auth_failures.dart';
import 'package:multiple_result/multiple_result.dart';
import '../repositories/auth_repository_domain.dart';
import '../entities/auth_user_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthUseCases {
  final AuthRepositoryDomain _repository;

  AuthUseCases(this._repository);

  Future<Result<void, AuthFailure>> signUp({
    required String email,
    required String name,
  }) async {
    return await _repository.signUp(email: email, name: name);
  }

  Future<Result<void, AuthFailure>> signIn({required String email}) async {
    return await _repository.signIn(email: email);
  }

  Future<Result<AuthUserEntity, AuthFailure>> verifyOtp({
    required String email,
    required String token,
  }) async {
    return await _repository.verifyOtp(email: email, token: token);
  }

  Future<Result<AuthUserEntity?, AuthFailure>> getSignedInUser() async {
    return await _repository.getSignedInUser();
  }

  Future<Result<void, AuthFailure>> signOut() async {
    return await _repository.signOut();
  }
}
