part of 'videos_bloc.dart';

abstract class VideosEvent extends Equatable {
  const VideosEvent();

  @override
  List<Object?> get props => [];
}

class LoadVideos extends VideosEvent {
  const LoadVideos();
}

class RefreshVideos extends VideosEvent {
  const RefreshVideos();
}

class SelectInterest extends VideosEvent {
  final String? interest;

  const SelectInterest(this.interest);

  @override
  List<Object?> get props => [interest];
}

