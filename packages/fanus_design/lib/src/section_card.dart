import 'package:flutter/material.dart';

import 'spacing.dart';

/// Başlıklı içerik kartı; ayar/liste ekranlarındaki bölümler için.
class FanusSectionCard extends StatelessWidget {
  const FanusSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FanusSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FanusSpacing.md,
                vertical: FanusSpacing.xs,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
