// lib/controllers/news_detail_controller.dart
import 'dart:async';
import 'package:ap_news/modules/news_details/model/news_details_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class NewsDetailController extends GetxController {
  /// The article to display (set from Get.arguments)
  late final NewsModel article;

  /// Mode: 'video' or 'article' (defaults to 'article' if not specified)
  late final String mode;

  /// Related articles (dummy if not provided)
  final RxList<NewsModel> related = <NewsModel>[].obs;

  /// Bookmark saved state
  final RxBool isSaved = false.obs;
  static const _kSavedKey = 'saved_news_ids';

  /// Video player controller (only used in video mode)
  VideoPlayerController? videoController;
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
      article = args;
      mode = 'article';
    } else if (argMap['item'] is NewsModel) {
      article = argMap['item'] as NewsModel;
      mode = (argMap['mode'] as String?) ?? (article.videoUrl?.isNotEmpty == true ? 'video' : 'article');
    } else if (argMap['item'] is Map<String, dynamic>) {
      article = NewsModel.fromMap(Map<String, dynamic>.from(argMap['item']));
      mode = (argMap['mode'] as String?) ?? (article.videoUrl?.isNotEmpty == true ? 'video' : 'article');
    } else if (argMap.isNotEmpty && argMap['title'] != null) {
      // direct map passed as item
      article = NewsModel.fromMap(argMap);
      mode = (argMap['mode'] as String?) ?? (article.videoUrl?.isNotEmpty == true ? 'video' : 'article');
    } else {
      // fallback default stub
      article = NewsModel(id: 'unknown', title: 'Article not provided');
      mode = 'article';
    }

    // Setup related: if provided as list of maps or models in args
    if (argMap['related'] is List) {
      final list = argMap['related'] as List;
      final parsed = list.map<NewsModel>((e) {
        if (e is NewsModel) return e;
        if (e is Map<String, dynamic>) return NewsModel.fromMap(e);
        return NewsModel(id: '${article.id}_rel', title: 'Related');
      }).toList();
      related.assignAll(parsed);
    } else {
      _makeDummyRelated();
    }

    _loadSavedState();

    // If mode is video, initialize video player
    if (mode == 'video' && article.videoUrl != null && article.videoUrl!.isNotEmpty) {
      _initVideo(article.videoUrl!);
    }
  }

  Future<void> _loadSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kSavedKey) ?? <String>[];
      isSaved.value = list.contains(article.id);
    } catch (_) {
      isSaved.value = false;
    }
  }

  Future<void> toggleSave() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kSavedKey) ?? <String>[];
    final id = article.id;
    if (list.contains(id)) {
      list.remove(id);
      isSaved.value = false;
      Get.snackbar('Bookmarks', 'Removed from saved', snackPosition: SnackPosition.BOTTOM);
    } else {
      list.add(id);
      isSaved.value = true;
      Get.snackbar('Bookmarks', 'Saved', snackPosition: SnackPosition.BOTTOM);
    }
    await prefs.setStringList(_kSavedKey, list);
  }

  Future<void> shareArticle() async {
    final text = article.url?.isNotEmpty == true ? article.url! : article.title;
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('Share', 'Copied link to clipboard', snackPosition: SnackPosition.BOTTOM);
  }

  void _makeDummyRelated() {
    final base = article.title.split(' ').take(3).join(' ');
    final List<NewsModel> rel = List.generate(4, (i) {
      return NewsModel(
        id: '${article.id}_r_$i',
        title: '$base — related ${i + 1}',
        summary: article.summary ?? 'Related short summary.',
        content: null,
        image: 'https://picsum.photos/800/450?random=${100 + i}',
        author: article.author,
        time: '${(i + 1) * 2}h ago',
        url: article.url,
      );
    });
    related.assignAll(rel);
  }

  // --- Video handling ---
  Future<void> _initVideo(String url) async {
    try {
      videoController = VideoPlayerController.network(url);
      await videoController!.initialize();
      videoController!
        ..setLooping(true)
        ..setVolume(isMuted.value ? 0 : 1)
        ..play();
      isVideoInitialized.value = true;
      isPlaying.value = true;
      // Listen to changes (optional)
      videoController!.addListener(() {
        if (!videoController!.value.isPlaying) {
          isPlaying.value = false;
        } else {
          isPlaying.value = true;
        }
      });
    } catch (e) {
      isVideoInitialized.value = false;
      isPlaying.value = false;
      Get.snackbar('Video', 'Could not initialize video', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> togglePlayPause() async {
    if (videoController == null || !isVideoInitialized.value) return;
    if (videoController!.value.isPlaying) {
      await videoController!.pause();
      isPlaying.value = false;
    } else {
      await videoController!.play();
      isPlaying.value = true;
    }
  }

  Future<void> toggleMute() async {
    if (videoController == null) return;
    isMuted.value = !isMuted.value;
    videoController!.setVolume(isMuted.value ? 0 : 1);
  }

  @override
  void onClose() {
    // dispose video controller if any
    try {
      videoController?.removeListener(() {});
      videoController?.pause();
      videoController?.dispose();
    } catch (_) {}
    super.onClose();
  }
}
