import 'package:injectable/injectable.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/repositories/profiles_repository.dart';
import 'package:result_dart/result_dart.dart';

@injectable
class ProfileUsecase {
  final ProfilesRepository _repository;

  ProfileUsecase(this._repository);

  Future<Result<List<ChildEntity>>> getChildern(String parentId) {
    return _repository.getChildern(parentId);
  }

  Future<Result<ChildEntity>> addChild(
    String parentId,
    String name,
    int age,
    List<String> interests,
  ) {
    return _repository.addChild(parentId, name, age, interests);
  }

  Future<Result<void>> deleteChild(String childId) {
    return _repository.deleteChild(childId);
  }

  Future<Result<ChildEntity>> updateChild(ChildEntity child) {
    return _repository.updateChild(child);
  }
}
