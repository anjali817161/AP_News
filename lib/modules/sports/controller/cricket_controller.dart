// lib/controllers/cricket_controller.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CricketController extends GetxController {
  // API URL for cricket scores data
  final String apiUrl = 'https://crictimes.org/data/v1/scores.json?q=';

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Raw items parsed as map (you can transform into model if you want)
  final RxList<Map<String, dynamic>> items = RxList<Map<String, dynamic>>();

  // Saved (bookmarked) items stored as list of JSON strings in SharedPreferences
  final RxSet<String> savedIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSaved();
    fetchCricketNews();
  }

  Future<void> _loadSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('cricket_saved') ?? <String>[];
      savedIds.clear();
      savedIds.addAll(saved);
    } catch (_) {}
  }

  Future<void> _persistSaved() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cricket_saved', savedIds.toList());
  }

  Future<void> fetchCricketNews({bool forceRefresh = false}) async {
    if (isLoading.value && !forceRefresh) return;
    isLoading.value = true;
    error.value = '';

    try {
      // Append timestamp to avoid caching
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fullUrl = '$apiUrl$timestamp';
      final response = await http
          .get(Uri.parse(fullUrl))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final body = response.body;

        // Decode JSON response
        final decoded = json.decode(body);

        // The API returns a map with keys: 'completed', 'live', 'upcoming'
        // Each key contains a list of matches
        List<Map<String, dynamic>> allMatches = [];

        if (decoded is Map<String, dynamic>) {
          // Combine all matches from different categories
          final completed = decoded['completed'] ?? [];
          final live = decoded['live'] ?? [];
          final upcoming = decoded['upcoming'] ?? [];

          allMatches.addAll(List<Map<String, dynamic>>.from(completed));
          allMatches.addAll(List<Map<String, dynamic>>.from(live));
          allMatches.addAll(List<Map<String, dynamic>>.from(upcoming));
        }

        // Normalize each match
        final normalized = <Map<String, dynamic>>[];
        for (var i = 0; i < allMatches.length; i++) {
          final match = Map<String, dynamic>.from(allMatches[i]);
          // Add unique id
          match.putIfAbsent('id', () => match['url']?.toString() ?? 'match_$i');
          // Add status for UI display
          match.putIfAbsent('status', () => match['status'] ?? 'COMPLETED');
          normalized.add(match);
        }

        items.assignAll(normalized);
      } else {
        error.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Failed to load cricket scores. ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  bool isSavedItem(String id) => savedIds.contains(id);

  void toggleSave(Map<String, dynamic> item) {
    final id = (item['id'] ?? item['key'] ?? item['title'] ?? item.hashCode)
        .toString();
    if (savedIds.contains(id)) {
      savedIds.remove(id);
    } else {
      savedIds.add(id);
    }
    _persistSaved();
    // small feedback
    Get.snackbar(
      'Bookmarks',
      savedIds.contains(id) ? 'Saved' : 'Removed',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}
