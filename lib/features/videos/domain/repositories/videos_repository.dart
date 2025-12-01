import 'package:la3bob/features/videos/domain/entities/video_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract class VideosRepository {
  Future<Result<List<VideoEntity>>> getVideos();
}

