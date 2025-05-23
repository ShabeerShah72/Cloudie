import 'dart:convert';
import 'package:http/http.dart' as http;

class currentWeatherService {
  static const String apiKey = '19df53defe03899eaf81bcc0aaaf8adb';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Fetch Current Weather
  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final url = Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch current weather');
    }
  }
}