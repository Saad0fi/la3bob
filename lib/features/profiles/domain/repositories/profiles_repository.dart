import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract class ProfilesRepository {
  Future<Result<List<ChildEntity>>> getChildern(String parentId);

  Future<Result<void>> addChild(
    String parentId,
    String name,
    int age,
    List<String> intersets,
  );

  Future<Result<void>> deleteChild(String childId);

  Future<Result<ChildEntity>> updateChild(ChildEntity child);
}
