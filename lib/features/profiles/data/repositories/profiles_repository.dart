import 'package:la3bob/features/profiles/data/datasource/profiles_datasource.dart';
import 'package:la3bob/features/profiles/data/models/child_model.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/repositories/profiles_repository.dart';
import 'package:result_dart/result_dart.dart';

class ProfilesRepositoryData implements ProfilesRepository {
  final ProfilesDatasource _datasource;

  ProfilesRepositoryData(this._datasource);

  @override
  Future<Result<List<ChildEntity>>> getChildern(String parentId) async {
    try {
      final models = await _datasource.getChildern(parentId);
      return Success(models);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<ChildEntity>> addChild(
    String parentId,
    String name,
    int age,
    List<String> interests,
  ) async {
    try {
      final model = await _datasource.addChild(parentId, name, age, interests);
      return Success(model);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteChild(String childId) async {
    try {
      await _datasource.deleteChild(childId);
      return const Success(unit);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<ChildEntity>> updateChild(ChildEntity child) async {
    try {
      final model = await _datasource.updateChild(
        ChildModel(
          id: child.id,
          name: child.name,
          age: child.age,
          parentId: child.parentId,
          interests: child.interests,
        ),
      );
      return Success(model);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
