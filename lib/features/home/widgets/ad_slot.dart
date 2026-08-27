import 'package:flutter/material.dart';

class AdSlot extends StatelessWidget {
  final String position;
  
  const AdSlot({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ADVERTISEMENT',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Icon(Icons.ad_units, size: 64, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }
}
