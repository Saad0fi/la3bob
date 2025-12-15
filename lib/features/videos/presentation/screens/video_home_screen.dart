import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:la3bob/features/profiles/presentation/bloc/porfile_bloc.dart';
import 'package:la3bob/features/videos/presentation/bloc/videos_bloc.dart';

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
                  padding: .all(2.w),
                  child: InkWell(
                    borderRadius: .circular(12.w),
                    onLongPress: () async {
                      context.read<PorfileBloc>().add(const LoadChildren());
                      await context.push('/profile');
                      if (context.mounted) {
                        context.read<VideosBloc>().add(const LoadVideos());
                      }
                    },
                    onTap: () {},
                    child: Padding(
                      padding: .all(2.w),
                      child: const Icon(Icons.settings),
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
                          style: TextStyle(
                            fontSize: 14.dp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(state.message, style: TextStyle(fontSize: 12.dp)),
                        SizedBox(height: 4.h),
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
                            size: 16.w,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            selectedChildId != null
                                ? 'لا توجد فيديوهات متاحة لاهتمامات الطفل المختار'
                                : 'لا توجد فيديوهات متاحة',
                            style: TextStyle(
                              fontSize: 12.dp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (selectedChildId != null) ...[
                            SizedBox(height: 2.h),
                            Text(
                              'يمكنك اختيار طفل آخر من الإعدادات',
                              style: TextStyle(fontSize: 10.dp),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  if (filteredVideos.isEmpty) {
                    return SingleChildScrollView(
                      padding: .all(4.w),
                      child: Column(
                        children: [
                          if (interests.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(bottom: 3.h, top: 2.h),
                              child: Wrap(
                                spacing: 2.w,
                                runSpacing: 2.h,
                                children: [
                                  ChoiceChip(
                                    label: const Text('الكل'),
                                    selected: selectedInterest == null,
                                    onSelected: (_) {
                                      context.read<VideosBloc>().add(
                                        const SelectInterest(null),
                                      );
                                    },
                                  ),
                                  ...interests.map((interest) {
                                    final isSelected =
                                        selectedInterest
                                            ?.toLowerCase()
                                            .trim() ==
                                        interest.toLowerCase().trim();
                                    return ChoiceChip(
                                      label: Text(interest),
                                      selected: isSelected,
                                      onSelected: (_) {
                                        context.read<VideosBloc>().add(
                                          SelectInterest(interest),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          SizedBox(height: 4.h),
                          Icon(
                            Icons.video_library_outlined,
                            size: 16.w,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'لا توجد فيديوهات لهذا الاهتمام',
                            style: TextStyle(
                              fontSize: 12.dp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: .all(4.w),
                    itemCount:
                        filteredVideos.length + (interests.isNotEmpty ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (interests.isNotEmpty && index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Wrap(
                            spacing: 2.w,
                            runSpacing: 2.h,
                            children: [
                              ChoiceChip(
                                label: const Text('الكل'),
                                selected: selectedInterest == null,
                                onSelected: (_) {
                                  context.read<VideosBloc>().add(
                                    const SelectInterest(null),
                                  );
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
                                    context.read<VideosBloc>().add(
                                      SelectInterest(interest),
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        );
                      }

                      final video =
                          filteredVideos[interests.isNotEmpty
                              ? index - 1
                              : index];
                      final thumbnailUrl = VideosBloc.getThumbnailUrl(
                        video.link,
                      );
                      return Card(
                        margin: EdgeInsets.only(bottom: 3.h),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            context.push('/tabs/videos/player', extra: video);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                child: thumbnailUrl.isNotEmpty
                                    ? Image.network(
                                        thumbnailUrl,
                                        width: double.infinity,
                                        height: 25.h,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: double.infinity,
                                                height: 25.h,
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.play_circle_outline,
                                                  size: 15.w,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Container(
                                                width: double.infinity,
                                                height: 25.h,
                                                color: Colors.grey[200],
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 1.w,
                                                      ),
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
                                padding: .all(4.w),
                                child: Text(
                                  video.title,
                                  style: TextStyle(
                                    fontSize: 12.dp,
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
