import 'package:ap_news/controllers/language_controller.dart';
import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/data/news_data.dart';
import 'package:ap_news/modules/bottom_navbar/bottom_navbar.dart';
import 'package:ap_news/modules/categories/view/categories_news.dart';
import 'package:ap_news/modules/custom_drawer/view/JoinASteam.dart';
import 'package:ap_news/modules/custom_drawer/view/custom_drawer.dart';
import 'package:ap_news/modules/home/controller/home_controller.dart';
import 'package:ap_news/modules/profile/view/profile_page.dart';
import 'package:ap_news/modules/trending/view/trending_page.dart';
import 'package:ap_news/modules/news_details/model/news_details_model.dart';
import 'package:ap_news/modules/news_details/view/news_details.dart';
import 'package:ap_news/modules/recent/view/recent_view.dart';
import 'package:ap_news/modules/shorts/view/shorts_view.dart';
import 'package:ap_news/modules/sports/view/cricket_view.dart';
import 'package:ap_news/modules/weather/weather_Card.dart';
import 'package:ap_news/modules/weather/weather_controller.dart';
import 'package:ap_news/utils/localization.dart';
import 'package:ap_news/models/live_video_model.dart';
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

  final HomeController _homeController = Get.put(HomeController());

  final List<String> tabs = [
    'Home',
    'Politics',
    'Business',
    'Technology',
    'Sports',
    'Entertainment',
    'Health',
    'Science'
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

    // Listen to language changes
    final languageController = Provider.of<LanguageController>(context, listen: false);
    languageController.addListener(_refreshArticlesOnLanguageChange);
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
        final liveVideos = _homeController.liveVideos;
        if (liveVideos.length > 1) {
          int next = _currentCarouselIndex + 1;
          if (next >= liveVideos.length) next = 0;
          _carouselController.animateToPage(
            next,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
      _startCarouselAnimation();
    });
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);
    switch (index) {
      case 1:
        Get.to(() => const TrendingPage());
        break;
      case 2:
        Get.to(() => const ShortsPage());
        break;
      case 3:
        Get.to(() => const RecentView());
        break;
      case 4:
        Get.to(() => const CricketPage());
        break;
      default:
    }
  }

  void _refreshArticlesOnLanguageChange() {
    // Refresh articles when language changes
    _homeController.fetchArticles();
  }

  @override
  void dispose() {
    final languageController = Provider.of<LanguageController>(context, listen: false);
    languageController.removeListener(_refreshArticlesOnLanguageChange);
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
  Joinme: () {
    Navigator.pop(context);
    Get.to(() => CareerApplyPage());
  },
  onProfile: () {
    Navigator.pop(context);
    Get.to(() => ProfilePage());
  },
  onPrivacyPolicy: () {
    Navigator.pop(context);
    // Navigate to Privacy Screen
    //Get.to(() => PrivacyPolicyPage());
  },
  onTerms: () {
    Navigator.pop(context);
   // Get.to(() => TermsPage());
  },
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _homeController.fetchInitialNews();
        },
        child: Column(
          children: [
            _buildTabBar(localizations),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHomeTab(),
                  // For each other tab, navigate to category page
                  CategoryNewsPage(category: 'Politics'),
                  CategoryNewsPage(category: 'Business'),
                  CategoryNewsPage(category: 'Technology'),
                  CategoryNewsPage(category: 'Sports'),
                  CategoryNewsPage(category: 'Entertainment'),
                  CategoryNewsPage(category: 'Health'),
                  CategoryNewsPage(category: 'Science'),
                ],
              ),
            ),
          ],
        ),
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
    final localizations = AppLocalizations.of(context);
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
          _buildRecentVideos(localizations),
          const SizedBox(height: 25),
          _buildNewsCards(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    final localizations = AppLocalizations.of(context);
    return Obx(() {
      final liveVideos = _homeController.liveVideos;
      final isLoading = _homeController.isLoadingLiveVideos.value;
      final error = _homeController.liveVideosError.value;

      if (isLoading) {
        return const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (error.isNotEmpty) {
        return SizedBox(
          height: 220,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_library_outlined,
                      size: 48,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Live videos are currently unavailable',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isDarkTheme ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please check back later or try refreshing',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if (liveVideos.isEmpty) {
        return SizedBox(
          height: 220,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.live_tv_outlined,
                      size: 48,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No live videos available right now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isDarkTheme ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for live content',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Start auto-sliding only if more than 1 video
      if (liveVideos.length > 1) {
        _startCarouselAnimation();
      }

      return SizedBox(
        height: 220,
        child: Stack(
          children: [
            PageView.builder(
              controller: _carouselController,
              itemCount: liveVideos.length,
              onPageChanged: (index) =>
                  setState(() => _currentCarouselIndex = index),
              itemBuilder: (context, index) {
                final video = liveVideos[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(video.image ?? ''),
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
                        // Always show "LIVE NOW" for live videos
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
                              child: Text(
                                localizations.live_now,
                                style: const TextStyle(
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
                                video.title,
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
                                  // Convert LiveVideo to NewsModel for details page
                                  final newsModel = NewsModel(
                                    id: video.id,
                                    title: video.title,
                                    summary: video.summary,
                                    content: video.summary,
                                    image: video.image,
                                    author: 'AP Desk',
                                    time: video.time ?? 'Live',
                                    url: video.url,
                                    category: video.category ?? 'Live',
                                    videoUrl: video.url,
                                  );

                                  // Navigate to video mode
                                  Get.to(
                                    () => const NewsDetailPage(),
                                    arguments: {'mode': 'video', 'item': newsModel},
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
                children: List.generate(liveVideos.length, (index) {
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
    });
  }

  Widget _buildRecentVideos(AppLocalizations localizations) {
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
                  'Recent Videos',
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
          Obx(() {
            final recentVideos = _homeController.recentVideos;
            final isLoading = _homeController.isLoadingRecentVideos.value;
            final error = _homeController.recentVideosError.value;

            if (isLoading) {
              return const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (error.isNotEmpty) {
              return SizedBox(
                height: 220,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library_outlined,
                            size: 48,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Recent videos are currently unavailable',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _isDarkTheme ? Colors.white : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please check back later or try refreshing',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (recentVideos.isEmpty) {
              return SizedBox(
                height: 220,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library_outlined,
                            size: 48,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No recent videos available right now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _isDarkTheme ? Colors.white : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back later for recent content',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
                      // Convert RecentVideo to NewsModel for details page
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

                      // Navigate to video mode
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
                        image: DecorationImage(
                          image: NetworkImage(video.image ?? ''),
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
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Convert RecentVideo to NewsModel for details page
                                    final newsModel = NewsModel(
                                      id: video.id,
                                      title: video.title,
                                      summary: video.summary,
                                      content: video.summary,
                                      image: video.image,
                                      author: 'AP Desk',
                                      time: video.time ?? 'Recent',
                                      url: video.url,
                                      category: video.category ?? 'Recent',
                                      videoUrl: video.url,
                                    );

                                    // Navigate to video mode
                                    Get.to(
                                      () => const NewsDetailPage(),
                                      arguments: {'mode': 'video', 'item': newsModel},
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
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNewsCards() {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${localizations.latest_news}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (_homeController.isLoadingArticles.value && _homeController.articlesList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_homeController.articlesError.value.isNotEmpty && _homeController.articlesList.isEmpty) {
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load news',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isDarkTheme ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please check your connection and try again',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                    !_homeController.isLoadingArticles.value &&
                    _homeController.hasMoreData.value) {
                  _homeController.loadMoreArticles();
                }
                return false;
              },
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _homeController.articlesList.length + (_homeController.hasMoreData.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _homeController.articlesList.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final news = _homeController.articlesList[index];
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
                          child: news.imageUrl.isNotEmpty && news.imageUrl != 'null'
                            ? Image.network(
                                news.imageUrl,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[600],
                                      size: 40,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[600],
                                  size: 40,
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
                                    news.category,
                                    style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  news.title,
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
                                  news.description,
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
                                      news.timeAgo,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: Icon(
                                        news.isSaved
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: news.isSaved
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () =>
                                          _homeController.toggleSave(news),
                                    ),
                                   TextButton(
  onPressed: () {
    // Convert News to NewsModel for details page
    final newsModel = NewsModel(
      id: news.articleId ?? news.title.hashCode.toString(),
      title: news.title,
      summary: news.description,
      content: news.content?.isNotEmpty == true
          ? news.content
          : news.description, // Prefer content, fallback to description
      image: news.imageUrl.isNotEmpty
          ? news.imageUrl
          : null, // Use featuredImage URL if available
      author: 'AP Desk',
      time: news.timeAgo,
      url: news.link,
      category: news.category,
      videoUrl: null, // Optionally handle video if you have one
    );

    // Open News Detail in article mode
    Get.to(
      () => const NewsDetailPage(),
      arguments: {
        'mode': 'article',
        'item': newsModel,
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
            );
          }),
        ],
      ),
    );
  }
}
