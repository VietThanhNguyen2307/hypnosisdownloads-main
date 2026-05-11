import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CustomLoaderOverlay extends StatelessWidget {
  const CustomLoaderOverlay({
    required this.child,
    super.key,
    this.opacity,
  });

  final Widget child;
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (progress) => Center(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: const CustomLoadingIndicator(),
        ),
      ),
      child: child,
    );
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    this.size = 50.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: Theme.of(context).primaryColor,
      size: size,
    );
  }
}
