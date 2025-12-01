import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../domain/entities/video_entity.dart';

class VideoPlayerScreen extends StatelessWidget {
  final VideoEntity video;

  const VideoPlayerScreen({super.key, required this.video});

  String _extractVideoId(String url) {
    final regex = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
    );
    final match = regex.firstMatch(url);
    return match?.group(1) ?? url;
  }

  @override
  Widget build(BuildContext context) {
    final videoId = _extractVideoId(video.link);
    return Scaffold(
      appBar: AppBar(
        title: Text(video.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: _YoutubePlayerWidget(videoId: videoId),
    );
  }
}

class _YoutubePlayerWidget extends StatefulWidget {
  final String videoId;

  const _YoutubePlayerWidget({required this.videoId});

  @override
  State<_YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<_YoutubePlayerWidget> {
  YoutubePlayerController? _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    try {
      _controller = YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
    } catch (e) {
      _hasError = true;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || _controller == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'خطأ في تحميل الفيديو',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return Center(
      child: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
      ),
    );
  }
}
