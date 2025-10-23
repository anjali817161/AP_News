// lib/controllers/cricket_controller.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CricketController extends GetxController {
 
  // API URL you provided
  final String apiUrl = 'https://cwidget.crictimes.org/?v=1.1&a=de0c0c';
  

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
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final body = response.body;

        // API sometimes returns plain JSON, sometimes wrapped - attempt to decode
        final decoded = json.decode(body);

        List<Map<String, dynamic>> parsed = [];

        // Try common shapes:
        if (decoded is List) {
          // If the endpoint returns a list directly
          parsed = decoded.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
        } else if (decoded is Map<String, dynamic>) {
          // Try to find a key that likely contains items
          // Common keys: 'items', 'data', 'news', 'articles', 'match'
          if (decoded['items'] is List) {
            parsed = List<Map<String, dynamic>>.from(decoded['items']);
          } else if (decoded['data'] is List) {
            parsed = List<Map<String, dynamic>>.from(decoded['data']);
          } else if (decoded['news'] is List) {
            parsed = List<Map<String, dynamic>>.from(decoded['news']);
          } else if (decoded['match'] is List) {
            parsed = List<Map<String, dynamic>>.from(decoded['match']);
          } else {
            // If it's a map of items keyed by id, convert to list
            try {
              parsed = (decoded as Map<String, dynamic>)
                  .entries
                  .map((e) => <String, dynamic>{'key': e.key, 'value': e.value})
                  .toList()
                  .cast<Map<String, dynamic>>();
            } catch (_) {
              // fallback: wrap the whole map as one item
              parsed = [decoded];
            }
          }
        } else {
          // Unknown shape
          parsed = [];
        }

        // Normalize each parsed item into Map<String,dynamic>
        final normalized = <Map<String, dynamic>>[];
        for (var i = 0; i < parsed.length; i++) {
          final m = Map<String, dynamic>.from(parsed[i]);
          // add an id if missing (we'll use index-based fallback)
          m.putIfAbsent('id', () => m['id']?.toString() ?? 'cricket_$i');
          // try to extract title / summary / image / views if available
          // Keep raw map too.
          normalized.add(m);
        }

        items.assignAll(normalized);
      } else {
        error.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Failed to load cricket news. ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  bool isSavedItem(String id) => savedIds.contains(id);

  void toggleSave(Map<String, dynamic> item) {
    final id = (item['id'] ?? item['key'] ?? item['title'] ?? item.hashCode).toString();
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
