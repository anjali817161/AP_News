// lib/modules/home/category_news_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:ap_news/modules/news_details/view/news_details.dart';

class CategoryNewsPage extends StatefulWidget {
  final String category;
  final String videoUrl;
  final List<Map<String, String>>
  newsFeed; // keys: title, summary, image, time, url (optional)

  const CategoryNewsPage({
    Key? key,
    required this.category,
    required this.videoUrl,
    required this.newsFeed,
  }) : super(key: key);

  @override
  State<CategoryNewsPage> createState() => _CategoryNewsPageState();
}

class _CategoryNewsPageState extends State<CategoryNewsPage> {
  late VideoPlayerController _videoController;
  bool _videoInitialized = false;
  bool _isMuted = true;
  bool _isPlaying = true;

  // Track saved/bookmarked articles by index
  final Set<int> _savedIndices = {};

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.setVolume(_isMuted ? 0 : 1);
        _videoController.play();
        setState(() {
          _videoInitialized = true;
          _isPlaying = true;
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _togglePlay() {
    if (!_videoInitialized) return;
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _isPlaying = false;
      } else {
        _videoController.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleSave(int index) {
    setState(() {
      if (_savedIndices.contains(index)) {
        _savedIndices.remove(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from saved — ${widget.category}')),
        );
      } else {
        _savedIndices.add(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved article — ${widget.category}')),
        );
      }
    });
  }

  Future<void> _showShareOptions(Map<String, String> item) async {
    final url = item['url'] ?? '';
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Share',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: const Text('Copy Link'),
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: url.isNotEmpty ? url : item['title'].toString(),
                      ),
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
                // You can add other share integrations here (share_plus) if you want
                ListTile(
                  leading: const Icon(Icons.more_horiz),
                  title: const Text('More Options'),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Use native share integration (optional)',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(Color primaryRed) {
    // A card that mirrors the politics_page design
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row: category pill + small metadata
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryRed.withOpacity(0.12)),
                ),
                child: Text(
                  widget.category,
                  style: TextStyle(
                    color: primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              const Text('4.9', style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                'LIVE',
                style: TextStyle(
                  color: primaryRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Headline
          Text(
            _topHeadline(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // author / time / views
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                'By AP Desk',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.schedule, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                '2h ago',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.visibility, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                '18k views',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // description
          Text(
            'A summary of the headline and video content for the ${widget.category.toLowerCase()} category. This provides quick context to readers before they dive into the feed below.',
            style: TextStyle(color: Colors.grey[800], fontSize: 14),
          ),

          const SizedBox(height: 12),

          // Action row: watch / share / save
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // scroll to video or play/pause
                  if (_videoInitialized) {
                    _togglePlay();
                  }
                },
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                label: Text(
                  _isPlaying ? 'Pause' : 'Play',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  _showShareOptions({
                    'title': _topHeadline(),
                    'url': widget.newsFeed.isNotEmpty
                        ? widget.newsFeed[0]['url'] ?? ''
                        : '',
                  });
                },
                icon: const Icon(Icons.share, color: Colors.red),
                label: const Text('Share', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _topHeadline() {
    // pick either first news title or a default headline
    if (widget.newsFeed.isNotEmpty)
      return widget.newsFeed[0]['title'] ?? '${widget.category} Top Story';
    return '${widget.category} Top Story';
  }

  Widget _buildFeedCard(Map<String, String> item, int index, Color primaryRed) {
    final isSaved = _savedIndices.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              item['image'] ?? '',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) {
                return Container(
                  width: double.infinity,
                  height: 160,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey[400],
                    size: 48,
                  ),
                );
              },
            ),
          ),

          // content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['summary'] ?? '',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    Text(
                      item['time'] ?? '',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const Spacer(),

                    // Save (bookmark) icon
                    IconButton(
                      onPressed: () => _toggleSave(index),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      ),
                      color: isSaved ? primaryRed : Colors.grey[700],
                      tooltip: isSaved ? 'Saved' : 'Save',
                    ),

                    // Share icon
                    IconButton(
                      onPressed: () => _showShareOptions(item),
                      icon: const Icon(Icons.share_outlined),
                      color: Colors.grey[700],
                      tooltip: 'Share',
                    ),

                    // Read more button (kept lightweight)
                    TextButton(
                      onPressed: () {
                        // Navigate to NewsDetailPage
                        Get.to(
                          () => const NewsDetailPage(),
                          arguments: {'mode': 'article', 'item': item},
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        backgroundColor: Colors.red[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Read More',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryRed = Colors.red[800]!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        bottom: true,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top: video + info card
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Video container (rounded bottom)
                  Container(
                    width: double.infinity,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.black,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (_videoInitialized)
                            AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            )
                          else
                            const Center(child: CircularProgressIndicator()),

                          // gradient at bottom
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // category badge bottom-left
                          Positioned(
                            left: 16,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                widget.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // controls top-right
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: _toggleMute,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.35),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _isMuted
                                          ? Icons.volume_off
                                          : Icons.volume_up,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _togglePlay,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.35),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Info card
                  _buildInfoCard(primaryRed),
                ],
              ),
            ),

            // Feed list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = widget.newsFeed[index];
                  return _buildFeedCard(item, index, primaryRed);
                }, childCount: widget.newsFeed.length),
              ),
            ),

            // bottom spacing
            SliverToBoxAdapter(child: const SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}
