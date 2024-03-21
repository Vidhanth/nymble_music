import 'package:flutter/material.dart';
import 'package:nymble_music/presentation/constants/colors.dart';
import 'package:nymble_music/presentation/constants/styles.dart';

extension ContextUtils on BuildContext {
  Size get size => MediaQuery.of(this).size;

  double get height {
    return size.height;
  }

  double get width {
    return size.width;
  }

  void showSnackbar(
    String msg, {
    bool isError = false,
    String title = '',
    Color? customColor,
    bool removeOthers = true,
    SnackBarAction? action,
  }) {
    if (msg.isEmpty) return;
    if (removeOthers) {
      ScaffoldMessenger.of(this).removeCurrentSnackBar();
    }
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(15),
        action: action,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Text(
                title,
                style: montserratText.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            Text(
              msg,
              style: montserratText.copyWith(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red : customColor ?? primaryColor,
      ),
    );
  }
}

extension Durations on int {
  Duration get milliseconds => Duration(milliseconds: this);

  Duration get seconds => Duration(seconds: this);

  Duration get minutes => Duration(minutes: this);

  String get toChildAvatarUrl {
    return "assets/images/bots/${this % 6}.png";
  }
}

extension StringUtils on String {
  bool get isValidEmail {
    if (isEmpty) return false;
    return RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
            .hasMatch(this) &&
        RegExp(r"\.(.{2,})$").hasMatch(this);
  }
}
