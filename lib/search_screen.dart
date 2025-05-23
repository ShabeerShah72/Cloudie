import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> _validateCityWithAPI(BuildContext context, String cityName) async {
  const apiKey = '19df53defe03899eaf81bcc0aaaf8adb'; 
  final url =
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Navigator.pop(context, cityName);
    } else {
      _showErrorDialog(context);
    }
  } catch (e) {
    _showErrorDialog(context);
  }
}

void _showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("City Not Found"),
      content: const Text("Please check the spelling and try again."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

class SearchCityScreen extends StatefulWidget {
  const SearchCityScreen({super.key});

  @override
  State<SearchCityScreen> createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> allCities = [
    'Islamabad',
    'Lahore',
    'Bhakkar',
    'Karachi',
    'Dera Ismail Khan',
    'Quetta',
    'Peshawar',
    'Multan',
    'Faisalabad',
    'Rawalpindi',
    'Sialkot',
    'Hyderabad',
    'Gilgit',
    'Skardu',
  ];

  List<String> filteredCities = [];

  @override
  void initState() {
    super.initState();
    filteredCities = allCities;
    _controller.addListener(_filterCities);
  }

  void _filterCities() {
    final query = _controller.text.toLowerCase();
    setState(() {
      filteredCities = allCities
          .where((city) => city.toLowerCase().contains(query))
          .toList();
    });
  }

  void _selectCity(String cityName) {
    Navigator.pop(context, cityName);
  }

  void _submitTypedCity() {
    final typedCity = _controller.text.trim();
    if (typedCity.isNotEmpty) {
      _validateCityWithAPI(context, typedCity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Search City',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (_) => _submitTypedCity(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter city name',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: _submitTypedCity,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Recent Locations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // Dynamic List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCities.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _selectCity(filteredCities[index]),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              filteredCities[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
