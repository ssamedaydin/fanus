import 'package:fanus_design/fanus_design.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bubble_chart_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: FanusSpacing.md),
            Text('Fanus', style: theme.textTheme.headlineMedium),
            const SizedBox(height: FanusSpacing.sm),
            Text(
              'Kişisel odak ve dijital denge',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
