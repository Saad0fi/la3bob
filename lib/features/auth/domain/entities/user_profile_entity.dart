import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [id, name, email];

  UserProfileEntity copyWith({String? name}) {
    return UserProfileEntity(id: id, name: name ?? this.name, email: email);
  }
}
