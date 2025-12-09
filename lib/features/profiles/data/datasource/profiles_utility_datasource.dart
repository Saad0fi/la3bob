import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

abstract class ProfilesUtilityDataSource {
  // 1. وظائف التخزين المحلي
  Future<void> setSettingsProtection(String parentId, bool value);
  Future<bool?> getSettingsProtection(String parentId);

  // 2. وظائف المصادقة البيومترية
  Future<bool> authenticateBiometrics();
}

@Injectable(as: ProfilesUtilityDataSource)
class ProfilesUtilityDataSourceImpl implements ProfilesUtilityDataSource {
  final GetStorage _storage;
  final LocalAuthentication _auth;

  ProfilesUtilityDataSourceImpl(this._storage, this._auth);

  //  التخزين المحلي (GetStorage)
  static const String _baseKey = 'isSettingsProtected_';
  String _getScopedKey(String parentId) => '$_baseKey$parentId';

  @override
  Future<void> setSettingsProtection(String parentId, bool value) async {
    final key = _getScopedKey(parentId);
    await _storage.write(key, value);
  }

  @override
  Future<bool?> getSettingsProtection(String parentId) async {
    final key = _getScopedKey(parentId);
    return _storage.read(key) as bool?;
  }

  //  المصادقة البيومترية (LocalAuth)
  @override
  Future<bool> authenticateBiometrics() async {
    final bool didAuthenticate = await _auth.authenticate(
      authMessages: <AuthMessages>[
        // تخصيص رسائل الأندرويد
        AndroidAuthMessages(
          signInTitle: 'الرجاء التحقق من الهوية',
          signInHint: 'استخدم البصمة أو الوجه',
        ),
      ],
      localizedReason: 'الرجاء التحقق من الهوية للمتابعة',
      persistAcrossBackgrounding: true,
      biometricOnly: false,
    );
    return didAuthenticate;
  }
}
