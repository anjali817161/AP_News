// lib/modules/weather/weather_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ap_news/modules/weather/weather_controller.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  Widget _getWeatherIcon(String main, double temp) {
    IconData iconData;
    Color iconColor;

    switch (main.toLowerCase()) {
      case 'clear':
        iconData = Icons.wb_sunny;
        iconColor = temp > 25 ? Colors.orange : Colors.yellow;
        break;
      case 'clouds':
        iconData = Icons.cloud;
        iconColor = Colors.grey;
        break;
      case 'rain':
      case 'drizzle':
        iconData = Icons.grain;
        iconColor = Colors.blue;
        break;
      case 'thunderstorm':
        iconData = Icons.flash_on;
        iconColor = Colors.yellow;
        break;
      case 'snow':
        iconData = Icons.ac_unit;
        iconColor = Colors.lightBlue;
        break;
      case 'mist':
      case 'fog':
      case 'haze':
        iconData = Icons.blur_on;
        iconColor = Colors.grey;
        break;
      default:
        iconData = Icons.cloud;
        iconColor = Colors.grey;
    }

    return Icon(iconData, size: 48, color: iconColor);
  }

  @override
  Widget build(BuildContext context) {
    final WeatherController ctrl = Get.find<WeatherController>();
    final primaryRed = Colors.red[800]!;

    return Obx(() {
      if (ctrl.isLoading.value) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
          ),
          child: Row(
            children: const [
              SizedBox(width: 8),
              CircularProgressIndicator(),
              SizedBox(width: 12),
              Text('Loading weather...'),
            ],
          ),
        );
      }

      if (ctrl.error.value.isNotEmpty) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.orange),
              const SizedBox(width: 10),
              Expanded(child: Text('Weather: ${ctrl.error.value}', style: const TextStyle(fontSize: 14))),
              TextButton(
                onPressed: () => ctrl.fetchByDeviceLocation(),
                child: Text('Retry', style: TextStyle(color: primaryRed)),
              ),
            ],
          ),
        );
      }

      final w = ctrl.weather.value;
      if (w == null) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
          ),
          child: Row(
            children: [
              const Icon(Icons.cloud, size: 36, color: Colors.grey),
              const SizedBox(width: 12),
              const Expanded(child: Text('Weather not available')),
              TextButton(
                onPressed: () => ctrl.fetchByDeviceLocation(),
                child: Text('Load', style: TextStyle(color: primaryRed)),
              ),
            ],
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
        ),
        child: Row(
          children: [
            // Dynamic weather icon based on main weather condition
            _getWeatherIcon(w.main, w.temp),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: primaryRed),
                      const SizedBox(width: 4),
                      Text(
                        w.locationName.isNotEmpty ? w.locationName : 'Local Weather',
                        style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${w.temp.toStringAsFixed(0)}° • ${w.description}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text('Feels like ${w.feelsLike.toStringAsFixed(0)}° • Humidity ${w.humidity}%', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => ctrl.fetchByDeviceLocation(),
                  icon: Icon(Icons.refresh, color: primaryRed),
                ),
                const SizedBox(height: 4),
                Text('${w.windSpeed.toStringAsFixed(1)} m/s', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      );
    });
  }
}
