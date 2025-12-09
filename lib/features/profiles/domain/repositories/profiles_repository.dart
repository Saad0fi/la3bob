import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:la3bob/core/erors/failures/profiles_failures.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class ProfilesRepository {
  Future<Result<List<ChildEntity>, ProfilesFailure>> getChildern(
    String parentId,
  );

  Future<Result<void, ProfilesFailure>> addChild(
    String parentId,
    String name,
    int age,
    List<String> intersets,
  );
  Future<Result<void, ProfilesFailure>> deleteChild(String childId);

  Future<Result<void, ProfilesFailure>> updateChild(ChildEntity child);

  Future<Result<void, ProfilesFailure>> startKioskmode();

  Future<Result<void, ProfilesFailure>> stopKioskmode();

  Future<Result<KioskMode, ProfilesFailure>> getKioskModeStatus();
  // ميثود التحقق من المصادقة البيومترية
  Future<Result<bool, ProfilesFailure>> authenticateBiometrics();

  /// يحفظ حالة حماية الإعدادات (مفعلة/غير مفعلة) في التخزين المحلي
  Future<Result<void, ProfilesFailure>> saveSettingsProtection(
    String parentId,
    bool isProtected,
  );

  /// يجيب حالة حماية الإعدادات المحفوظة من التخزين المحلي
  Future<Result<bool, ProfilesFailure>> getSettingsProtection(String parentId);
}
