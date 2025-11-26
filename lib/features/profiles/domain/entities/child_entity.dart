import 'package:equatable/equatable.dart';

class ChildEntity extends Equatable {
  final String id;
  final String name;
  final int age;
  final String parentId;
  final List<String> intersets;

  const ChildEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.parentId,
    required this.intersets,
  });

  @override
  List<Object?> get props => [id, name, age, parentId, intersets];
}
