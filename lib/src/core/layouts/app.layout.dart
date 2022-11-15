import 'package:flutter/material.dart';
import 'package:samples/src/core/layouts/widgets/footer.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({required this.child, Key? key}) : super(key: key);

  final Widget child;
  final double maxWidth = 960.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomSheet: Footer(maxWidth: maxWidth),
    );
  }
}
