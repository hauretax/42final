import 'package:diaryfinalapp/models/entry.dart';
import 'package:flutter/material.dart';

Widget feelingView(List<Entry> entries) {
  final Map<String, int> iconCounts = {};
  final int totalEntries = entries.length;

  for (var entry in entries) {
    iconCounts[entry.icon] = (iconCounts[entry.icon] ?? 0) + 1;
  }

  final List<String> dailyFeelings = iconCounts.keys.toList();
  final List<double> percentages = dailyFeelings
      .map((icon) => (iconCounts[icon]! / totalEntries) * 100)
      .toList();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: dailyFeelings.asMap().entries.map((entry) {
      int index = entry.key;
      String icon = entry.value;
      double percentage = percentages[index];

      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
