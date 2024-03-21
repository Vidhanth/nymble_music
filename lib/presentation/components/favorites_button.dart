import 'package:flutter/material.dart';
import 'package:nymble_music/utils/extensions.dart';

class FavoritesButton extends StatelessWidget {
  final bool isFavorite;
  final void Function() onTap;

  const FavoritesButton({super.key, required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedCrossFade(
        firstChild: const Icon(Icons.favorite_border),
        secondChild: const Icon(Icons.favorite),
        crossFadeState: isFavorite ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: 600.milliseconds,
        firstCurve: Curves.fastOutSlowIn,
        secondCurve: Curves.fastOutSlowIn,
      ),
      color: isFavorite ? Colors.red : null,
      onPressed: onTap,
    );
  }
}
