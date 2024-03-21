// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymble_music/bloc/auth/auth_bloc.dart';
import 'package:nymble_music/bloc/details/details_bloc.dart';
import 'package:nymble_music/bloc/songs/songs_bloc.dart';
import 'package:nymble_music/bloc/theme/theme_bloc.dart';
import 'package:nymble_music/bloc/user/user_bloc.dart';
import 'package:nymble_music/helpers/connectivity_helper.dart';
import 'package:nymble_music/helpers/navigation_helper.dart';
import 'package:nymble_music/presentation/components/confirm_dialog.dart';
import 'package:nymble_music/presentation/components/input_field.dart';
import 'package:nymble_music/presentation/components/logo/logo_landscape.dart';
import 'package:nymble_music/presentation/components/songs_list.dart';
import 'package:nymble_music/presentation/constants/styles.dart';
import 'package:nymble_music/presentation/screens/auth_screen.dart';
import 'package:nymble_music/presentation/screens/details_screen.dart';
import 'package:nymble_music/utils/extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    ConnectivityHelper.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityHelper.instance.setOnConnectivityChanged((isConnected) {
      if (isConnected) {
        context.read<UserBloc>().add(UserPendingActionRequested());
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: BlocBuilder<SongsBloc, SongsState>(
            builder: (context, songsState) {
              return BlocListener<AuthBloc, AuthState>(
                listener: (context, authState) {
                  if (authState is AuthInitial) {
                    NavigationHelper.replace(context, page: const AuthScreen());
                    context.read<UserBloc>().add(UserLoggedOut());
                    context.read<SongsBloc>().add(SongsResetRequested());
                  }
                },
                child: BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserLoaded) {
                      if (songsState is SongsLoaded) {
                        if (songsState.userFavorites != null) {
                          context.read<SongsBloc>().add(SongsFavoritesOnlySelected(state.user.favorites));
                        }
                      }
                    }
                  },
                  builder: (context, userState) {
                    final authState = context.read<AuthBloc>().state;
                    if (userState is UserInitial && authState is AuthSuccess) {
                      context.read<UserBloc>().add(UserLoggedIn(authState.userId));
                    }

                    if (songsState is SongsInitial && authState is AuthSuccess) {
                      context.read<SongsBloc>().add(FetchSongsRequested());
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            children: [
                              const LogoLandscape(),
                              const Spacer(),
                              ZoomIn(
                                delay: 1.seconds,
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<ThemeBloc>().add(ThemeChanged());
                                  },
                                  child: CircleAvatar(
                                    child: Icon((context.read<ThemeBloc>().state as ThemeSelected).darkMode ? Icons.light_mode : Icons.dark_mode),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ZoomIn(
                                delay: 1100.milliseconds,
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await showConfirmDialog(context, "Log Out?", "Are you sure you want to log out of Nymble Music?");
                                    if (result) {
                                      context.read<AuthBloc>().add(AuthLogoutRequested());
                                    }
                                  },
                                  child: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (songsState is SongsLoading || userState is UserLoading) ...[
                          Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.surfaceTint,
                              ),
                            ),
                          ),
                        ],
                        if ((songsState is SongsLoaded) && (userState is UserLoaded)) ...[
                          FadeInUp(
                            duration: 300.milliseconds,
                            child: InputField(
                              textInputAction: TextInputAction.search,
                              onChanged: (query) {
                                context.read<SongsBloc>().add(SearchSongsRequested(query.trim().toLowerCase()));
                              },
                              controller: searchController,
                              hint: "Search",
                            ),
                          ),
                          SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 10, top: 5),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FadeIn(
                                    delay: 400.milliseconds,
                                    child: FilterChip(
                                      selected: songsState.userFavorites != null,
                                      label: Text(
                                        "Favorites",
                                        style: montserratText,
                                      ),
                                      onSelected: (bool selected) {
                                        SongsFavoritesOnlySelected event;
                                        if (selected) {
                                          event = SongsFavoritesOnlySelected(userState.user.favorites);
                                        } else {
                                          event = SongsFavoritesOnlySelected(null);
                                        }
                                        context.read<SongsBloc>().add(event);
                                      },
                                    ),
                                  ),
                                ),
                                ...songsState.allFilters.map(
                                  (genre) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: FadeIn(
                                        delay: (songsState.allFilters.indexOf(genre) * 100 + 500).milliseconds,
                                        child: FilterChip(
                                          selected: songsState.filter == genre,
                                          label: Text(
                                            genre,
                                            style: montserratText,
                                          ),
                                          onSelected: (bool selected) {
                                            SearchFilterChanged event;
                                            if (selected) {
                                              event = SearchFilterChanged(genre);
                                            } else {
                                              event = SearchFilterChanged("");
                                            }
                                            context.read<SongsBloc>().add(event);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: FadeInUp(
                              // delay: 500.milliseconds,
                              child: SongList(
                                songs: songsState.filteredSongs,
                                searchQuery: songsState.searchQuery,
                                onAddToFavorites: (song) {
                                  context.read<UserBloc>().add(UserFavoritesUpdateRequested(song.id));
                                },
                                onTapped: (song) {
                                  NavigationHelper.to(
                                    context,
                                    page: BlocProvider(
                                      create: (BuildContext context) => DetailsBloc(),
                                      child: DetailsScreen(
                                        song: song,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
