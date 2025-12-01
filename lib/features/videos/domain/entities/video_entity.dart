import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String id;
  final String title;
  final String link;

  const VideoEntity({
    required this.id,
    required this.title,
    required this.link,
  });

  @override
  List<Object?> get props => [id, title, link];
}

