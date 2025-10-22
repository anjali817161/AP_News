import 'package:flutter/material.dart';

class CustomAppDrawer extends StatelessWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  final bool isHindi;
  final ValueChanged<bool> onLanguageChanged;

  final VoidCallback onProfile;
  final VoidCallback onPrivacyPolicy;
  final VoidCallback onTerms;
  final VoidCallback onLogout;

  const CustomAppDrawer({
    Key? key,
    required this.isDarkTheme,
    required this.onThemeChanged,
    required this.isHindi,
    required this.onLanguageChanged,
    required this.onProfile,
    required this.onPrivacyPolicy,
    required this.onTerms,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors tuned to your red/white theme
    final primaryRed = Colors.red[800]!;
    final lightBg = Colors.white;
    final darkBg = Colors.grey[900]!;

    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop:
            true, // <- removes the top safe-area padding so header sits flush
        child: Container(
          color: isDarkTheme ? darkBg : lightBg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header (now flush to the top)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: primaryRed,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Text(
                        'AP',
                        style: TextStyle(
                          color: primaryRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHindi ? 'नमस्ते, उपयोगकर्ता' : 'Hello, User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isHindi ? '@username' : '@username',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Toggles (language + theme)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6,
                ),
                child: Column(
                  children: [
                    // Language toggle row
                    Card(
                      elevation: 0,
                      color: isDarkTheme ? Colors.grey[850] : Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: Icon(Icons.language, color: primaryRed),
                        title: Text(
                          isHindi ? 'हिंदी' : 'Language',
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          isHindi
                              ? 'हिंदी में बदलें'
                              : 'Switch between English & Hindi',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkTheme
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                        trailing: ToggleButtons(
                          borderRadius: BorderRadius.circular(12),
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 32,
                          ),
                          isSelected: [!isHindi, isHindi],
                          onPressed: (index) {
                            // index 0 -> English, 1 -> Hindi
                            onLanguageChanged(index == 1);
                          },
                          children: const [
                            Text(
                              'EN',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'HI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Theme toggle row
                    Card(
                      elevation: 0,
                      color: isDarkTheme ? Colors.grey[850] : Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: Icon(Icons.brightness_6, color: primaryRed),
                        title: Text(
                          isHindi ? 'थीम' : 'Theme',
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          isHindi
                              ? (isDarkTheme ? 'डार्क' : 'लाइट')
                              : (isDarkTheme ? 'Dark' : 'Light'),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkTheme
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                        trailing: Switch(
                          value: isDarkTheme,
                          activeColor: lightBg,
                          activeTrackColor: primaryRed.withOpacity(0.7),
                          inactiveTrackColor: Colors.grey[300],
                          onChanged: onThemeChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1),

              // Navigation items group 1
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: primaryRed),
                      title: Text(
                        isHindi ? 'प्रोफ़ाइल' : 'Profile',
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black87,
                        ),
                      ),
                      onTap: onProfile,
                    ),
                    ListTile(
                      leading: Icon(Icons.lock, color: primaryRed),
                      title: Text(
                        isHindi ? 'प्राइवेसी पॉलिसी' : 'Privacy Policy',
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black87,
                        ),
                      ),
                      onTap: onPrivacyPolicy,
                    ),
                    ListTile(
                      leading: Icon(Icons.description, color: primaryRed),
                      title: Text(
                        isHindi ? 'नियम व शर्तें' : 'Terms & Conditions',
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black87,
                        ),
                      ),
                      onTap: onTerms,
                    ),

                    const SizedBox(height: 8),
                    const Divider(),

                    // Settings / Other actions
                    ListTile(
                      leading: Icon(Icons.settings, color: primaryRed),
                      title: Text(
                        isHindi ? 'सेटिंग्स' : 'Settings',
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black87,
                        ),
                      ),
                      onTap: () {
                        // You can link to app settings page
                        Navigator.pop(context);
                        // If needed call a callback
                      },
                    ),

                    const SizedBox(height: 8),
                    const Divider(),

                    // Logout at bottom-ish
                    ListTile(
                      leading: Icon(Icons.logout, color: primaryRed),
                      title: Text(
                        isHindi ? 'लॉग आउट' : 'Logout',
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: onLogout,
                    ),
                  ],
                ),
              ),

              // Optional footer
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Version 1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white38 : Colors.black45,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
