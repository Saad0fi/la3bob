import 'package:injectable/injectable.dart';
import 'package:la3bob/features/videos/data/models/video_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class VideosDatasource {
  Future<List<VideoModel>> getVideos();
}

@Injectable(as: VideosDatasource)
class ApiVideosDatasource implements VideosDatasource {
  final SupabaseClient _supabaseClient;

  ApiVideosDatasource(this._supabaseClient);

  @override
  Future<List<VideoModel>> getVideos() async {
    final data = await _supabaseClient.from('videos').select();
    return data.map((e) => VideoModelMapper.fromMap(e)).toList();
  }
}

