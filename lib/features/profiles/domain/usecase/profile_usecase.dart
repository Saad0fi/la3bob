import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/repositories/profiles_repository.dart';
import 'package:result_dart/result_dart.dart';

class ProfileUsecase {
  final ProfilesRepository _profilesRepository;

  ProfileUsecase(this._profilesRepository);

  Future<Result<List<ChildEntity>>> getChildern(String parentId) {
    return _profilesRepository.getChildern(parentId);
  }

  Future<Result<ChildEntity>> addChild(
    String parentId,
    String name,
    int age,
    List<String> interests,
  ) {
    return _profilesRepository.addChild(parentId, name, age, interests);
  }

  Future<Result<void>> deleteChild(String childId) {
    return _profilesRepository.deleteChild(childId);
  }

  Future<Result<ChildEntity>> updateChild(ChildEntity child) {
    return _profilesRepository.updateChild(child);
  }
}
