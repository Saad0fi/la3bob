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
  final List<String> interests;
  final String? selectedInterest;

  const VideosLoaded(this.videos, this.interests, [this.selectedInterest]);

  @override
  List<Object?> get props => [videos, interests, selectedInterest];
}

class VideosError extends VideosState {
  final String message;

  const VideosError(this.message);

  @override
  List<Object?> get props => [message];
}

