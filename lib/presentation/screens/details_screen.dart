import 'dart:ui';

import 'package:animated_progress_bar/animated_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/bloc/details/details_bloc.dart';
import 'package:nymble_music/bloc/user/user_bloc.dart';
import 'package:nymble_music/helpers/audio_helper.dart';
import 'package:nymble_music/models/song.dart';
import 'package:nymble_music/presentation/components/favorites_button.dart';
import 'package:nymble_music/presentation/components/logo/logo_landscape.dart';
import 'package:nymble_music/presentation/constants/colors.dart';
import 'package:nymble_music/presentation/constants/styles.dart';
import 'package:nymble_music/utils/extensions.dart';

class DetailsScreen extends StatelessWidget {
  final Song song;

  const DetailsScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          AudioHelper.instance.pause();
          AudioHelper.instance.resetOnProgressListener();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const LogoLandscape(),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          padding: const EdgeInsets.only(top: kBottomNavigationBarHeight + 20),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            image: DecorationImage(
              opacity: 0.4,
              fit: BoxFit.cover,
              image: NetworkImage(
                song.albumUrl,
              ),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Hero(
                    tag: song.albumUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: SizedBox(
                        height: context.height * 0.45,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            song.albumUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    song.name,
                    style: montserratText.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    song.artist,
                    style: montserratText.copyWith(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  BlocBuilder<DetailsBloc, DetailsState>(builder: (context, state) {
                    if (state is! DetailsLoaded) {
                      context.read<DetailsBloc>().add(
                            PlayerSetupRequested(
                              song.streamUrl,
                              (progress) {
                                context.read<DetailsBloc>().add(SongProgressUpdated(progress));
                              },
                            ),
                          );
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.surfaceTint,
                        ),
                      );
                    }

                    return Center(
                      child: Column(
                        children: [
                          AnimatedProgressBar(
                            width: context.height * 0.5,
                            value: state.progress,
                            bgColor: primaryColor.withOpacity(0.5),
                            progressColor: primaryColor,
                            radius: BorderRadius.circular(20),
                          ),
                          const SizedBox(height: 16.0),
                          IconButton(
                            icon: SizedBox(
                              height: 70,
                              width: 70,
                              child: CircleAvatar(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                child: AnimatedCrossFade(
                                  firstChild: const Icon(Icons.play_arrow),
                                  secondChild: const Icon(Icons.pause),
                                  crossFadeState: state.isPlaying ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  duration: 300.milliseconds,
                                ),
                              ),
                            ),
                            onPressed: () {
                              context.read<DetailsBloc>().add(SongPlayPauseRequested());
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      bool isFavorite = (state as UserLoaded).user.favorites.contains(song.id);
                      return FavoritesButton(
                        isFavorite: isFavorite,
                        onTap: () {
                          context.read<UserBloc>().add(UserFavoritesUpdateRequested(song.id));
                        },
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}