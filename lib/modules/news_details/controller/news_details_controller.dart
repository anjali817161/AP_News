// lib/controllers/news_detail_controller.dart
import 'dart:async';
import 'package:ap_news/modules/news_details/model/news_details_model.dart';
import 'package:ap_news/modules/recent/model/recentNews_model.dart';
import 'package:ap_news/services/news_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsDetailController extends GetxController {
  /// The article to display (set from Get.arguments)
  Rx<NewsModel?> article = Rx<NewsModel?>(null);

  /// Mode: 'video' or 'article' (defaults to 'article' if not specified)
  RxString mode = ''.obs;

  /// Related articles (dummy if not provided)
  final RxList<NewsModel> related = <NewsModel>[].obs;

  /// Bookmark saved state
  final RxBool isSaved = false.obs;
  static const _kSavedKey = 'saved_news_ids';

  /// Video player controller (only used in video mode)
  VideoPlayerController? videoController;
  YoutubePlayerController? youtubeController;
  final RxBool isVideoInitialized = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isMuted = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Read arguments passed to this page:
    // Accepts Map or NewsModel or both: { 'mode': 'video'|'article', 'item': Map or NewsModel, 'related': [Map...] }
    final args = Get.arguments;
    Map<String, dynamic> argMap = {};
    if (args is Map<String, dynamic>) argMap = args;
    // fallback when single NewsModel passed directly
    if (args is NewsModel) {
      article.value = args;
      mode.value = 'article';
    } else if (argMap['item'] is NewsModel) {
      article.value = argMap['item'] as NewsModel;
      mode.value =
          (argMap['mode'] as String?) ??
          (article.value!.videoUrl?.isNotEmpty == true ? 'video' : 'article');
    } else if (argMap['item'] is Map<String, dynamic>) {
      article.value = NewsModel.fromMap(
        Map<String, dynamic>.from(argMap['item']),
      );
      mode.value =
          (argMap['mode'] as String?) ??
          (article.value!.videoUrl?.isNotEmpty == true ? 'video' : 'article');
    } else if (argMap.isNotEmpty && argMap['title'] != null) {
      // direct map passed as item
      article.value = NewsModel.fromMap(argMap);
      mode.value =
          (argMap['mode'] as String?) ??
          (article.value!.videoUrl?.isNotEmpty == true ? 'video' : 'article');
    } else {
      // fallback default stub
      article.value = NewsModel(id: 'unknown', title: 'Article not provided');
      mode.value = 'article';
    }

    // Setup related: if provided as list of maps or models in args
    if (argMap['related'] is List) {
      final list = argMap['related'] as List;
      final parsed = list.map<NewsModel>((e) {
        if (e is NewsModel) return e;
        if (e is Map<String, dynamic>) return NewsModel.fromMap(e);
        return NewsModel(id: '${article.value!.id}_rel', title: 'Related');
      }).toList();
      related.assignAll(parsed);
    } else {
      _makeDummyRelated();
    }

    _loadSavedState();

    // If mode is video, initialize video player
    if (mode.value == 'video' &&
        article.value!.videoUrl != null &&
        article.value!.videoUrl!.isNotEmpty) {
      _initVideo(article.value!.videoUrl!);
    }
  }

  Future<void> _loadSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kSavedKey) ?? <String>[];
      isSaved.value = list.contains(article.value!.id);
    } catch (_) {
      isSaved.value = false;
    }
  }

  Future<void> toggleSave() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kSavedKey) ?? <String>[];
    final id = article.value!.id;
    if (list.contains(id)) {
      list.remove(id);
      isSaved.value = false;
      Get.snackbar(
        'Bookmarks',
        'Removed from saved',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      list.add(id);
      isSaved.value = true;
      Get.snackbar('Bookmarks', 'Saved', snackPosition: SnackPosition.BOTTOM);
    }
    await prefs.setStringList(_kSavedKey, list);
  }

  Future<void> shareArticle() async {
    final text = article.value!.url?.isNotEmpty == true
        ? article.value!.url!
        : article.value!.title;
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Share',
      'Copied link to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _makeDummyRelated() async {
    try {
      final newsService = NewsService();
      final fetchedNews = await newsService.fetchLatestNews();
      if (fetchedNews.isNotEmpty) {
        final relatedNews = fetchedNews.take(4).map((news) {
          return NewsModel(
            id: news.articleId ?? news.title.hashCode.toString(),
            title: news.title,
            summary: news.description,
            content: news.description,
            image: news.imageUrl,
            author: 'AP Desk',
            time: news.timeAgo,
            url: news.link,
            category: news.category,
          );
        }).toList();
        related.assignAll(relatedNews);
      } else {
        // Fallback to dummy data if API fails
        final base = article.value!.title.split(' ').take(3).join(' ');
        final List<NewsModel> rel = List.generate(4, (i) {
          return NewsModel(
            id: '${article.value!.id}_r_$i',
            title: '$base — related ${i + 1}',
            summary: article.value!.summary ?? 'Related short summary.',
            content: null,
            image: 'https://picsum.photos/800/450?random=${100 + i}',
            author: article.value!.author,
            time: '${(i + 1) * 2}h ago',
            url: article.value!.url,
          );
        });
        related.assignAll(rel);
      }
    } catch (e) {
      // Fallback to dummy data if API fails
      final base = article.value!.title.split(' ').take(3).join(' ');
      final List<NewsModel> rel = List.generate(4, (i) {
        return NewsModel(
          id: '${article.value!.id}_r_$i',
          title: '$base — related ${i + 1}',
          summary: article.value!.summary ?? 'Related short summary.',
          content: null,
          image: 'https://picsum.photos/800/450?random=${100 + i}',
          author: article.value!.author,
          time: '${(i + 1) * 2}h ago',
          url: article.value!.url,
        );
      });
      related.assignAll(rel);
    }
  }

  /// Update the article and mode for navigation
  void updateArticle(NewsModel newArticle, String newMode) {
    article.value = newArticle;
    mode.value = newMode;

    // Reset video state
    isVideoInitialized.value = false;
    isPlaying.value = false;
    isMuted.value = true;

    // Dispose old controllers
    try {
      videoController?.removeListener(() {});
      videoController?.pause();
      videoController?.dispose();
      youtubeController?.dispose();
    } catch (_) {}

    videoController = null;
    youtubeController = null;

    // Load new saved state
    _loadSavedState();

    // Initialize video if needed
    if (mode.value == 'video' &&
        article.value!.videoUrl != null &&
        article.value!.videoUrl!.isNotEmpty) {
      _initVideo(article.value!.videoUrl!);
    }
  }

  // --- Video handling ---
  Future<void> _initVideo(String url) async {
    print('[DEBUG] _initVideo called with URL: $url');
    try {
      // Check if it's a YouTube URL
      if (url.contains('youtube.com') || url.contains('youtu.be')) {
        print('[DEBUG] Detected YouTube URL, using YoutubePlayerController');
        final videoId = YoutubePlayer.convertUrlToId(url);
        if (videoId != null) {
          youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: true,
              loop: true,
            ),
          );
          isVideoInitialized.value = true;
          isPlaying.value = true;
          print('[DEBUG] YouTube player initialized successfully');
        } else {
          throw Exception('Invalid YouTube URL');
        }
      } else {
        print('[DEBUG] Using VideoPlayerController for non-YouTube URL');
        videoController = VideoPlayerController.network(url);
        print('[DEBUG] Calling videoController.initialize()');
        await videoController!.initialize();
        print(
          '[DEBUG] Video initialized successfully. Aspect ratio: ${videoController!.value.aspectRatio}',
        );
        videoController!
          ..setLooping(true)
          ..setVolume(isMuted.value ? 0 : 1)
          ..play();
        isVideoInitialized.value = true;
        isPlaying.value = true;
        print(
          '[DEBUG] Video setup complete: looping, volume set, playing started',
        );
        // Listen to changes (optional)
        videoController!.addListener(() {
          if (!videoController!.value.isPlaying) {
            isPlaying.value = false;
          } else {
            isPlaying.value = true;
          }
        });
      }
    } catch (e) {
      print('[DEBUG] Video initialization failed with error: $e');
      print('[DEBUG] Error type: ${e.runtimeType}');
      isVideoInitialized.value = false;
      isPlaying.value = false;
      Get.snackbar(
        'Video',
        'Could not initialize video',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> togglePlayPause() async {
    if (youtubeController != null) {
      if (isPlaying.value) {
        youtubeController!.pause();
        isPlaying.value = false;
      } else {
        youtubeController!.play();
        isPlaying.value = true;
      }
    } else if (videoController != null && isVideoInitialized.value) {
      if (videoController!.value.isPlaying) {
        await videoController!.pause();
        isPlaying.value = false;
      } else {
        await videoController!.play();
        isPlaying.value = true;
      }
    }
  }

  Future<void> toggleMute() async {
    if (youtubeController != null) {
      if (isMuted.value) {
        youtubeController!.unMute();
        isMuted.value = false;
      } else {
        youtubeController!.mute();
        isMuted.value = true;
      }
    } else if (videoController != null) {
      isMuted.value = !isMuted.value;
      videoController!.setVolume(isMuted.value ? 0 : 1);
    }
  }

  @override
  void onClose() {
    // dispose video controllers if any
    try {
      videoController?.removeListener(() {});
      videoController?.pause();
      videoController?.dispose();
      youtubeController?.dispose();
    } catch (_) {}
    super.onClose();
  }
}
