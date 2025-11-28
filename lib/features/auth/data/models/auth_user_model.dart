import 'package:dart_mappable/dart_mappable.dart';
import 'package:la3bob/features/auth/domain/entities/auth_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'auth_user_model.mapper.dart';

@MappableClass()
class AuthUserModel extends AuthUserEntity with AuthUserModelMappable {
  const AuthUserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory AuthUserModel.fromSupabaseUser(User user) {
    final userName =
        user.userMetadata?['user_name'] as String? ??
        user.email!.split('@').first;

    return AuthUserModel(id: user.id, name: userName, email: user.email!);
  }
}
