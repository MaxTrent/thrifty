import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      color: Theme.of(context).colorScheme.secondary,
      size: 50.0,
    );
  }
}
