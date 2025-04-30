import 'package:flutter/material.dart';

class LoadingFullscreenDialog extends StatelessWidget {
  const LoadingFullscreenDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Material(
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
