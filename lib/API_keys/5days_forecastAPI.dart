import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherService {
  static const String apiKey = '19df53defe03899eaf81bcc0aaaf8adb';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Fetch Current Weather
  static Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final url = Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch current weather');
    }
  }

  // Fetch 5-Day Forecast
  static Future<List<Map<String, String>>> fetch5DayForecast(String city) async {
    final url = Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, String>> forecast = [];

      final list = data['list'];
      for (int i = 0; i < list.length; i += 8) {
        final item = list[i];
        final dateTime = DateTime.parse(item['dt_txt']);
        final temp = item['main']['temp'].toStringAsFixed(0);
        final icon = item['weather'][0]['icon'];
        final dayName = _dayOfWeek(dateTime.weekday);

        forecast.add({
          'day': dayName,
          'temp': '$temp°C',
          'icon': icon,
        });
      }

      return forecast;
    } else {
      throw Exception('Failed to fetch forecast');
    }
  }

  // Day Name Helper
  static String _dayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}

// 5-DAYS Weather Forecast API

class FiveDayForecast {
  static const String _apiKey = '19df53defe03899eaf81bcc0aaaf8adb';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/forecast';

  Future<List<Map<String, String>>> getFiveDayForecast(String city) async {
    final response = await http.get(Uri.parse(
      '$_baseUrl?q=$city&appid=$_apiKey&units=metric',
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List forecasts = data["list"];

      // Extract one forecast per day around 12:00 PM
      Map<String, Map<String, String>> daily = {};

      for (var entry in forecasts) {
        String dateTxt = entry['dt_txt'];
        DateTime dateTime = DateTime.parse(dateTxt);
        String dateKey = DateFormat('yyyy-MM-dd').format(dateTime);

        if (dateTxt.contains("12:00:00")) {
          daily[dateKey] = {
            "day": DateFormat('EEEE').format(dateTime),
            "temp": "${entry['main']['temp'].round()}°C",
            "icon": entry['weather'][0]['icon'],
          };
        }
      }

      return daily.values.toList();
    } else {
      throw Exception("Failed to load forecast");
    }
  }
  
}

class ForecastService {
  final FiveDayForecast _service = FiveDayForecast();

  Future<List<Map<String, String>>> getFiveDayForecast(String city) {
    return _service.getFiveDayForecast(city);
  }
}
