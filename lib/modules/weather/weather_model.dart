// lib/models/weather_model.dart
class WeatherModel {
  final String main;
  final String description;
  final String icon;     // icon id like "10d"
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String locationName;

  WeatherModel({
    required this.main,
    required this.description,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.locationName,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = (json['weather'] as List).first;
    final main = json['main'] ?? {};
    return WeatherModel(
      main: weather['main'] ?? '',
      description: weather['description'] ?? '',
      icon: weather['icon'] ?? '',
      temp: (main['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind']?['speed'] as num?)?.toDouble() ?? 0.0,
      locationName: json['name'] ?? '',
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}
