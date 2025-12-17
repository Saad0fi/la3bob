import 'package:dart_mappable/dart_mappable.dart';
import '../../domain/entities/child_entity.dart';

part 'child_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class ChildModel extends ChildEntity with ChildModelMappable {
  ChildModel({
    required super.id,
    required super.name,
    required super.age,
    required super.parentId,
    required super.intersets,
  });

  factory ChildModel.fromEntity(ChildEntity entity) {
    return ChildModel(
      id: entity.id,
      name: entity.name,
      age: entity.age,
      parentId: entity.parentId,
      intersets: entity.intersets,
    );
  }

  ChildEntity toEntity() {
    return this;
  }
}
