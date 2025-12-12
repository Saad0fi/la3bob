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
      child: Builder(
        builder: (context) {
          final box = getIt<GetStorage>();
          final currentChildId = box.read<String>('selected_child_id');
          final lastChildId = box.read<String>('last_videos_child_id');

          if (currentChildId != lastChildId) {
            box.write('last_videos_child_id', currentChildId);
            context.read<VideosBloc>().add(const LoadVideos());
          }

          return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text("فيديوهات")),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onLongPress: () async {
                      await Navigator.of(context).push<bool>(
                        MaterialPageRoute(builder: (_) => ProfileScreen()),
                      );

                      if (context.mounted) {
                        context.read<VideosBloc>().add(const LoadVideos());
                      }
                    },
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.settings),
                    ),
                  ),
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
                  final interests = state.interests;
                  final selectedInterest = state.selectedInterest;
                  final filteredVideos = selectedInterest == null
                      ? state.videos
                      : state.videos.where((video) {
                          return video.category.toLowerCase().trim() ==
                              selectedInterest.toLowerCase().trim();
                        }).toList();

                  if (state.videos.isEmpty) {
                    final selectedChildId = getIt<GetStorage>().read<String>(
                      'selected_child_id',
                    );
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
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

                  if (filteredVideos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.video_library_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            'لا توجد فيديوهات لهذا الاهتمام',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredVideos.length + (interests.isNotEmpty ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (interests.isNotEmpty && index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ChoiceChip(
                                label: const Text('الكل'),
                                selected: selectedInterest == null,
                                onSelected: (_) {
                                  context.read<VideosBloc>().add(const SelectInterest(null));
                                },
                              ),
                              ...interests.map((interest) {
                                final isSelected =
                                    selectedInterest?.toLowerCase().trim() ==
                                        interest.toLowerCase().trim();
                                return ChoiceChip(
                                  label: Text(interest),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    context.read<VideosBloc>().add(SelectInterest(interest));
                                  },
                                );
                              }),
                            ],
                          ),
                        );
                      }

                      final video = filteredVideos[interests.isNotEmpty ? index - 1 : index];
                      final thumbnailUrl = VideosBloc.getThumbnailUrl(video.link);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerScreen(video: video),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                child: thumbnailUrl.isNotEmpty
                                    ? Image.network(
                                        thumbnailUrl,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: 200,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.play_circle_outline,
                                              size: 60,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            width: double.infinity,
                                            height: 200,
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: CircularProgressIndicator(strokeWidth: 3),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.play_circle_outline,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  video.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text("فيديوهات"));
              },
            ),
          );
        },
      ),
    );
  }
}
