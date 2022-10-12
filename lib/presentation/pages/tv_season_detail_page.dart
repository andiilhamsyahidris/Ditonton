import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/bloc_tv/tv_episode/tv_episode_bloc.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class TvSeasonDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/season_detail';

  final int tvShowId;
  final Season season;

  const TvSeasonDetailPage(
      {Key? key, required this.season, required this.tvShowId});

  @override
  State<TvSeasonDetailPage> createState() => _TvSeasonDetailPageState();
}

class _TvSeasonDetailPageState extends State<TvSeasonDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<TvEpisodeBloc>()
          .add(FetchTvEpisodes(widget.tvShowId, widget.season.seasonNumber));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvEpisodeBloc, TvEpisodeState>(
        builder: (context, state) {
          if (state is TvEpisodeHasData) {
            return _buildMainScreen(state.episodes);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  NestedScrollView _buildMainScreen(List<Episode> episodes) {
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return [
          SliverAppBar(
            forceElevated: isScrolled,
            pinned: true,
            expandedHeight: 260,
            title: Text(widget.season.name),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${widget.season.posterPath}',
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [kRichBlack, Colors.transparent])),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            kRichBlack.withOpacity(0.5),
                            Colors.transparent
                          ])),
                    ),
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxHeight: 360 - kToolbarHeight),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'S${widget.season.seasonNumber} ● ${widget.season.episodeCount} Episodes',
                            style: kHeading5,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            _showEpisodeAirDate(widget.season.airDate),
                            style: kSubtitle.copyWith(color: kMikadoYellow),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: ReadMoreText(
                              widget.season.overview,
                              trimLines: 4,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '... Show more',
                              trimExpandedText: 'Show less',
                              style: const TextStyle(color: kDavysGrey),
                              lessStyle: const TextStyle(color: Colors.white),
                              moreStyle: const TextStyle(color: Colors.white),
                              delimiter: ' ',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ];
      },
      body: _buildEpisodeList(episodes),
    );
  }

  ListView _buildEpisodeList(List<Episode> episodes) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w300${episode.stillPath}',
                      width: double.infinity,
                      height: 140,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black87, Colors.transparent]),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Episode ${episode.episodeNumber}',
                        style: kHeading6,
                      ),
                      subtitle: Text(
                        _showEpisodeAirDate(episode.airDate),
                        style: const TextStyle(color: kMikadoYellow),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    episode.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kSubtitle,
                  ),
                  ReadMoreText(
                    episode.overview,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '... Show more',
                    trimExpandedText: 'Show less',
                    style: const TextStyle(color: kDavysGrey),
                    lessStyle: const TextStyle(color: Colors.white),
                    moreStyle: const TextStyle(color: Colors.white),
                    delimiter: ' ',
                  )
                ],
              ),
            )
          ],
        );
      },
      separatorBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(),
        );
      },
      itemCount: episodes.length,
    );
  }

  String _showEpisodeAirDate(String airDate) {
    final airDateParse = airDate.isEmpty
        ? '?'
        : DateFormat('MMM dd, y').format(DateTime.parse(airDate));
    return '$airDateParse';
  }
}

class TvSeasonDetailArgs {
  final int tvShowId;
  final Season season;

  TvSeasonDetailArgs(this.tvShowId, this.season);
}
