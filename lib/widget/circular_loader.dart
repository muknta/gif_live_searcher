import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key, this.loadingProgress});

  final double? loadingProgress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        value: (loadingProgress ?? 0) < 0.1 ? null : loadingProgress,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }
}
