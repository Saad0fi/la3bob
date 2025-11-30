import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:la3bob/features/videos/domain/entities/video_entity.dart';
import 'package:la3bob/features/videos/domain/usecase/videos_usecase.dart';

part 'videos_event.dart';
part 'videos_state.dart';

@injectable
class VideosBloc extends Bloc<VideosEvent, VideosState> {
  final VideosUsecase _videosUsecase;

  VideosBloc(this._videosUsecase) : super(VideosInitial()) {
    on<LoadVideos>((event, emit) async {
      emit(VideosLoading());

      final result = await _videosUsecase.getVideos();

      result.fold(
        (videos) => emit(VideosLoaded(videos)),
        (error) => emit(VideosError(error.toString())),
      );
    });
  }
}

