import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/bloc_tv/tv_detail_bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc_tv/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_season_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail_tv';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(FetchTvDetail(widget.id));
      context.read<TvWatchlistBloc>().add(LoadTvWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final _isWatchlist = _getWatchlistStatus(context);
    return Scaffold(
      body: BlocListener<TvWatchlistBloc, TvWatchlistState>(
        listener: (context, state) {
          if (state is InsertOrRemoveWatchlistSuccess) {
            final SnackBar snackBar = SnackBar(
              content: Text(
                state.successMessage,
                style: kBodyText,
              ),
              backgroundColor: kMikadoYellow,
              duration: const Duration(milliseconds: 2000),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          } else if (state is InsertOrRemoveWatchlistFailed) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(state.failureMessage),
                  );
                });
          }
        },
        child: BlocBuilder<TvDetailBloc, TvDetailState>(
          builder: (context, state) {
            if (state is TvDetailHasData) {
              return SafeArea(
                child: DetailContent(
                    state.tvDetail, state.recommendations, _isWatchlist),
              );
            } else if (state is TvDetailError) {
              return Text('Failed');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  bool _getWatchlistStatus(BuildContext context) {
    final state = context.watch<TvWatchlistBloc>().state;

    if (state is TvWatchlistStatusHasData) return state.isWatchlist;

    return false;
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tvDetail;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tvDetail, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvDetail.name,
                              style: kHeading5,
                            ),
                            Text(
                              '${tvDetail.numberOfEpisodes} Episode',
                              style: kSubtitle,
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                _onPressedWatchlistStatus(context);
                              },
                              icon: isAddedWatchlist
                                  ? const Icon(Icons.check_rounded)
                                  : const Icon(Icons.add_rounded),
                              label: Text(
                                'Watchlist',
                                style: kSubtitle,
                              ),
                            ),
                            Text(_showGenres(tvDetail.genres)),
                            Text(_showReleaseDate(
                                tvDetail.firstAirDate, tvDetail.lastAirDate)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvDetail.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(tvDetail.overview),
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 240,
                              child: _buildSeasonList(),
                            ),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvDetailBloc, TvDetailState>(
                              builder: (context, state) {
                                if (state is TvDetailLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvDetailHasData) {
                                  final result = state.recommendations;
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = result[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  TvDetailPage.ROUTE_NAME,
                                                  arguments: tv.id);
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }
    if (result.isEmpty) {
      return result;
    }
    return result.substring(0, result.length - 2);
  }

  String _showReleaseDate(String firstAirDate, String lastAirDate) {
    final firstAirDateParse = firstAirDate.isEmpty
        ? '?'
        : DateFormat('MMM dd, y').format(DateTime.parse(firstAirDate));
    final lastAirDateParse = lastAirDate.isEmpty
        ? '?'
        : DateFormat('MMM dd, y').format(DateTime.parse(lastAirDate));

    return '$firstAirDateParse to $lastAirDateParse';
  }

  void _onPressedWatchlistStatus(BuildContext context) {
    if (isAddedWatchlist) {
      context.read<TvWatchlistBloc>().add(RemoveTvWatchlist(tvDetail));
    } else {
      context.read<TvWatchlistBloc>().add(InsertTvWatchlist(tvDetail));
    }
  }

  ListView _buildSeasonList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final season = tvDetail.seasons.reversed.toList()[index];

        return SizedBox(
          width: 240,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    if (season.seasonNumber != 0) {
                      Navigator.pushNamed(
                          context, TvSeasonDetailPage.ROUTE_NAME,
                          arguments: TvSeasonDetailArgs(tvDetail.id, season));
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${season.posterPath}',
                          width: 240,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.fitWidth,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black87, Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'S${season.seasonNumber} ● ${season.episodeCount} Episodes',
                            style: kSubtitle,
                          ),
                          subtitle: season.seasonNumber != 0
                              ? Row(
                                  children: const <Widget>[
                                    Text('Show Details',
                                        style: TextStyle(color: kMikadoYellow)),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      Icons.keyboard_double_arrow_right_rounded,
                                      size: 18,
                                      color: kMikadoYellow,
                                    )
                                  ],
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          season.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kSubtitle,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          season.overview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: kDavysGrey),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 12,
      ),
      itemCount: tvDetail.seasons.length,
    );
  }
}
