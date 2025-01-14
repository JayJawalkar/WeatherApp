import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final String value;
  final IconData icon;
  const HourlyForecast(
      {super.key, required this.time, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(value),
          ],
        ),
      ),
    );
  }
}
