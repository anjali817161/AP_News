// lib/modules/home/home_page.dart
import 'package:ap_news/controllers/language_controller.dart';
import 'package:ap_news/controllers/theme_controller.dart';
import 'package:ap_news/modules/bottom_navbar/bottom_navbar.dart';
import 'package:ap_news/modules/categories/view/categories_news.dart';
import 'package:ap_news/modules/custom_drawer/view/custom_drawer.dart';
import 'package:ap_news/modules/learning/view/learning_page.dart';
import 'package:ap_news/modules/settings/view/settings_page.dart';
import 'package:ap_news/modules/read/view/read_page.dart';
import 'package:flutter/material.dart';
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

  // Local mirrors for UI; main state lives in controllers
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
    },
    {
      'title': 'Live: Climate Change Conference 2024',
      'image': 'https://picsum.photos/400/200?random=2',
      'isLive': true,
    },
    {
      'title': 'Sports Championship Finals',
      'image': 'https://picsum.photos/400/200?random=3',
      'isLive': false,
    },
  ];

  final List<Map<String, dynamic>> newsCards = [
    {
      'title': 'Bihar Announces New Industrial Policy',
      'summary':
          'Comprehensive industrial reform package to promote investment...',
      'image': 'https://picsum.photos/300/200?random=4',
      'time': '2h ago',
      'category': 'Business',
    },
    {
      'title': 'Global Markets Show Positive Trends',
      'summary': 'Stock markets worldwide experience significant growth...',
      'image': 'https://picsum.photos/300/200?random=5',
      'time': '4h ago',
      'category': 'Finance',
    },
    {
      'title': 'Tech Giant Launches New AI Platform',
      'summary': 'Revolutionary artificial intelligence system unveiled...',
      'image': 'https://picsum.photos/300/200?random=6',
      'time': '6h ago',
      'category': 'Technology',
    },
    {
      'title': 'Sports Team Wins Championship',
      'summary': 'Historic victory in national sports tournament...',
      'image': 'https://picsum.photos/300/200?random=7',
      'time': '8h ago',
      'category': 'Sports',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    _startCarouselAnimation();
    _startBlinkingAnimation();
  }

  void _startBlinkingAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isBlinking = !_isBlinking;
        });
        _startBlinkingAnimation();
      }
    });
  }

  void _startCarouselAnimation() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_carouselController.hasClients) {
        int nextPage = _currentCarouselIndex + 1;
        if (nextPage >= carouselItems.length) nextPage = 0;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startCarouselAnimation();
      }
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LearningPage()),
        );
        break;
      case 2:
        _showSearchDialog();
        break;
      case 3:
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
        break;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Search Flight',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField('From', Icons.flight_takeoff),
            const SizedBox(height: 10),
            _buildSearchField('To', Icons.flight_land),
            const SizedBox(height: 15),
            _buildFilterSection(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.red),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data Filter',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        _buildFilterOption('Default', true),
        _buildFilterOption('Status: True', false),
        _buildFilterOption('Error: False', false),
      ],
    );
  }

  Widget _buildFilterOption(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.red[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? Colors.red! : Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? Colors.red : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
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

    _isDarkTheme = themeController.isDarkMode;
    _isHindi = languageController.currentLanguage == 'hi';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: CustomAppDrawer(
        isDarkTheme: _isDarkTheme,
        isHindi: _isHindi,
        onThemeChanged: (val) {
          // If your ThemeController uses toggleTheme(), this works.
          // Replace with themeController.setDarkMode(val) if different.
          try {
            themeController.toggleTheme();
          } catch (_) {
            // fallback if your controller uses a different API
            // themeController.setDarkMode(val);
          }
          setState(() => _isDarkTheme = val);
        },
        onLanguageChanged: (isHindi) {
          languageController.changeLanguage(isHindi ? 'hi' : 'en');
          setState(() => _isHindi = isHindi);
        },
        onProfile: () {
          Navigator.pop(context);
        },
        onPrivacyPolicy: () {
          Navigator.pop(context);
        },
        onTerms: () {
          Navigator.pop(context);
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
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHomeTab(), // <-- defined below
                // _buildPlaceholderTab('Politics'),

                // 🗳 POLITICS
                CategoryNewsPage(
                  category: 'Politics',
                  videoUrl:
                      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                  newsFeed: [
                    {
                      'title':
                          'Government Introduces New Electoral Reform Bill',
                      'summary':
                          'The proposal aims to modernize voting systems and increase transparency across all districts.',
                      'image': 'https://picsum.photos/800/450?random=201',
                      'time': '30m ago',
                      'url': 'https://example.com/politics1',
                    },
                    {
                      'title': 'Prime Minister Addresses National Assembly',
                      'summary':
                          'In a spirited speech, the Prime Minister outlined upcoming economic and social policies.',
                      'image': 'https://picsum.photos/800/450?random=202',
                      'time': '2h ago',
                      'url': 'https://example.com/politics2',
                    },
                    {
                      'title': 'Opposition Stages Walkout Over Policy Debate',
                      'summary':
                          'A heated exchange in Parliament led to a temporary adjournment amid protests.',
                      'image': 'https://picsum.photos/800/450?random=203',
                      'time': '5h ago',
                      'url': 'https://example.com/politics3',
                    },
                    {
                      'title': 'Regional Leaders Convene for Security Dialogue',
                      'summary':
                          'The summit focused on strengthening cooperation against border infiltration.',
                      'image': 'https://picsum.photos/800/450?random=204',
                      'time': '9h ago',
                      'url': 'https://example.com/politics4',
                    },
                  ],
                ),

                // 💼 BUSINESS
                CategoryNewsPage(
                  category: 'Business',
                  videoUrl:
                      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                  newsFeed: [
                    {
                      'title':
                          'Stock Market Hits Record High as Inflation Cools',
                      'summary':
                          'Investors are optimistic after new data indicated a slowdown in price growth.',
                      'image': 'https://picsum.photos/800/450?random=301',
                      'time': '1h ago',
                      'url': 'https://example.com/business1',
                    },
                    {
                      'title': 'Tech Giants Lead Quarterly Earnings Rally',
                      'summary':
                          'Apple and Google exceeded analyst expectations, driving the NASDAQ upward.',
                      'image': 'https://picsum.photos/800/450?random=302',
                      'time': '3h ago',
                      'url': 'https://example.com/business2',
                    },
                    {
                      'title': 'Central Bank Maintains Current Interest Rate',
                      'summary':
                          'Policy makers remain cautious amid mixed economic signals from global markets.',
                      'image': 'https://picsum.photos/800/450?random=303',
                      'time': '5h ago',
                      'url': 'https://example.com/business3',
                    },
                  ],
                ),

                // 💻 TECHNOLOGY
                CategoryNewsPage(
                  category: 'Technology',
                  videoUrl:
                      'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                  newsFeed: [
                    {
                      'title':
                          'AI Startup Unveils Next-Gen Chatbot Capable of Coding',
                      'summary':
                          'The breakthrough system promises to revolutionize software development workflows.',
                      'image': 'https://picsum.photos/800/450?random=401',
                      'time': '45m ago',
                      'url': 'https://example.com/tech1',
                    },
                    {
                      'title': 'Major Security Patch Released for Popular OS',
                      'summary':
                          'Experts urge users to update immediately to avoid a critical exploit vulnerability.',
                      'image': 'https://picsum.photos/800/450?random=402',
                      'time': '3h ago',
                      'url': 'https://example.com/tech2',
                    },
                    {
                      'title': 'Quantum Computing Makes Significant Leap',
                      'summary':
                          'Researchers demonstrate 200-qubit stable operations — a key step toward real-world use.',
                      'image': 'https://picsum.photos/800/450?random=403',
                      'time': '7h ago',
                      'url': 'https://example.com/tech3',
                    },
                  ],
                ),

                // ⚽ SPORTS
                CategoryNewsPage(
                  category: 'Sports',
                  videoUrl:
                      'https://sample-videos.com/video321/mp4/720/sample-5s.mp4',
                  newsFeed: [
                    {
                      'title':
                          'Home Team Clinches Championship in Thrilling Finale',
                      'summary':
                          'A late penalty sealed the victory as fans erupted in celebration across the city.',
                      'image': 'https://picsum.photos/800/450?random=501',
                      'time': '15m ago',
                      'url': 'https://example.com/sports1',
                    },
                    {
                      'title': 'Olympic Committee Announces New Game Lineup',
                      'summary':
                          'Three new sports will debut next summer, reflecting youth and global trends.',
                      'image': 'https://picsum.photos/800/450?random=502',
                      'time': '1h ago',
                      'url': 'https://example.com/sports2',
                    },
                    {
                      'title': 'Star Player Signs Historic Contract Extension',
                      'summary':
                          'The deal reportedly makes him the highest-paid athlete in the league.',
                      'image': 'https://picsum.photos/800/450?random=503',
                      'time': '4h ago',
                      'url': 'https://example.com/sports3',
                    },
                  ],
                ),

                // 🎬 ENTERTAINMENT
                CategoryNewsPage(
                  category: 'Entertainment',
                  videoUrl:
                      'https://sample-videos.com/video321/mp4/720/sample-10s.mp4',
                  newsFeed: [
                    {
                      'title': 'Blockbuster Film Crosses 1B Mark Worldwide',
                      'summary':
                          'The sci-fi epic continues to dominate box offices with record-breaking numbers.',
                      'image': 'https://picsum.photos/800/450?random=601',
                      'time': '2h ago',
                      'url': 'https://example.com/ent1',
                    },
                    {
                      'title': 'Award-Winning Actor Announces New Project',
                      'summary':
                          'The upcoming drama explores themes of loss and redemption in a futuristic setting.',
                      'image': 'https://picsum.photos/800/450?random=602',
                      'time': '6h ago',
                      'url': 'https://example.com/ent2',
                    },
                    {
                      'title': 'Music Festival Returns After Two-Year Hiatus',
                      'summary':
                          'Fans are thrilled as the lineup includes top global artists and local legends.',
                      'image': 'https://picsum.photos/800/450?random=603',
                      'time': '9h ago',
                      'url': 'https://example.com/ent3',
                    },
                  ],
                ),

                // 🧠 HEALTH
                CategoryNewsPage(
                  category: 'Health',
                  videoUrl:
                      'https://sample-videos.com/video321/mp4/720/sample-15s.mp4',
                  newsFeed: [
                    {
                      'title':
                          'WHO Issues New Guidelines for Healthy Lifestyle',
                      'summary':
                          'The organization recommends increased physical activity and reduced screen time.',
                      'image': 'https://picsum.photos/800/450?random=701',
                      'time': '1h ago',
                      'url': 'https://example.com/health1',
                    },
                    {
                      'title': 'Breakthrough in Cancer Immunotherapy Trials',
                      'summary':
                          'Early results show a 70% remission rate in targeted patients, researchers confirm.',
                      'image': 'https://picsum.photos/800/450?random=702',
                      'time': '4h ago',
                      'url': 'https://example.com/health2',
                    },
                    {
                      'title':
                          'Nutrition Experts Promote Mindful Eating Habits',
                      'summary':
                          'A balanced diet with seasonal foods remains key to long-term wellbeing.',
                      'image': 'https://picsum.photos/800/450?random=703',
                      'time': '8h ago',
                      'url': 'https://example.com/health3',
                    },
                  ],
                ),

                // 🔬 SCIENCE
                CategoryNewsPage(
                  category: 'Science',
                  videoUrl:
                      'https://sample-videos.com/video321/mp4/720/sample-30s.mp4',
                  newsFeed: [
                    {
                      'title': 'NASA Unveils New Lunar Exploration Plan',
                      'summary':
                          'The Artemis program’s next phase will include crewed missions to the Moon’s south pole.',
                      'image': 'https://picsum.photos/800/450?random=801',
                      'time': '3h ago',
                      'url': 'https://example.com/science1',
                    },
                    {
                      'title': 'Breakthrough in Fusion Energy Achieved',
                      'summary':
                          'Scientists report sustained reaction times with net positive energy output.',
                      'image': 'https://picsum.photos/800/450?random=802',
                      'time': '6h ago',
                      'url': 'https://example.com/science2',
                    },
                    {
                      'title':
                          'Researchers Discover Microbial Life in Arctic Ice',
                      'summary':
                          'The finding offers clues about potential extraterrestrial ecosystems.',
                      'image': 'https://picsum.photos/800/450?random=803',
                      'time': '10h ago',
                      'url': 'https://example.com/science3',
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

  // ------------------------
  // All helper widgets (ensures _buildHomeTab exists)
  // ------------------------

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
              icon: const Icon(Icons.menu, color: Colors.white, size: 24),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      ),
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Image.asset(
          'assets/images/Ap-news_logo.webp',
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

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        unselectedLabelColor: Colors.grey[700],
        indicatorColor: Colors.red[800],
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
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
          _buildQuickActions(),
          const SizedBox(height: 25),
          _buildMoreVideos(),
          const SizedBox(height: 25),
          _buildNewsCards(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.live_tv, 'Live TV', Colors.red),
          _buildActionButton(Icons.trending_up, 'Trending', Colors.orange),
          _buildActionButton(Icons.bookmark, 'Saved', Colors.blue),
          _buildActionButton(Icons.history, 'Recent news', Colors.green),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
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
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 25,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item['isLive'] == true)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'LIVE NOW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              item['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
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
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[800],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 12,
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'Watch Now',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                const Text(
                  '📹 More Videos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 300,
                  margin: EdgeInsets.only(
                    right: index == 4 ? 0 : 15,
                    left: index == 0 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/300/200?random=${index + 10}',
                      ),
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
                          'Breaking News ${index + 1}',
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
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[800],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 40),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            elevation: 3,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow, size: 18),
                              SizedBox(width: 5),
                              Text('Play Now'),
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
      ),
    );
  }

  Widget _buildNewsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '📰 Latest News',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
                  color: Colors.white,
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              news['summary'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(6),
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

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '$tabName Content Coming Soon',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
