import 'package:flutter/material.dart';
import 'package:nymble_music/presentation/constants/styles.dart';
import 'package:nymble_music/utils/extensions.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: "appLogoIcon",
          child: Icon(
            Icons.music_note_outlined,
            size: context.height * 0.15,
          ),
        ),
        Hero(
          tag: "appLogoText",
          child: Material(
            color: Colors.transparent,
            child: Text(
              "Nymble Music",
              style: montserratText.copyWith(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
