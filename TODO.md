# TODO: Apply Dark Theme Support to All App Pages

## Overview
Apply dark theme support to all pages in the app, similar to the home page implementation. Use `Provider.of<ThemeController>(context).isDarkMode` to set a local `_isDarkTheme` boolean and update colors accordingly (e.g., backgrounds, text colors).

## Steps
- [ ] Update `lib/modules/sports/view/cricket_view.dart`: Add theme support for backgrounds, text, and containers.
- [ ] Update `lib/modules/categories/view/categories_news.dart`: Add theme support for backgrounds, text, and containers.
- [ ] Update `lib/modules/custom_drawer/view/custom_drawer.dart`: Add theme support for drawer background, text, and icons.
- [ ] Update `lib/modules/shorts/view/shorts_view.dart`: Add theme support for backgrounds, text, and containers.
- [ ] Update `lib/modules/learning/view/learning_page.dart`: Add theme support for backgrounds, text, and containers.
- [x] Update `lib/modules/read/view/read_page.dart`: Add theme support for backgrounds, text, and containers.
- [ ] Update `lib/modules/settings/view/settings_page.dart`: Add theme support for backgrounds, text, and containers.
- [ ] Update `lib/modules/bottom_navbar/bottom_navbar.dart`: Add theme support for navbar background and icons.
- [ ] Update `lib/views/login_page.dart`: Add theme support for backgrounds, text, and inputs.
- [ ] Update `lib/auth/signup/view/signup_page.dart`: Add theme support for backgrounds, text, and inputs.
- [ ] Update `lib/views/language_page.dart`: Add theme support for backgrounds, text, and containers.
- [ ] Update `lib/auth/login/view/login_view.dart`: Add theme support for backgrounds, text, and inputs.
- [ ] Update `lib/main.dart`: Ensure theme is properly applied at root level if needed.
- [ ] Test all pages in both light and dark themes for visual consistency.

## Notes
- For each page, add `final themeController = Provider.of<ThemeController>(context); final _isDarkTheme = themeController.isDarkMode;` in the build method.
- Update hardcoded colors like `Colors.white` to `_isDarkTheme ? Colors.grey[800] : Colors.white`.
- Update text colors like `Colors.black87` to `_isDarkTheme ? Colors.white : Colors.black87`.
- Ensure icons and other elements adapt appropriately.
