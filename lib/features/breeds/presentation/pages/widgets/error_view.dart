import 'package:cat_breeds/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:cat_breeds/core/error/failure.dart';

class ErrorView extends StatelessWidget {
  final Failure failure;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.failure, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final msg = failure.maybeMap(
      server: (f) => f.message,
      network: (f) => f.message,
      unknown: (f) => f.message,
      orElse: () => AppStrings.errorOccurred,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              msg,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
