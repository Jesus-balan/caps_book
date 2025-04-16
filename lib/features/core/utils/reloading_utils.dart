import 'package:flutter/material.dart';

void showLoaderDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
}

void hideLoaderDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
