import 'package:flutter/material.dart';
import 'package:nymble_music/presentation/constants/styles.dart';

class LogoLandscape extends StatelessWidget {
  final Color? color;

  const LogoLandscape({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: "appLogoIcon",
          child: Icon(
            Icons.music_note_outlined,
            size: 30,
            color: color,
          ),
        ),
        Hero(
          tag: "appLogoText",
          child: Material(
            color: Colors.transparent,
            child: Text(
              "Nymble Music",
              style: montserratText.copyWith(
                fontSize: 16,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
