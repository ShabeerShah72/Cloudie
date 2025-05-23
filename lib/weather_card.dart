import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String label;
  final String value;

  const WeatherCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return 
    Padding(padding: const EdgeInsets.all(12),
    child: 
    Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_iconForLabel(label), color: Colors.white),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    )
    );
  }

  IconData _iconForLabel(String label) {
    switch (label.toLowerCase()) {
      case "wind":
        return Icons.air;
      case "humidity":
        return Icons.water_drop;
      case "pressure":
        return Icons.speed;
      default:
        return Icons.thermostat;
    }
  }
}
