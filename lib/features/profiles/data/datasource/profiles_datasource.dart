import 'package:injectable/injectable.dart';
import 'package:la3bob/features/profiles/data/models/child_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfilesDatasource {
  Future<List<ChildModel>> getChildern(String parentId);

  Future<ChildModel> addChild(
    String parentId,
    String name,
    int age,
    List<String> interests,
  );

  Future<void> deleteChild(String childId);

  Future<ChildModel> updateChild(ChildModel child);
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
  Future<ChildModel> addChild(
    String parentId,
    String name,
    int age,
    List<String> interests,
  ) async {
    final data = await _supabaseClient.from('children').insert({
      'parent_id': parentId,
      'name': name,
      'age': age,
      'intersets': interests,
    });

    return ChildModelMapper.fromMap(data);
  }

  @override
  Future<void> deleteChild(String childId) async {
    await _supabaseClient.from('children').delete().eq('id', childId);
  }

  @override
  Future<ChildModel> updateChild(ChildModel child) async {
    final data = await _supabaseClient
        .from('children')
        .update(child.toMap())
        .eq('id', child.id);

    return ChildModelMapper.fromMap(data);
  }
}
