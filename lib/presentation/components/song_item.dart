import 'package:flutter/material.dart';
import 'package:nymble_music/models/song.dart';
import 'package:nymble_music/presentation/components/favorites_button.dart';
import 'package:nymble_music/presentation/constants/styles.dart';
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
      contentPadding: EdgeInsets.zero,
      leading: Hero(
        tag: song.albumUrl,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              song.albumUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
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
      subtitle: SubstringHighlight(
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
      trailing: FavoritesButton(
        isFavorite: isFavorite,
        onTap: () {
          onAddToFavorites.call(song);
        },
      ),
    );
  }
}
