part of 'videos_bloc.dart';

abstract class VideosState extends Equatable {
  const VideosState();

  @override
  List<Object?> get props => [];
}

class VideosInitial extends VideosState {}

class VideosLoading extends VideosState {}

class VideosLoaded extends VideosState {
  final List<VideoEntity> videos;

  const VideosLoaded(this.videos);

  @override
  List<Object?> get props => [videos];
}

class VideosError extends VideosState {
  final String message;

  const VideosError(this.message);

  @override
  List<Object?> get props => [message];
}

