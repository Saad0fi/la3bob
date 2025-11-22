import 'package:la3bob/features/profiles/data/models/child_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfilesDatasource {
  Future<List<ChildModel>> getChildern(String parentId);

  Future<ChildModel> addChild(
    String parentId,
    String name,
    String age,
    List<String> interests,
  );

  Future<void> deleteChild(String childId);

  Future<ChildModel> updateChild(ChildModel child);
}

class ApiProfileDatasource implements ProfilesDatasource {
  final SupabaseClient _supabaseClient;

  ApiProfileDatasource(this._supabaseClient);
  @override
  Future<ChildModel> addChild(
    String parentId,
    String name,
    String age,
    List<String> interests,
  ) {
    // TODO: implement addChild
    throw UnimplementedError();
  }

  @override
  Future<void> deleteChild(String childId) {
    // TODO: implement deleteChild
    throw UnimplementedError();
  }

  @override
  Future<List<ChildModel>> getChildern(String parentId) {
    // TODO: implement getChildern
    throw UnimplementedError();
  }

  @override
  Future<ChildModel> updateChild(ChildModel child) {
    // TODO: implement updateChild
    throw UnimplementedError();
  }
}
