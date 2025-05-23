import 'package:flutter/material.dart';
import 'API_keys/current_forecastAPI.dart' as current;
import 'API_keys/hourly_forecastAPI.dart' as hourly;
import 'API_keys/5days_forecastAPI.dart' as fiveDay;
import 'weather_card.dart';
import 'search_screen.dart';// Adjust the path accordingly

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final hourly.HourlyForecast _hourlyService = hourly.HourlyForecast();
  final fiveDay.FiveDayForecast _fiveDayForecast = fiveDay.FiveDayForecast();
  final current.currentWeatherService _weatherService = current.currentWeatherService();

  String city = 'Bhakkar'; // 🔧 Changed from final String _city
  late Future<Map<String, dynamic>> _weatherData;
  late Future<List<Map<String, String>>> _hourlyForecast;
  late Future<List<Map<String, String>>> _forecast;

  void _fetchWeatherDataForCity(String selectedCity) {
    setState(() {
      city = selectedCity;
      _weatherData = _weatherService.fetchCurrentWeather(city);
      _hourlyForecast = _hourlyService.getHourlyForecast(city);
      _forecast = _fiveDayForecast.getFiveDayForecast(city);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWeatherData(city);
  }

  void _loadWeatherData(String city) {
    _weatherData = _weatherService.fetchCurrentWeather(city);
    _hourlyForecast = _hourlyService.getHourlyForecast(city);
    _forecast = _fiveDayForecast.getFiveDayForecast(city);
  }

  Color _getBackgroundColor(String condition) {
    if (condition.contains('rain')) {
      return Colors.blueGrey.shade800;
    } else if (condition.contains('snow')) {
      return Colors.lightBlue.shade100;
    } else if (condition.contains('cloud')) {
      return Colors.blue.shade400;
    } else if (condition.contains('clear')) {
      return Colors.lightBlue;
    } else {
      return Colors.blue[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              backgroundColor: Colors.blue,
              body: Center(child: CircularProgressIndicator(color: Colors.white)));
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
              backgroundColor: Colors.blue,
              body: Center(child: Text("Failed to load data", style: TextStyle(color: Colors.white))));
        }

        final data = snapshot.data!;
        final temp = data['main']['temp'].round();
        final feelsLike = data['main']['feels_like'].round();
        final humidity = data['main']['humidity'].toString();
        final pressure = data['main']['pressure'].toString();
        final wind = data['wind']['speed'].toString();
        final condition = data['weather'][0]['description'].toString().toLowerCase();
        final date = DateTime.now();

        final backgroundColor = _getBackgroundColor(condition);

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Cloudie",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search_sharp, size: 35, color: Colors.white),
                          onPressed: () async {
                            final selectedCity = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SearchCityScreen()),
                            );
                            if (selectedCity != null && selectedCity is String) {
                              _fetchWeatherDataForCity(selectedCity);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // City + Date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(city,
                            style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(_formatDate(date), style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Weather Image + Temp
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "$temp°",
                      style: const TextStyle(fontSize: 70, color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Feels like $feelsLike°",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 30),

                  WeatherCard(label: "Wind", value: "$wind m/s"),
                  WeatherCard(label: "Humidity", value: "$humidity%"),
                  WeatherCard(label: "Pressure", value: "$pressure hPa"),

                  const SizedBox(height: 30),

                  // Hourly Forecast
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Hourly Forecast",
                            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        FutureBuilder<List<Map<String, String>>>(
                          future: _hourlyForecast,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(color: Colors.white);
                            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text("No forecast available", style: TextStyle(color: Colors.white));
                            }

                            final hourly = snapshot.data!;
                            return Column(
                              children: hourly.map((hour) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 145, 205, 255),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(hour["time"]!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                      Text(hour["temp"]!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // 5-Day Forecast
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Text("5-Day Forecast",
                            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        FutureBuilder<List<Map<String, String>>>(
                          future: _forecast,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(color: Colors.white));
                            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text("No forecast available", style: TextStyle(color: Colors.white)));
                            }

                            final forecast = snapshot.data!;
                            return Column(
                              children: forecast.map((day) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 145, 205, 255),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(day["day"]!,
                                          style: const TextStyle(
                                              fontSize: 18, color: Colors.black)),
                                      Row(
                                        children: [
                                          Image.network(
                                            "https://openweathermap.org/img/wn/${day['icon']}@2x.png",
                                            width: 40,
                                            height: 40,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(day["temp"]!,
                                              style: const TextStyle(
                                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        // Signature added here:
                        const SizedBox(height:50),
                        const Center(
                          child: Text(
                            "Cloudie by Shabeer Shah",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return "${weekdays[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}";
  }
}
