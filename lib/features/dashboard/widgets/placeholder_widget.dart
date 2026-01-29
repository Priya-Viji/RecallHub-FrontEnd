import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const PlaceholderWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lightbulb_outline, size: 80),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 24)),
          Text(subtitle),
        ],
      ),
    );
  }
}
