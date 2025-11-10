// lib/modules/custom_drawer/view/custom_drawer.dart
import 'package:ap_news/modules/profile/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import '../../../controllers/theme_controller.dart';
import '../../../controllers/language_controller.dart';

class CustomAppDrawer extends StatelessWidget {
  // Optional externally-provided state & callbacks (keeps backward compatibility)
  final bool? isDarkTheme;
  final ValueChanged<bool>? onThemeChanged;

  final bool? isHindi;
  final ValueChanged<bool>? onLanguageChanged;

  // Required navigation callbacks
  final VoidCallback onProfile;
  final VoidCallback Joinme;
  final VoidCallback onPrivacyPolicy;
  final VoidCallback onTerms;
  final VoidCallback onLogout;

  const CustomAppDrawer({
    Key? key,
    // optional override values
    this.isDarkTheme,
    this.onThemeChanged,
    this.isHindi,
    this.onLanguageChanged,

    // required callbacks
    required this.onProfile,
    required this.Joinme,
    required this.onPrivacyPolicy,
    required this.onTerms,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final languageController = Provider.of<LanguageController>(context);

    // Determine effective values: prefer constructor-provided values, otherwise provider values
    final effectiveIsDarkTheme = isDarkTheme ?? themeController.isDarkMode;
    final effectiveIsHindi =
        isHindi ?? (languageController.currentLanguage == 'hi');

    // Colors tuned to your red/white theme
    final primaryRed = Colors.red[800]!;
    final lightBg = Colors.white;
    final darkBg = Colors.grey[900]!;

    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true, // header sits flush to top
        child: Container(
          color: effectiveIsDarkTheme ? darkBg : lightBg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header (flush to top)
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
                            effectiveIsHindi
                                ? 'नमस्ते, उपयोगकर्ता'
                                : 'Hello, User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            effectiveIsHindi ? '@username' : '@username',
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
                      color: effectiveIsDarkTheme
                          ? Colors.grey[850]
                          : Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: Icon(Icons.language, color: primaryRed),
                        title: Text(
                          effectiveIsHindi ? 'हिंदी' : 'Language',
                          style: TextStyle(
                            color: effectiveIsDarkTheme
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          effectiveIsHindi
                              ? 'हिंदी में बदलें'
                              : 'Switch between English & Hindi',
                          style: TextStyle(
                            fontSize: 12,
                            color: effectiveIsDarkTheme
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
                          isSelected: [!effectiveIsHindi, effectiveIsHindi],
                          onPressed: (index) {
                            final wantHindi = index == 1;
                            // If callback provided by caller, prefer it
                            if (onLanguageChanged != null) {
                              onLanguageChanged!(wantHindi);
                            } else {
                              // otherwise update provider
                              languageController.changeLanguage(
                                wantHindi ? 'hi' : 'en',
                              );
                            }
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
                      color: effectiveIsDarkTheme
                          ? Colors.grey[850]
                          : Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: Icon(Icons.brightness_6, color: primaryRed),
                        title: Text(
                          effectiveIsHindi ? 'थीम' : 'Theme',
                          style: TextStyle(
                            color: effectiveIsDarkTheme
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          effectiveIsHindi
                              ? (effectiveIsDarkTheme ? 'डार्क' : 'लाइट')
                              : (effectiveIsDarkTheme ? 'Dark' : 'Light'),
                          style: TextStyle(
                            fontSize: 12,
                            color: effectiveIsDarkTheme
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                        trailing: Switch(
                          value: effectiveIsDarkTheme,
                          activeColor: lightBg,
                          activeTrackColor: primaryRed.withOpacity(0.7),
                          inactiveTrackColor: Colors.grey[300],
                          onChanged: (value) {
                            // Prefer caller-provided callback if available
                            if (onThemeChanged != null) {
                              onThemeChanged!(value);
                            } else {
                              // toggles provider state
                              themeController.toggleTheme();
                            }
                          },
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
    leading: Icon(Icons.work, color: primaryRed),
    title: Text(
      effectiveIsHindi ? 'हमारी टीम में शामिल हों' : 'Join Our Team',
      style: TextStyle(
        color: effectiveIsDarkTheme ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    ),
    onTap: Joinme,
  ),
                    ListTile(
                      leading: Icon(Icons.person, color: primaryRed),
                      title: Text(
                        effectiveIsHindi ? 'प्रोफ़ाइल' : 'Profile',
                        style: TextStyle(
                          color: effectiveIsDarkTheme
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      onTap: onProfile,
                    ),
                    ListTile(
                      leading: Icon(Icons.lock, color: primaryRed),
                      title: Text(
                        effectiveIsHindi
                            ? 'प्राइवेसी पॉलिसी'
                            : 'Privacy Policy',
                        style: TextStyle(
                          color: effectiveIsDarkTheme
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      onTap: onPrivacyPolicy,
                    ),
                    ListTile(
                      leading: Icon(Icons.description, color: primaryRed),
                      title: Text(
                        effectiveIsHindi
                            ? 'नियम व शर्तें'
                            : 'Terms & Conditions',
                        style: TextStyle(
                          color: effectiveIsDarkTheme
                              ? Colors.white
                              : Colors.black87,
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
                        effectiveIsHindi ? 'सेटिंग्स' : 'Settings',
                        style: TextStyle(
                          color: effectiveIsDarkTheme
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(height: 8),
                    const Divider(),

                    // Logout at bottom-ish
                    ListTile(
                      leading: Icon(Icons.logout, color: primaryRed),
                      title: Text(
                        effectiveIsHindi ? 'लॉग आउट' : 'Logout',
                        style: TextStyle(
                          color: effectiveIsDarkTheme
                              ? Colors.white
                              : Colors.black87,
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
                    color: effectiveIsDarkTheme
                        ? Colors.white38
                        : Colors.black45,
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
