import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final int temperature;
  final int rainChance;
  final String tip;

  const WeatherCard({
    super.key,
    required this.temperature,
    required this.rainChance,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textColor = scheme.onPrimaryContainer;

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              rainChance >= 50 ? Icons.umbrella : Icons.wb_sunny,
              size: 40,
              color: textColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$temperature°C, $rainChance% rain',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(tip, style: TextStyle(color: textColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
