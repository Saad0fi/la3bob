import 'package:injectable/injectable.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:la3bob/core/erors/failures/profiles_failures.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/repositories/profiles_repository.dart';
import 'package:multiple_result/multiple_result.dart';

@injectable
class ProfileUsecase {
  final ProfilesRepository _repository;

  ProfileUsecase(this._repository);

  Future<Result<List<ChildEntity>, ProfilesFailure>> getChildern(
    String parentId,
  ) {
    return _repository.getChildern(parentId);
  }

  Future<Result<void, ProfilesFailure>> addChild(
    String parentId,
    String name,
    int age,
    List<String> intersets,
  ) {
    return _repository.addChild(parentId, name, age, intersets);
  }

  Future<Result<void, ProfilesFailure>> deleteChild(String childId) {
    return _repository.deleteChild(childId);
  }

  Future<Result<void, ProfilesFailure>> updateChild(ChildEntity child) {
    return _repository.updateChild(child);
  }

  Future<Result<void, ProfilesFailure>> toggleChildLockMode({
    required bool shouldBeActive,
  }) {
    if (shouldBeActive) {
      return _repository.startKioskmode();
    } else {
      return _repository.stopKioskmode();
    }
  }

  Future<Result<KioskMode, ProfilesFailure>> getKioskModeStatus() async {
    return await _repository.getKioskModeStatus();
  }
}
