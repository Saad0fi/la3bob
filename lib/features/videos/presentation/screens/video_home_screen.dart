import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/profiles/presentation/screens/profile_screen.dart';
import 'package:la3bob/features/videos/presentation/bloc/videos_bloc.dart';
import 'package:la3bob/features/videos/presentation/screens/video_player_screen.dart';

class VideoHomeScreen extends StatelessWidget {
  const VideoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VideosBloc>()..add(const LoadVideos()),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("فيديوهات")),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    )
                    .then((_) {
                  if (context.mounted) {
                    context.read<VideosBloc>().add(const RefreshVideos());
                  }
                });
              },
            ),
          ],
        ),
        body: BlocBuilder<VideosBloc, VideosState>(
          builder: (context, state) {
            if (state is VideosLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is VideosError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'خطأ في تحميل الفيديوهات',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<VideosBloc>().add(const LoadVideos());
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is VideosLoaded) {
              if (state.videos.isEmpty) {
                final selectedChildId = getIt<GetStorage>()
                    .read<String>('selected_child_id');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library_outlined,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        selectedChildId != null
                            ? 'لا توجد فيديوهات متاحة لاهتمامات الطفل المختار'
                            : 'لا توجد فيديوهات متاحة',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      if (selectedChildId != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'يمكنك اختيار طفل آخر من الإعدادات',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.videos.length,
                itemBuilder: (context, index) {
                  final video = state.videos[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.play_circle_outline, size: 40),
                      title: Text(
                        video.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => VideoPlayerScreen(video: video),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const Center(child: Text("فيديوهات"));
          },
        ),
      ),
    );
  }
}
