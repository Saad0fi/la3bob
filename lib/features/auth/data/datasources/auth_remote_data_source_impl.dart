import 'package:injectable/injectable.dart';
import 'package:la3bob/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:la3bob/features/auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> signUp({required String email, required String name}) async {
    await supabaseClient.auth.signUp(
      password: 'temporary_password_for_otp_flow',
      email: email,
      data: {'user_name': name},
    );
  }

  @override
  Future<void> signIn({required String email}) async {
    await supabaseClient.auth.signInWithOtp(email: email);
  }

  @override
  Future<AuthUserModel> verifyOtp({
    required String email,
    required String token,
  }) async {
    final response = await supabaseClient.auth.verifyOTP(
      type: OtpType.email,
      email: email,
      token: token,
    );
    final user = response.user;

    if (user == null) {
      throw const AuthException('فشل في التحقق من الرمز.');
    }
    return AuthUserModel.fromSupabaseUser(user);
  }

  @override
  Future<User?> getSignedInUser() async {
    return supabaseClient.auth.currentUser;
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
