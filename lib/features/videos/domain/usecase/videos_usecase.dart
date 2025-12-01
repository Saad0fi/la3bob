import 'package:injectable/injectable.dart';
import 'package:la3bob/features/videos/domain/entities/video_entity.dart';
import 'package:la3bob/features/videos/domain/repositories/videos_repository.dart';
import 'package:result_dart/result_dart.dart';

@injectable
class VideosUsecase {
  final VideosRepository _repository;

  VideosUsecase(this._repository);

  Future<Result<List<VideoEntity>>> getVideos() {
    return _repository.getVideos();
  }
}

