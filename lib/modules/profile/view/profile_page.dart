import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../controllers/theme_controller.dart';
import '../../../utils/localization.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkTheme = themeController.isDarkMode;
    final primaryRed = Colors.red[800]!;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header with profile picture and basic info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkTheme ? Colors.grey[850] : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Profile Picture
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryRed, width: 3),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/Ap-news_logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? Colors.white : Colors.black87,
                      ),
                    ),

                    // Email
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkTheme
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Member since
                    Text(
                      'Member since January 2024',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkTheme
                            ? Colors.grey[500]
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildStatCard(
                      'Articles Read',
                      '247',
                      Icons.article,
                      primaryRed,
                      isDarkTheme,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      'Bookmarks',
                      '42',
                      Icons.bookmark,
                      primaryRed,
                      isDarkTheme,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menu Items
              _buildMenuSection(context, 'Account Settings', [
                _buildMenuItem(
                  Icons.person,
                  'Edit Profile',
                  () {},
                  isDarkTheme,
                ),
                _buildMenuItem(
                  Icons.notifications,
                  'Notifications',
                  () {},
                  isDarkTheme,
                ),
                _buildMenuItem(
                  Icons.security,
                  'Privacy & Security',
                  () {},
                  isDarkTheme,
                ),
              ], isDarkTheme),

              _buildMenuSection(context, 'Preferences', [
                _buildMenuItem(Icons.language, 'Language', () {
                  Get.toNamed('/language');
                }, isDarkTheme),
                _buildMenuItem(Icons.dark_mode, 'Theme', () {
                  themeController.toggleTheme();
                }, isDarkTheme),
                _buildMenuItem(
                  Icons.bookmark_border,
                  'Saved Articles',
                  () {},
                  isDarkTheme,
                ),
              ], isDarkTheme),

              _buildMenuSection(context, 'Support', [
                _buildMenuItem(
                  Icons.help,
                  'Help & Support',
                  () {},
                  isDarkTheme,
                ),
                _buildMenuItem(Icons.info, 'About', () {}, isDarkTheme),
                _buildMenuItem(Icons.star, 'Rate App', () {}, isDarkTheme),
              ], isDarkTheme),

              // Logout Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle logout
                    Get.offAllNamed('/login');
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    localizations.logout,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color primaryRed,
    bool isDarkTheme,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkTheme ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryRed, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<Widget> items,
    bool isDarkTheme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.black87,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap,
    bool isDarkTheme,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkTheme ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDarkTheme ? Colors.grey[600] : Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
