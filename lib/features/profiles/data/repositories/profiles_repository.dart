import 'package:injectable/injectable.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:la3bob/core/erors/failures/profiles_failures.dart';
import 'package:la3bob/features/profiles/data/datasource/profiles_utility_datasource.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:la3bob/features/profiles/data/datasource/profiles_datasource.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/repositories/profiles_repository.dart';
import 'package:la3bob/features/profiles/data/models/child_model.dart';

@Injectable(as: ProfilesRepository)
class ProfilesRepositoryData implements ProfilesRepository {
  final ProfilesDatasource _datasource;
  final ProfilesUtilityDataSource _utilityDataSource;

  ProfilesRepositoryData(this._datasource, this._utilityDataSource);

  @override
  Future<Result<List<ChildEntity>, ProfilesFailure>> getChildern(
    String parentId,
  ) async {
    try {
      final models = await _datasource.getChildern(parentId);

      final entities = models.map((e) => e.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Error(
        DatabaseFailure(message: "فشل جلب الأطفال: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Result<String, ProfilesFailure>> addChild(
    String parentId,
    String name,
    int age,
    List<String> intersets,
  ) async {
    try {
      final childId = await _datasource.addChild(
        parentId,
        name,
        age,
        intersets,
      );
      return Success(childId);
    } catch (e) {
      return Error(
        DatabaseFailure(message: "فشل إضافة الطفل: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Result<void, ProfilesFailure>> deleteChild(String childId) async {
    try {
      await _datasource.deleteChild(childId);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(message: "فشل حذف الطفل: ${e.toString()}"));
    }
  }

  @override
  Future<Result<void, ProfilesFailure>> updateChild(ChildEntity child) async {
    try {
      final childModel = ChildModel.fromEntity(child);
      await _datasource.updateChild(childModel);

      return const Success(null);
    } catch (e) {
      return Error(
        DatabaseFailure(message: "فشل تحديث الطفل: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Result<void, ProfilesFailure>> startKioskmode() async {
    try {
      await _datasource.startKioskmode();
      return const Success(null);
    } catch (e) {
      return Error(
        KioskModeFailure(message: "فشل تفعيل وضع القفل: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Result<void, ProfilesFailure>> stopKioskmode() async {
    try {
      await _datasource.stopKioskmode();
      return const Success(null);
    } catch (e) {
      return Error(
        KioskModeFailure(message: "فشل إلغاء وضع القفل: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Result<KioskMode, ProfilesFailure>> getKioskModeStatus() async {
    try {
      final mode = await _datasource.getKioskModeStatus();
      return Success(mode);
    } catch (e) {
      return Error(
        KioskModeFailure(message: "فشل قراءة حالة وضع القفل: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Result<bool, ProfilesFailure>> authenticateBiometrics() async {
    try {
      final result = await _utilityDataSource.authenticateBiometrics();
      return Success(result);
    } on AuthbiometrecFailures catch (e) {
      return Error(e);
    } catch (e) {
      return Error(
        AuthbiometrecFailures(message: "فشل غير متوقع ${e.toString()}"),
      );
    }
  }

  @override
  Future<Result<bool, ProfilesFailure>> getSettingsProtection(
    String parentId,
  ) async {
    try {
      final bool? isProtected = await _utilityDataSource.getSettingsProtection(
        parentId,
      );

      return Success(isProtected ?? false);
    } catch (e) {
      return Error(
        LocalCacheFailure(message: "فشل جلب حالة حماية الإعدادات: "),
      );
    }
  }

  @override
  Future<Result<void, ProfilesFailure>> saveSettingsProtection(
    String parentId,
    bool isProtected,
  ) async {
    try {
      await _utilityDataSource.setSettingsProtection(parentId, isProtected);

      return const Success(null);
    } catch (e) {
      return Error(LocalCacheFailure(message: "فشل حفظ إعدادات الحماية "));
    }
  }

  @override
  Future<Result<void, ProfilesFailure>> deleteAccount() async {
    try {
      await _datasource.deleteAccount();
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(message: " فشل حذف الحساب حاول مرة اخرى"));
    }
  }
}
