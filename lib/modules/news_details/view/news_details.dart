// lib/modules/news_details/view/news_details.dart
import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/modules/news_details/controller/news_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({Key? key}) : super(key: key);

  Widget _safeNetworkImage(
    String? url, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    final image = url ?? '';
    Widget child = image.isNotEmpty
        ? Image.network(
            image,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: Icon(Icons.broken_image, color: Colors.grey[400]),
            ),
          )
        : Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
          );
    return borderRadius != null
        ? ClipRRect(borderRadius: borderRadius, child: child)
        : child;
  }

  @override
  Widget build(BuildContext context) {
    final NewsDetailController ctrl = Get.put(NewsDetailController());
    final themeController = Provider.of<ThemeController>(context);
    final isDarkTheme = themeController.isDarkMode;
    final primaryRed = Colors.red[800]!;

    print('[DEBUG] NewsDetailPage.build called');
    print('[DEBUG] Video mode: ${ctrl.mode}');
    print(
      '[DEBUG] Video initialization status: ${ctrl.isVideoInitialized.value}',
    );

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        elevation: 3,
        backgroundColor: primaryRed,
        title: const Text(
          'Article Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final a = ctrl.article.value;
        if (a == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final isVideoMode =
            ctrl.mode.value == 'video' && a.videoUrl?.isNotEmpty == true;

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
                                          aspectRatio: ctrl
                                              .videoController!
                                              .value
                                              .aspectRatio,
                                          child: VideoPlayer(
                                            ctrl.videoController!,
                                          ),
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
                            () => ctrl.toggleMute(),
                          ),
                          const SizedBox(width: 8),
                          _videoControlButton(
                            ctrl.isPlaying.value
                                ? Icons.pause
                                : Icons.play_arrow,
                            () => ctrl.togglePlayPause(),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
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
                        // Category and headline
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
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
                            color: isDarkTheme ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              a.author ?? 'AP Desk',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              a.time ?? 'Just now',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.remove_red_eye,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '1.2k',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
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

                    // bottom-right floating share & save icons
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
              // Related News
              // ----------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Related Articles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ctrl.related.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Colors.black12),
                itemBuilder: (context, i) {
                  final r = ctrl.related[i];
                  return GestureDetector(
                    onTap: () {
                      final nextMode = (r.videoUrl?.isNotEmpty == true)
                          ? 'video'
                          : 'article';
                      ctrl.updateArticle(r, nextMode);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkTheme ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _safeNetworkImage(
                              r.image,
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  r.summary ??
                                      'A brief look into this related story.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDarkTheme
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      r.time ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.share_outlined,
                                        size: 20,
                                      ),
                                      color: Colors.grey[700],
                                      onPressed: () async {
                                        final text = r.url?.isNotEmpty == true
                                            ? r.url!
                                            : r.title;
                                        await Clipboard.setData(
                                          ClipboardData(text: text),
                                        );
                                        Get.snackbar(
                                          'Share',
                                          'Link copied',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.bookmark_outline,
                                        color: Colors.grey[700],
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        Get.snackbar(
                                          'Saved',
                                          'Added to your saved list',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                    ),
                                  ],
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
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

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
