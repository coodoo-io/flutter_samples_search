import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
    this.isLoading = true,
    this.child,
    this.value,
    this.radius = 26,
  }) : super(key: key);

  final bool? isLoading;
  final Widget? child;
  final double? value;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Opacity(
            opacity: isLoading! ? 1.0 : 0.0,
            child: SizedBox(
              height: radius,
              width: radius,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                value: value,
              ),
            ),
          ),
          child != null ? const SizedBox(height: 16) : Container(),
          child != null ? child! : Container()
        ],
      ),
    );
  }
}
