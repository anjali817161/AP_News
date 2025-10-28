// lib/services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  final String baseUrl;

  WeatherService({ required this.apiKey, this.baseUrl = 'https://api.openweathermap.org/data/2.5' });

  // Fetch current weather by latitude and longitude (units: metric)
  Future<Map<String, dynamic>> fetchCurrentByLatLon({
    required double lat,
    required double lon,
    String units = 'metric',
    String lang = 'en',
  }) async {
    final uri = Uri.parse(
      '$baseUrl/weather?lat=$lat&lon=$lon&units=$units&lang=$lang&appid=$apiKey',
    );

    final resp = await http.get(uri).timeout(const Duration(seconds: 15));
    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('OpenWeather error ${resp.statusCode}: ${resp.body}');
    }
  }

  // Optional: fetch OneCall (hourly/daily) if you need forecast
  Future<Map<String, dynamic>> fetchOneCall({
    required double lat,
    required double lon,
    String units = 'metric',
    String lang = 'en',
    String exclude = '',
  }) async {
    final uri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=$exclude&units=$units&lang=$lang&appid=$apiKey'
    );
    final resp = await http.get(uri).timeout(const Duration(seconds: 15));
    if (resp.statusCode == 200) return json.decode(resp.body) as Map<String, dynamic>;
    throw Exception('OpenWeather OneCall error ${resp.statusCode}');
  }
}
