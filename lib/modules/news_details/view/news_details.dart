import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/modules/news_details/controller/news_details_controller.dart';
import 'package:ap_news/modules/news_details/model/news_details_model.dart';
import 'package:ap_news/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({Key? key}) : super(key: key);

  // 🔹 Safe image loader with fallback
  Widget _safeNetworkImage(
    String? url, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    final image = (url ?? '').trim();
    Widget child = (image.isNotEmpty && image != 'null')
        ? Image.network(
            image,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _fallbackImage(width, height),
          )
        : _fallbackImage(width, height);

    return borderRadius != null
        ? ClipRRect(borderRadius: borderRadius, child: child)
        : child;
  }

  // 🔹 Reusable fallback image widget
 // 🔹 Reusable fallback image widget
Widget _fallbackImage(double? width, double? height) => Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/Ap-news_logo.png', // ✅ your local logo image
        width: width != null ? width * 0.5 : 120,
        height: height != null ? height * 0.5 : 120,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported,
          color: Colors.grey[400],
          size: 40,
        ),
      ),
    );


  @override
  Widget build(BuildContext context) {
    final NewsDetailController ctrl = Get.put(NewsDetailController());
    final themeController = Provider.of<ThemeController>(context);
    final isDarkTheme = themeController.isDarkMode;
    final primaryRed = Colors.red[800]!;

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        elevation: 3,
        backgroundColor: primaryRed,
        title: const Text('Article Details', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Obx(() {
        final a = ctrl.article.value;
        if (a == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final isVideoMode =
            ctrl.mode.value == 'video' && (a.videoUrl?.isNotEmpty ?? false);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------
              // Top Banner (video or image)
              // ----------------------------
              if (isVideoMode)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.black,
                      child: ctrl.isVideoInitialized.value
                          ? (ctrl.youtubeController != null
                              ? YoutubePlayer(
                                  controller: ctrl.youtubeController!,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.red,
                                  progressColors: const ProgressBarColors(
                                    playedColor: Colors.red,
                                    handleColor: Colors.redAccent,
                                  ),
                                )
                              : (ctrl.videoController != null
                                  ? AspectRatio(
                                      aspectRatio:
                                          ctrl.videoController!.value.aspectRatio,
                                      child: VideoPlayer(ctrl.videoController!),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    )))
                          : const Center(child: CircularProgressIndicator()),
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Row(
                        children: [
                          _videoControlButton(
                            ctrl.isMuted.value
                                ? Icons.volume_off
                                : Icons.volume_up,
                            ctrl.toggleMute,
                          ),
                          const SizedBox(width: 8),
                          _videoControlButton(
                            ctrl.isPlaying.value
                                ? Icons.pause
                                : Icons.play_arrow,
                            ctrl.togglePlayPause,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                _safeNetworkImage(
                  a.image,
                  height: 250,
                  fit: BoxFit.cover,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),

              // ----------------------------
              // Main Article Card
              // ----------------------------
              Container(
                margin: const EdgeInsets.all(16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                decoration: BoxDecoration(
                  color: isDarkTheme ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            a.category ?? (isVideoMode ? 'Video' : 'News'),
                            style: TextStyle(
                              color: primaryRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          a.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: isDarkTheme
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(a.author ?? 'AP Desk',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                            const SizedBox(width: 10),
                            const Icon(Icons.access_time,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(a.time ?? 'Just now',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                            const Spacer(),
                            const Icon(Icons.remove_red_eye,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            const Text('1.2k',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          a.summary ??
                              'This news update provides brief insights into the latest developments.',
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.grey[300]
                                : Colors.grey[700],
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          a.content ??
                              'Detailed content not available. Stay tuned for updates.',
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.grey[200]
                                : Colors.grey[800],
                            fontSize: 16,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share_outlined),
                            color: Colors.grey[700],
                            onPressed: ctrl.shareArticle,
                          ),
                          IconButton(
                            icon: Icon(
                              ctrl.isSaved.value
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              color: ctrl.isSaved.value
                                  ? primaryRed
                                  : Colors.grey[700],
                            ),
                            onPressed: ctrl.toggleSave,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ----------------------------
              // Recent Videos Section
              // ----------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Recent Videos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                final homeCtrl = Get.find<HomeController>();
                final recentVideos = homeCtrl.recentVideos;
                final isLoading = homeCtrl.isLoadingRecentVideos.value;
                final error = homeCtrl.recentVideosError.value;

                if (isLoading) {
                  return const SizedBox(
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (error.isNotEmpty || recentVideos.isEmpty) {
                  return SizedBox(
                    height: 220,
                    child: Center(
                      child: Text(
                        error.isNotEmpty
                            ? 'Failed to load recent videos'
                            : 'No recent videos available',
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentVideos.length,
                    itemBuilder: (context, index) {
                      final video = recentVideos[index];
                      return GestureDetector(
                        onTap: () {
                          final newsModel = NewsModel(
                            id: video.id,
                            title: video.title,
                            summary: video.summary,
                            content: video.summary,
                            image: video.image,
                            author: video.channelTitle ?? 'AP Desk',
                            time: video.time ?? 'Recent',
                            url: video.url,
                            category: video.category ?? 'Recent',
                            videoUrl: video.url,
                          );
                          Get.to(
                            () => const NewsDetailPage(),
                            arguments: {'mode': 'video', 'item': newsModel},
                          );
                        },
                        child: Container(
                          width: 300,
                          margin: EdgeInsets.only(
                            right: index == recentVideos.length - 1 ? 0 : 15,
                            left: index == 0 ? 8 : 0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Stack(
                              children: [
                                _safeNetworkImage(
                                  video.image,
                                  fit: BoxFit.cover,
                                  width: 300,
                                  height: double.infinity,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'RECENT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        video.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              blurRadius: 10,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          final newsModel = NewsModel(
                                            id: video.id,
                                            title: video.title,
                                            summary: video.summary,
                                            content: video.summary,
                                            image: video.image,
                                            author: 'AP Desk',
                                            time:
                                                video.time ?? 'Recent',
                                            url: video.url,
                                            category:
                                                video.category ?? 'Recent',
                                            videoUrl: video.url,
                                          );
                                          Get.to(
                                            () => const NewsDetailPage(),
                                            arguments: {
                                              'mode': 'video',
                                              'item': newsModel
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.play_arrow,
                                            size: 18),
                                        label: const Text('Play Now'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[800],
                                          foregroundColor: Colors.white,
                                          minimumSize: const Size(0, 40),
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                          ),
                                          elevation: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // 🔹 Reusable video control buttons
  Widget _videoControlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
