import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:la3bob/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:la3bob/features/profiles/domain/usecase/profile_usecase.dart';
import 'package:la3bob/features/videos/domain/entities/video_entity.dart';
import 'package:la3bob/features/videos/domain/usecase/videos_usecase.dart';

part 'videos_event.dart';
part 'videos_state.dart';

@injectable
class VideosBloc extends Bloc<VideosEvent, VideosState> {
  final VideosUsecase _videosUsecase;
  final ProfileUsecase _profileUsecase;
  final AuthUseCases _authUseCases;
  static const String _selectedChildIdKey = 'selected_child_id';

  VideosBloc(
    this._videosUsecase,
    this._profileUsecase,
    this._authUseCases,
  ) : super(VideosInitial()) {
    on<LoadVideos>((event, emit) async {
      emit(VideosLoading());

      final result = await _videosUsecase.getVideos();

      result.fold(
        (videos) async {
          final filteredVideos = await _filterVideosBySelectedChild(videos);
          emit(VideosLoaded(filteredVideos));
        },
        (error) => emit(VideosError(error.toString())),
      );
    });

    on<RefreshVideos>((event, emit) async {
      emit(VideosLoading());

      final result = await _videosUsecase.getVideos();

      result.fold(
        (videos) async {
          final filteredVideos = await _filterVideosBySelectedChild(videos);
          emit(VideosLoaded(filteredVideos));
        },
        (error) => emit(VideosError(error.toString())),
      );
    });
  }

  Future<List<VideoEntity>> _filterVideosBySelectedChild(
    List<VideoEntity> videos,
  ) async {
    final selectedChildId = GetStorage().read<String>(_selectedChildIdKey);

    if (selectedChildId == null) {
      return videos; 
    }

    // جلب parentId من AuthUseCases
    final userResult = await _authUseCases.getSignedInUser();
    String? parentId;
    userResult.when(
      (user) => parentId = user?.id,
      (failure) => parentId = null,
    );

    if (parentId == null) {
      return videos; 
    }

    final childrenResult = await _profileUsecase.getChildern(parentId!);

    return childrenResult.when(
      (children) {
        final selectedChild = children.where(
          (child) => child.id == selectedChildId,
        ).firstOrNull;

        if (selectedChild == null) {
          return videos;
        }

        return videos.where((video) {
          return selectedChild.intersets.any(
            (interest) =>
                interest.toLowerCase().trim() ==
                video.category.toLowerCase().trim(),
          );
        }).toList();
      },
      (error) => videos,
    );
  }
}

