import 'package:injectable/injectable.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:la3bob/features/profiles/data/models/child_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfilesDatasource {
  Future<List<ChildModel>> getChildern(String parentId);

  Future<void> addChild(
    String parentId,
    String name,
    int age,
    List<String> intersets,
  );

  Future<void> deleteChild(String childId);

  Future<void> updateChild(ChildModel child);

  Future<void> startKioskmode();

  Future<void> stopKioskmode();

  Future<KioskMode> getKioskModeStatus();
}

@Injectable(as: ProfilesDatasource)
class ApiProfileDatasource implements ProfilesDatasource {
  final SupabaseClient _supabaseClient;

  ApiProfileDatasource(this._supabaseClient);
  @override
  Future<List<ChildModel>> getChildern(String parentId) async {
    final data = await _supabaseClient
        .from('children')
        .select()
        .eq('parent_id', parentId);
    return data.map((e) => ChildModelMapper.fromMap(e)).toList();
  }

  @override
  Future<void> addChild(
    String parentId,
    String name,
    int age,
    List<String> intersets,
  ) async {
    await _supabaseClient.from('children').insert({
      'parent_id': parentId,
      'name': name,
      'age': age,
      'intersets': intersets,
    });
  }

  @override
  Future<void> deleteChild(String childId) async {
    await _supabaseClient.from('children').delete().eq('id', childId);
  }

  @override
  Future<void> updateChild(ChildModel child) async {
    await _supabaseClient
        .from('children')
        .update(child.toMap())
        .eq('id', child.id);
  }

  @override
  Future<void> startKioskmode() async {
    await startKioskMode();
  }

  @override
  Future<void> stopKioskmode() async {
    await stopKioskMode();
  }

  @override
  Future<KioskMode> getKioskModeStatus() async {
    return await getKioskMode();
  }
}
