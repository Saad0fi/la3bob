import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../domain/entities/video_entity.dart';
import '../bloc/videos_bloc.dart';

class VideoPlayerScreen extends StatelessWidget {
  final VideoEntity video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final videoId = VideosBloc.extractVideoId(video.link);
    return Scaffold(
      body: _YoutubePlayerWidget(videoId: videoId, videoTitle: video.title),
    );
  }
}

class _YoutubePlayerWidget extends StatefulWidget {
  final String videoId;
  final String videoTitle;

  const _YoutubePlayerWidget({required this.videoId, required this.videoTitle});

  @override
  State<_YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<_YoutubePlayerWidget> {
  YoutubePlayerController? _controller;
  bool _hasError = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    try {
      _controller = YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
      _controller!.addListener(_listener);
    } catch (e) {
      _hasError = true;
    }
  }

  void _listener() {
    if (_controller!.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _controller!.value.isFullScreen;
      });

      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || _controller == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.videoTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Center(
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
        ),
      );
    }

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      },
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: _isFullScreen
              ? null
              : AppBar(
                  title: Text(
                    widget.videoTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          body: Center(child: player),
        );
      },
    );
  }
}
