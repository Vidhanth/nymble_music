import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/bloc/songs/songs_bloc.dart';
import 'package:nymble_music/bloc/user/user_bloc.dart';
import 'package:nymble_music/models/song.dart';
import 'package:animate_do/animate_do.dart';
import 'package:nymble_music/presentation/components/song_item.dart';
import 'package:nymble_music/presentation/constants/styles.dart';
import 'package:nymble_music/utils/extensions.dart';

class SongList extends StatelessWidget {
  final List<Song> songs;
  final Function(Song) onAddToFavorites;
  final Function(Song) onTapped;
  final String searchQuery;

  const SongList({
    super.key,
    required this.songs,
    required this.onAddToFavorites,
    required this.onTapped,
    this.searchQuery = "",
  });

  @override
  Widget build(BuildContext context) {
    final songsState = (context.read<SongsBloc>().state as SongsLoaded);
    final userState = (context.read<UserBloc>().state as UserLoaded);

    if (songs.isEmpty) {
      return FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_outlined,
              size: context.height * 0.15,
            ),
            Text(
              songsState.userFavorites != null ? "No Favorited Songs" : "No Songs Found",
              style: montserratText.copyWith(
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 10),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return FadeIn(
            delay: (50 * index).milliseconds,
            child: GestureDetector(
                onTap: () {
                  onTapped.call(song);
                },
                child: SongItem(
                  song: song,
                  searchQuery: searchQuery,
                  isFavorite: userState.user.favorites.contains(song.id),
                  onAddToFavorites: onAddToFavorites,
                )),
          );
        },
      ),
    );
  }
}
