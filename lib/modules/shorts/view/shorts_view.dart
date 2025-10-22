// lib/modules/home/shorts_page.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart'; // clipboard for share

class ShortsPage extends StatefulWidget {
  const ShortsPage({Key? key}) : super(key: key);

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  final PageController _pageController = PageController();
  VideoPlayerController? _videoController;
  int _currentIndex = 0;

  // Dummy shorts data
  final List<Map<String, dynamic>> _shorts = [
    {
      'id': 's1',
      'title': 'Breaking — Market Opens Strong',
      'video':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'views': 12500,
    },
    {
      'id': 's2',
      'title': 'Election Update — Key Vote Today',
      'video':
          'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
      'views': 8400,
    },
    {
      'id': 's3',
      'title': 'Tech — New AI Chip Unveiled',
      'video': 'https://sample-videos.com/video321/mp4/720/sample-5s.mp4',
      'views': 4200,
    },
    {
      'id': 's4',
      'title': 'Sports — Last-Minute Goal!',
      'video':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'views': 21000,
    },
  ];

  // UI state: saved and liked indexes + like counts
  final Set<int> _saved = {};
  final Set<int> _liked = {};
  final Map<int, int> _likeCounts = {};

  @override
  void initState() {
    super.initState();
    // initialize like counts from dummy data (small base)
    for (var i = 0; i < _shorts.length; i++) {
      _likeCounts[i] = 100 + (i * 13);
    }
    _initVideoControllerForIndex(0);
  }

  Future<void> _initVideoControllerForIndex(int index) async {
    // dispose old controller
    await _disposeCurrentController();

    final url = _shorts[index]['video'] as String;
    _videoController = VideoPlayerController.network(url);
    try {
      await _videoController!.initialize();
      _videoController!
        ..setLooping(true)
        ..setVolume(
          0,
        ) // start muted; user can toggle volume via device or implement mute
        ..play();
      setState(() {});
    } catch (e) {
      // initialization failed; show fallback
      debugPrint('Video init failed: $e');
    }
  }

  Future<void> _disposeCurrentController() async {
    if (_videoController != null) {
      try {
        await _videoController!.pause();
        await _videoController!.dispose();
      } catch (_) {}
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _disposeCurrentController();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _initVideoControllerForIndex(index);
  }

  void _toggleLike(int index) {
    setState(() {
      if (_liked.contains(index)) {
        _liked.remove(index);
        _likeCounts[index] = (_likeCounts[index] ?? 0) - 1;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Removed like')));
      } else {
        _liked.add(index);
        _likeCounts[index] = (_likeCounts[index] ?? 0) + 1;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Liked')));
      }
    });
  }

  void _toggleSave(int index) {
    setState(() {
      if (_saved.contains(index)) {
        _saved.remove(index);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Removed from saved')));
      } else {
        _saved.add(index);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved')));
      }
    });
  }

  Future<void> _shareShort(int index) async {
    final item = _shorts[index];
    final shareText = '${item['title']} — Watch this short';
    // For now, copy link/text to clipboard as a simple share option
    await Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied short info to clipboard')),
    );
  }

  Widget _buildRightActions(int index, Color accent) {
    final isLiked = _liked.contains(index);
    final isSaved = _saved.contains(index);
    final likeCount = _likeCounts[index] ?? 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Spacer so buttons start lower on screen
        const SizedBox(height: 120),
        // Like
        Column(
          children: [
            IconButton(
              onPressed: () => _toggleLike(index),
              icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
              color: isLiked ? accent : Colors.white,
              iconSize: 30,
              tooltip: 'Like',
            ),
            const SizedBox(height: 4),
            Text(
              likeCount.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Save
        Column(
          children: [
            IconButton(
              onPressed: () => _toggleSave(index),
              icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),
              color: isSaved ? accent : Colors.white,
              iconSize: 28,
              tooltip: 'Save',
            ),
            const SizedBox(height: 4),
            const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Share
        Column(
          children: [
            IconButton(
              onPressed: () => _shareShort(index),
              icon: const Icon(Icons.share),
              color: Colors.white,
              iconSize: 28,
              tooltip: 'Share',
            ),
            const SizedBox(height: 4),
            const Text(
              'Share',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShortPage(int index) {
    final item = _shorts[index];
    final title = item['title'] as String;
    final views = item['views'] as int;
    final accent = Colors.red[800]!;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video (or fallback if not initialized yet)
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // toggle play/pause
            if (_videoController == null ||
                !_videoController!.value.isInitialized)
              return;
            setState(() {
              if (_videoController!.value.isPlaying) {
                _videoController!.pause();
              } else {
                _videoController!.play();
              }
            });
          },
          child:
              _videoController != null && _videoController!.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController!.value.size.width,
                    height: _videoController!.value.size.height,
                    child: VideoPlayer(_videoController!),
                  ),
                )
              : Container(color: Colors.black87),
        ),

        // Gradient overlay bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 240,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.65), Colors.transparent],
              ),
            ),
          ),
        ),

        // Bottom left: title + views
        Positioned(
          left: 14,
          bottom: 24,
          right: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.remove_red_eye, color: Colors.white70, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    '${_formatViews(views)} views',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Right side actions (like/save/share)
        Positioned(
          right: 8,
          bottom: 60,
          child: _buildRightActions(index, accent),
        ),

        // Top left: back or label (optional)
        Positioned(
          left: 8,
          top: 34,
          child: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),

        // Center: play overlay icon when paused
        if (_videoController == null ||
            !_videoController!.value.isInitialized ||
            !_videoController!.value.isPlaying)
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                (_videoController != null &&
                        _videoController!.value.isInitialized &&
                        !_videoController!.value.isPlaying)
                    ? Icons.play_arrow
                    : Icons.hourglass_empty,
                size: 44,
                color: Colors.white,
              ),
            ),
          ),

        // small hint top-center
        Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Swipe up / down for more shorts',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatViews(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // AppBar can be removed if you want immersive full-screen
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: _shorts.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return _buildShortPage(index);
        },
      ),
    );
  }
}
