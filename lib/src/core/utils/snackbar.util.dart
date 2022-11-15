import 'package:flutter/material.dart';

class SnackBarUtil {
  static void showSnackBar({
    required ScaffoldMessengerState state,
    required String message,
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    _removeCurrentSnackBar(state);
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      backgroundColor: backgroundColor,
      action: action,
    );
    state.showSnackBar(snackBar);
  }

  static void showErrorSnackBar({required ScaffoldMessengerState state, required String message}) {
    _removeCurrentSnackBar(state);
    showSnackBar(state: state, message: message, backgroundColor: Colors.redAccent);
  }

  static void _removeCurrentSnackBar(ScaffoldMessengerState state) {
    state.hideCurrentSnackBar();
  }
}
