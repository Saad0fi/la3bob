import 'package:injectable/injectable.dart';
import 'package:la3bob/features/videos/data/datasource/videos_datasource.dart';
import 'package:la3bob/features/videos/data/models/video_model.dart';
import 'package:la3bob/features/videos/domain/entities/video_entity.dart';
import 'package:la3bob/features/videos/domain/repositories/videos_repository.dart';
import 'package:result_dart/result_dart.dart';

@Injectable(as: VideosRepository)
class VideosRepositoryData implements VideosRepository {
  final VideosDatasource _datasource;

  VideosRepositoryData(this._datasource);

  @override
  Future<Result<List<VideoEntity>>> getVideos() async {
    try {
      final models = await _datasource.getVideos();
      return Success(models);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}

