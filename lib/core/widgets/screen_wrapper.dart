import 'package:flutter/material.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  final bool isLoading;
  final Widget? loadingWidget;

  const ScreenWrapper({
    super.key,
    required this.child,
    this.onRefresh,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final Widget scrollChild = child is ScrollView
        ? child
        : SingleChildScrollView(child: child);

    final Widget content = SafeArea(child: scrollChild);

    final Widget body = onRefresh != null
        ? RefreshIndicator(onRefresh: onRefresh!, child: content)
        : content;

    if (!isLoading) return body;

    return Stack(
      children: [
        body,
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.black.withOpacity(0.35),
              child: Center(
                child: loadingWidget ?? const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
