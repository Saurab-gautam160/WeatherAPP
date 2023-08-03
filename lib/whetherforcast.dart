import 'package:flutter/material.dart';

class Forcastcard extends StatelessWidget {
  final String Time;
  final String Temp;
  final IconData icon;
  const Forcastcard(
      {super.key, required this.Time, required this.Temp, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              Time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(Temp),
          ],
        ),
      ),
    );
  }
}
