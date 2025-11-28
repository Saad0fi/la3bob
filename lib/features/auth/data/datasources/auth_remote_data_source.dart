import 'package:la3bob/features/auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp({required String email, required String name});

  Future<void> signIn({required String email});

  Future<AuthUserModel> verifyOtp({
    required String email,
    required String token,
  });

  Future<User?> getSignedInUser(); // ترجع كائن User  من Supabase

  Future<void> signOut();
}
