import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:la3bob/core/comon/theme/app_color.dart';
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
            Future.microtask(
              () => context.read<VideosBloc>().add(const LoadVideos()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.accent,
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              title: Center(
                child: Text(
                  " فيديوهات لعبوب",
                  style: TextStyle(
                    fontSize: 25.dp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.all(2.w),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.w),
                    onLongPress: () async {
                      context.read<PorfileBloc>().add(const LoadChildren());
                      await context.push('/profile');
                      if (context.mounted) {
                        context.read<VideosBloc>().add(const LoadVideos());
                      }
                    },
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: const Icon(Icons.settings, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.backgroundStart,
                    AppColors.backgroundMiddle,
                    AppColors.backgroundEnd,
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
              child: BlocBuilder<VideosBloc, VideosState>(
                builder: (context, state) {
                  if (state is VideosLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 1.5.w,
                      ),
                    );
                  }

                  if (state is VideosError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 16.w,
                              color: AppColors.error,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'خطأ في تحميل الفيديوهات',
                              style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              state.message,
                              style: TextStyle(
                                fontSize: 12.dp,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5.h),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<VideosBloc>().add(
                                  const LoadVideos(),
                                );
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('إعادة المحاولة'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
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

                    // حالة لا توجد فيديوهات مطلقاً (للطفل المختار)
                    if (state.videos.isEmpty) {
                      final selectedChildId = getIt<GetStorage>().read<String>(
                        'selected_child_id',
                      );
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.videocam_off,
                                size: 16.w,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                selectedChildId != null
                                    ? 'لا توجد فيديوهات متاحة لاهتمامات الطفل المختار'
                                    : 'لا توجد فيديوهات متاحة',
                                style: TextStyle(
                                  fontSize: 13.dp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (selectedChildId != null) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  'يمكنك اختيار طفل آخر أو تعديل الاهتمامات من الإعدادات',
                                  style: TextStyle(
                                    fontSize: 10.dp,
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4.h),
                                OutlinedButton.icon(
                                  onPressed: () async {
                                    context.read<PorfileBloc>().add(
                                      const LoadChildren(),
                                    );
                                    await context.push('/profile');
                                    if (context.mounted) {
                                      context.read<VideosBloc>().add(
                                        const LoadVideos(),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.tune),
                                  label: const Text('تعديل الإعدادات'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: BorderSide(
                                      color: AppColors.primary.withOpacity(0.5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 1.5.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }

                    // حالة لا توجد فيديوهات لهذا الاهتمام المحدد
                    if (filteredVideos.isEmpty) {
                      return Column(
                        children: [
                          if (interests.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: _buildInterestChips(
                                context,
                                interests,
                                selectedInterest,
                                AppColors.primary,
                              ),
                            ),

                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(4.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.videocam_off,
                                      size: 16.w,
                                      color: Colors.grey.shade400,
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      'لا توجد فيديوهات لهذا الاهتمام',
                                      style: TextStyle(
                                        fontSize: 13.dp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'جرّب اختيار "الكل" أو اهتمام آخر.',
                                      style: TextStyle(
                                        fontSize: 10.dp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    // عرض قائمة الفيديوهات
                    return Column(
                      children: [
                        if (interests.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: _buildInterestChips(
                              context,
                              interests,
                              selectedInterest,
                              AppColors.accent,
                            ),
                          ),

                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              left: 4.w,
                              right: 4.w,
                              top: interests.isNotEmpty ? 0 : 4.w,
                              bottom: 4.w,
                            ),
                            itemCount: filteredVideos.length,
                            itemBuilder: (context, index) {
                              final video = filteredVideos[index];
                              final thumbnailUrl = VideosBloc.getThumbnailUrl(
                                video.link,
                              );

                              return Card(
                                margin: EdgeInsets.only(bottom: 4.h),
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    context.push('/video-player', extra: video);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // منطقة الصورة المصغرة للفيديو
                                      SizedBox(
                                        height: 22.h,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            if (thumbnailUrl.isNotEmpty)
                                              Image.network(
                                                thumbnailUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return _buildPlaceholder(
                                                        22.h,
                                                        AppColors.primary,
                                                      );
                                                    },
                                                loadingBuilder:
                                                    (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return _buildLoadingPlaceholder(
                                                        22.h,
                                                        AppColors.primary,
                                                      );
                                                    },
                                              )
                                            else
                                              _buildPlaceholder(
                                                22.h,
                                                AppColors.primary,
                                              ),
                                            // أيقونة تشغيل في المنتصف
                                            Center(
                                              child: Container(
                                                padding: EdgeInsets.all(2.w),
                                                width: 15.w,
                                                height: 15.w,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.cardBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Icon(
                                                  Icons.play_arrow_rounded,
                                                  size: 10.w,
                                                  color: AppColors.accent,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // منطقة العنوان والتصنيف
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.w,
                                          vertical: 4.w,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // العنوان
                                            Text(
                                              video.title,
                                              style: TextStyle(
                                                fontSize: 13.dp,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.textPrimary,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 1.h),

                                            // التصنيف
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 3.w,
                                                vertical: 1.5.w,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                video.category,
                                                style: TextStyle(
                                                  fontSize: 9.dp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.cardBackground,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return Center(
                    child: Text(
                      "فيديوهات",
                      style: TextStyle(
                        fontSize: 14.dp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// التابع المساعد لبناء شرائح الاهتمامات
Widget _buildInterestChips(
  BuildContext context,
  List<String> interests,
  String? selectedInterest,
  Color primaryColor,
) {
  return Padding(
    padding: EdgeInsets.only(bottom: 3.h, top: 1.h),
    child: Wrap(
      spacing: 2.w,
      runSpacing: 1.5.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'التصنيفات:',
          style: TextStyle(
            fontSize: 11.dp,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
          textDirection: TextDirection.rtl,
        ),
        ChoiceChip(
          label: const Text('الكل'),
          selected: selectedInterest == null,
          selectedColor: AppColors.accent.withOpacity(0.8),
          labelStyle: TextStyle(
            color: selectedInterest == null ? Colors.white : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 10.dp,
          ),
          backgroundColor: AppColors.categoryChipBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
            selectedColor: AppColors.accent.withOpacity(0.8),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 10.dp,
            ),
            backgroundColor: AppColors.categoryChipBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (_) {
              context.read<VideosBloc>().add(SelectInterest(interest));
            },
          );
        }),
      ],
    ),
  );
}

// **********************************************
// التوابع المساعدة لحالة التحميل/الخطأ في الصورة
// **********************************************
Widget _buildPlaceholder(double height, Color color) {
  return Container(
    width: double.infinity,
    height: height,
    color: color.withOpacity(0.2),
    child: Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: 15.w,
        color: color.withOpacity(0.6),
      ),
    ),
  );
}

Widget _buildLoadingPlaceholder(double height, Color color) {
  return Container(
    width: double.infinity,
    height: height,
    color: Colors.grey.shade200,
    child: Center(
      child: CircularProgressIndicator(color: color, strokeWidth: 1.w),
    ),
  );
}
