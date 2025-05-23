import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//Hourly Forcast API
 
class HourlyForecast {
  static const String _apiKey = '19df53defe03899eaf81bcc0aaaf8adb';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/forecast';

  Future<List<Map<String, String>>> getHourlyForecast(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric'),
    ); 

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List forecastList = data['list'];

      // Get first 6 time slots
      final hourly = forecastList.take(6).map((entry) {
        final time = DateTime.parse(entry['dt_txt']);
        final formattedTime = DateFormat.jm().format(time); // e.g., 10 AM

        final temp = entry['main']['temp'].round().toString(); // rounded °C

        return {
          'time': formattedTime,
          'temp': '$temp°',
        };
      }).toList();

      return hourly;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

}

