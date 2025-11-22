import 'package:equatable/equatable.dart';

class ChildEntity extends Equatable {
  final String id;
  final String name;
  final int age;
  final String parentId;
  final List<String> interests;

  const ChildEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.parentId,
    required this.interests,
  });

  @override
  List<Object?> get props => [id, name, age, parentId, interests];
}
