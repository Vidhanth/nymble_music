import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nymble_music/models/song.dart';
import 'package:nymble_music/presentation/components/favorites_button.dart';
import 'package:nymble_music/presentation/constants/styles.dart';
import 'package:nymble_music/utils/extensions.dart';
import 'package:substring_highlight/substring_highlight.dart';

class SongItem extends StatelessWidget {
  final Song song;
  final String searchQuery;
  final Function(Song) onAddToFavorites;
  final bool isFavorite;

  const SongItem({super.key, required this.song, required this.searchQuery, required this.onAddToFavorites, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(song.id),
      contentPadding: EdgeInsets.zero,
      leading: ZoomIn(
        delay: 200.milliseconds,
        child: Hero(
          tag: song.albumUrl,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.grey,
                child: Image.network(
                  song.albumUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: FadeInLeft(
          from: 10,
          delay: 300.milliseconds,
          child: SubstringHighlight(
            text: song.name,
            term: searchQuery,
            maxLines: 1,
            textStyle: montserratText.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textStyleHighlight: montserratText.copyWith(
              color: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      subtitle: FadeInLeft(
        from: 10,
        delay: 300.milliseconds,
        child: SubstringHighlight(
          text: song.artist,
          term: searchQuery,
          maxLines: 1,
          textStyle: montserratText.copyWith(
            color: Theme.of(context).hintColor,
            // fontSize: 12,
          ),
          textStyleHighlight: montserratText.copyWith(
            color: Theme.of(context).colorScheme.background,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: ZoomIn(
        delay: 400.milliseconds,
        child: FavoritesButton(
          isFavorite: isFavorite,
          onTap: () {
            onAddToFavorites.call(song);
          },
        ),
      ),
    );
  }
}
