import 'package:injectable/injectable.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:la3bob/core/erors/failures/profiles_failures.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:la3bob/features/profiles/data/datasource/profiles_datasource.dart';
import 'package:la3bob/features/profiles/domain/entities/child_entity.dart';
import 'package:la3bob/features/profiles/domain/repositories/profiles_repository.dart';
import 'package:la3bob/features/profiles/data/models/child_model.dart';

@Injectable(as: ProfilesRepository)
class ProfilesRepositoryData implements ProfilesRepository {
  final ProfilesDatasource _datasource;

  ProfilesRepositoryData(this._datasource);

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
  Future<Result<void, ProfilesFailure>> addChild(
    String parentId,
    String name,
    int age,
    List<String> intersets,
  ) async {
    try {
      await _datasource.addChild(parentId, name, age, intersets);
      return const Success(null);
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
}
