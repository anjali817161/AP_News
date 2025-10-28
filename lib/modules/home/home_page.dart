// lib/modules/home/home_page.dart
import 'package:ap_news/controllers/language_controller.dart';
import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/modules/bottom_navbar/bottom_navbar.dart';
import 'package:ap_news/modules/categories/view/categories_news.dart';
import 'package:ap_news/modules/custom_drawer/view/custom_drawer.dart';
import 'package:ap_news/modules/learning/view/learning_page.dart';
import 'package:ap_news/modules/news_details/view/news_details.dart';
import 'package:ap_news/modules/read/view/read_page.dart';
import 'package:ap_news/modules/shorts/view/shorts_view.dart';
import 'package:ap_news/modules/sports/view/cricket_view.dart';
import 'package:ap_news/modules/weather/weather_Card.dart';
import 'package:ap_news/modules/weather/weather_controller.dart';
import 'package:ap_news/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;
  int _currentBottomNavIndex = 0;
  bool _isBlinking = true;

  bool _isDarkTheme = false;
  bool _isHindi = false;

  final List<String> tabs = [
    'Home',
    'Politics',
    'Business',
    'Technology',
    'Sports',
    'Entertainment',
    'Health',
    'Science',
  ];

  final List<Map<String, dynamic>> carouselItems = [
    {
      'title': 'Breaking: Major Economic Summit Concludes',
      'image': 'https://picsum.photos/400/200?random=1',
      'isLive': true,
      'content':
          'The major economic summit has concluded with significant announcements on global trade policies and economic reforms.',
    },
    {
      'title': 'Live: Climate Change Conference 2024',
      'image': 'https://picsum.photos/400/200?random=2',
      'isLive': true,
      'content':
          'The Climate Change Conference 2024 is underway, discussing urgent measures to combat global warming and environmental challenges.',
    },
    {
      'title': 'Sports Championship Finals',
      'image': 'https://picsum.photos/400/200?random=3',
      'isLive': false,
      'content':
          'The sports championship finals delivered thrilling moments with unexpected twists and a memorable victory for the underdogs.',
    },
  ];

  // Sample news cards (home feed)
  final List<Map<String, dynamic>> newsCards = [
    {
      'title': 'Bihar Announces New Industrial Policy',
      'summary':
          'Comprehensive industrial reform package to promote investment...',
      'image': 'https://picsum.photos/300/200?random=4',
      'time': '2h ago',
      'category': 'Business',
      'content':
          'The Bihar government has unveiled a new industrial policy aimed at transforming the state into an investment hub...',
    },
    {
      'title': 'Tech Giant Launches New AI Platform',
      'summary': 'Revolutionary artificial intelligence system unveiled...',
      'image': 'https://picsum.photos/300/200?random=5',
      'time': '6h ago',
      'category': 'Technology',
      'content':
          'A leading technology company introduced a groundbreaking AI platform designed to accelerate global innovation...',
    },
    {
      'title': 'Sports Team Wins Championship',
      'summary': 'Historic victory in national sports tournament...',
      'image': 'https://picsum.photos/300/200?random=6',
      'time': '8h ago',
      'category': 'Sports',
      'content':
          'Fans flooded the streets as their team clinched a dramatic victory in the national finals after a nail-biting finish...',
    },
  ];

  // Video list (uses only the YouTube links you provided)
  final List<Map<String, dynamic>> videoList = [
    {
      'title': 'Breaking News: Bihar Political Update',
      'image': 'https://img.youtube.com/vi/An2vMrJbWjA/maxresdefault.jpg',
      'url': 'https://youtu.be/An2vMrJbWjA?si=zQFpKUdUvjQABgvD',
      'summary': 'Latest update from the Bihar Assembly session today.',
    },
    {
      'title': 'Economic Reforms in Bihar',
      'image': 'https://img.youtube.com/vi/r-Zb9SFfc6s/maxresdefault.jpg',
      'url': 'https://youtu.be/r-Zb9SFfc6s?si=0vM7969zGTr4Ex9H',
      'summary': 'New economic initiatives and budget reforms explained.',
    },
    {
      'title': 'Sports Championship Highlights',
      'image': 'https://img.youtube.com/vi/JzIloLMszm4/maxresdefault.jpg',
      'url': 'https://youtu.be/JzIloLMszm4?si=LicAWrIsXHFEYByd',
      'summary': 'All the thrilling moments from this week’s finals.',
    },
    {
      'title': 'Entertainment Industry Buzz',
      'image': 'https://img.youtube.com/vi/crplFT-RSQo/maxresdefault.jpg',
      'url': 'https://youtu.be/crplFT-RSQo?si=RBhYhJmWLDLKQmFZ',
      'summary': 'Bollywood and Hollywood updates you can’t miss.',
    },
    {
      'title': 'Health and Wellness News',
      'image': 'https://img.youtube.com/vi/RVSR5PCv2LY/maxresdefault.jpg',
      'url': 'https://youtu.be/RVSR5PCv2LY?si=u6AbpQ-3angp09Ab',
      'summary': 'Quick tips and health headlines.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _startCarouselAnimation();
    _startBlinkingAnimation();

    // fetch weather on startup (if controller exists)
    try {
      final WeatherController weatherCtrl = Get.find<WeatherController>();
      // call after a tiny delay to ensure bindings ready
      Future.delayed(const Duration(milliseconds: 250), () {
        weatherCtrl.fetchByDeviceLocation();
      });
    } catch (e) {
      // controller not found — ignore
    }
  }

  void _startBlinkingAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isBlinking = !_isBlinking);
      _startBlinkingAnimation();
    });
  }

  void _startCarouselAnimation() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      if (_carouselController.hasClients) {
        int next = _currentCarouselIndex + 1;
        if (next >= carouselItems.length) next = 0;
        _carouselController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      _startCarouselAnimation();
    });
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);
    switch (index) {
      case 1:
        Get.to(() => const LearningPage());
        break;
      case 2:
        Get.to(() => const ShortsPage());
        break;
      case 3:
        Get.to(() => const ReadPage());
        break;
      case 4:
        Get.to(() => const CricketPage());
        break;
      default:
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final languageController = Provider.of<LanguageController>(context);
    final localizations = AppLocalizations.of(context);

    _isDarkTheme = themeController.isDarkMode;
    _isHindi = languageController.currentLanguage == 'hi';

    return Scaffold(
      backgroundColor: _isDarkTheme ? Colors.grey[900] : Colors.grey[50],
      drawer: CustomAppDrawer(
        onProfile: () => Navigator.pop(context),
        onPrivacyPolicy: () => Navigator.pop(context),
        onTerms: () => Navigator.pop(context),
        onLogout: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isHindi ? 'लॉगआउट किया गया' : 'Logged out'),
            ),
          );
        },
      ),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(localizations),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHomeTab(),
                // For each other tab, navigate to category page with appropriate sample content
                CategoryNewsPage(
                  category: 'Politics',
                  videoUrl: videoList[0]['url'],
                  newsFeed: [
                    {
                      'title':
                          'Government Introduces New Electoral Reform Bill',
                      'summary':
                          'The proposal aims to modernize voting systems.',
                      'image': 'https://picsum.photos/800/450?random=201',
                      'time': '30m ago',
                      'url': 'https://example.com/politics1',
                    },
                    {
                      'title': 'Prime Minister Addresses National Assembly',
                      'summary': 'A spirited speech outlining key policies.',
                      'image': 'https://picsum.photos/800/450?random=202',
                      'time': '2h ago',
                      'url': 'https://example.com/politics2',
                    },
                  ],
                ),
                CategoryNewsPage(
                  category: 'Business',
                  videoUrl: videoList[1]['url'],
                  newsFeed: [
                    {
                      'title': 'Stock Market Hits Record High',
                      'summary': 'Investors optimistic after inflation cools.',
                      'image': 'https://picsum.photos/800/450?random=301',
                      'time': '1h ago',
                      'url': 'https://example.com/business1',
                    },
                    {
                      'title': 'Tech Giants Lead Earnings Rally',
                      'summary': 'Strong quarterly results push indexes up.',
                      'image': 'https://picsum.photos/800/450?random=302',
                      'time': '3h ago',
                      'url': 'https://example.com/business2',
                    },
                  ],
                ),
                CategoryNewsPage(
                  category: 'Technology',
                  videoUrl: videoList[2]['url'],
                  newsFeed: [
                    {
                      'title': 'AI Startup Unveils Next-Gen Chatbot',
                      'summary': 'Promising to speed up developer workflows.',
                      'image': 'https://picsum.photos/800/450?random=401',
                      'time': '45m ago',
                      'url': 'https://example.com/tech1',
                    },
                    {
                      'title': 'Security Patch Released for Major OS',
                      'summary': 'Patch addresses critical vulnerability.',
                      'image': 'https://picsum.photos/800/450?random=402',
                      'time': '3h ago',
                      'url': 'https://example.com/tech2',
                    },
                  ],
                ),
                CategoryNewsPage(
                  category: 'Sports',
                  videoUrl: videoList[3]['url'],
                  newsFeed: [
                    {
                      'title': 'Home Team Clinches Championship',
                      'summary': 'Late penalty secures dramatic victory.',
                      'image': 'https://picsum.photos/800/450?random=501',
                      'time': '15m ago',
                      'url': 'https://example.com/sports1',
                    },
                    {
                      'title': 'Olympic Committee Announces New Game Lineup',
                      'summary': 'Three new sports will debut next summer.',
                      'image': 'https://picsum.photos/800/450?random=502',
                      'time': '1h ago',
                      'url': 'https://example.com/sports2',
                    },
                  ],
                ),
                CategoryNewsPage(
                  category: 'Entertainment',
                  videoUrl: videoList[4]['url'],
                  newsFeed: [
                    {
                      'title': 'Blockbuster Film Crosses 1B Worldwide',
                      'summary': 'Record-breaking box office numbers.',
                      'image': 'https://picsum.photos/800/450?random=601',
                      'time': '2h ago',
                      'url': 'https://example.com/ent1',
                    },
                    {
                      'title': 'Actor Announces New Project',
                      'summary':
                          'A drama exploring themes of loss and redemption.',
                      'image': 'https://picsum.photos/800/450?random=602',
                      'time': '6h ago',
                      'url': 'https://example.com/ent2',
                    },
                  ],
                ),
                CategoryNewsPage(
                  category: 'Health',
                  videoUrl: videoList[0]['url'],
                  newsFeed: [
                    {
                      'title': 'WHO Issues New Healthy Lifestyle Guidelines',
                      'summary':
                          'Recommendations for increased physical activity.',
                      'image': 'https://picsum.photos/800/450?random=701',
                      'time': '1h ago',
                      'url': 'https://example.com/health1',
                    },
                    {
                      'title': 'Breakthrough in Cancer Trials',
                      'summary':
                          'Early results show promising remission rates.',
                      'image': 'https://picsum.photos/800/450?random=702',
                      'time': '4h ago',
                      'url': 'https://example.com/health2',
                    },
                  ],
                ),
                CategoryNewsPage(
                  category: 'Science',
                  videoUrl: videoList[1]['url'],
                  newsFeed: [
                    {
                      'title': 'NASA Unveils Lunar Exploration Plan',
                      'summary': 'Artemis next phase includes crewed missions.',
                      'image': 'https://picsum.photos/800/450?random=801',
                      'time': '3h ago',
                      'url': 'https://example.com/science1',
                    },
                    {
                      'title': 'Fusion Energy Breakthrough',
                      'summary':
                          'Sustained reaction times with net positive output.',
                      'image': 'https://picsum.photos/800/450?random=802',
                      'time': '6h ago',
                      'url': 'https://example.com/science2',
                    },
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.red[800],
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu_open_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      ),
      title: Container(
        height: 54,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Image.asset(
          'assets/images/Ap-news_logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AP',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'NEWS',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkTheme ? Colors.grey[800] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.red[800],
        unselectedLabelColor: _isDarkTheme
            ? Colors.grey[300]
            : Colors.grey[700],
        indicatorColor: Colors.red[800],
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tabs: tabs
            .map((tab) => Tab(text: localizations.getLocalizedTab(tab)))
            .toList(),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildCarousel(),
          const SizedBox(height: 25),
          const WeatherCard(),
          const SizedBox(height: 25),
          _buildMoreVideos(),
          const SizedBox(height: 25),
          _buildNewsCards(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          PageView.builder(
            controller: _carouselController,
            itemCount: carouselItems.length,
            onPageChanged: (index) =>
                setState(() => _currentCarouselIndex = index),
            itemBuilder: (context, index) {
              final item = carouselItems[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(item['image']),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (item['isLive'] == true)
                        Positioned(
                          top: 15,
                          right: 15,
                          child: AnimatedOpacity(
                            opacity: _isBlinking ? 1.0 : 0.3,
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'LIVE NOW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 70,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(
                                  () => const NewsDetailPage(),
                                  arguments: {'mode': 'article', 'item': item},
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[800],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Watch Now'),
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
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(carouselItems.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentCarouselIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentCarouselIndex == index
                        ? Colors.red[800]!
                        : Colors.white.withOpacity(0.6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreVideos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📹 More Videos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isDarkTheme ? Colors.white : Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[100]!),
                  ),
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                final video = videoList[index];

                // Prepare a map with 'videoUrl' for NewsDetailController compatibility
                final navItem = {
                  'title': video['title'],
                  'summary': video['summary'] ?? '',
                  'image': video['image'],
                  'time': video['time'] ?? '',
                  'url': video['url'],
                  'videoUrl':
                      video['url'], // important: ensures controller sees videoUrl
                };

                return GestureDetector(
                  onTap: () {
                    print('[DEBUG] Video tapped: ${video['title']}');
                    print('[DEBUG] Video URL: ${video['url']}');
                    print('[DEBUG] NavItem: $navItem');
                    // Navigate to details page in video mode and play in-app
                    Get.to(
                      () => const NewsDetailPage(),
                      arguments: {'mode': 'video', 'item': navItem},
                    );
                  },
                  child: Container(
                    width: 300,
                    margin: EdgeInsets.only(
                      right: index == videoList.length - 1 ? 0 : 15,
                      left: index == 0 ? 8 : 0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: NetworkImage(video['image']),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            video['title'],
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
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Navigate to in-app news details page and play video
                                  Get.to(
                                    () => const NewsDetailPage(),
                                    arguments: {
                                      'mode': 'video',
                                      'item': navItem,
                                    },
                                  );
                                },
                                icon: const Icon(Icons.play_arrow, size: 18),
                                label: const Text('Play Now'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[800],
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 40),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '📰 Latest News',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: newsCards.length,
            itemBuilder: (context, index) {
              final news = newsCards[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _isDarkTheme ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.network(
                        news['image'],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red[100]!),
                              ),
                              child: Text(
                                news['category'],
                                style: TextStyle(
                                  color: Colors.red[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              news['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _isDarkTheme
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              news['summary'],
                              style: TextStyle(
                                fontSize: 14,
                                color: _isDarkTheme
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  news['time'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // Open News Detail in article mode
                                    Get.to(
                                      () => const NewsDetailPage(),
                                      arguments: {
                                        'mode': 'article',
                                        'item': news,
                                      },
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
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
