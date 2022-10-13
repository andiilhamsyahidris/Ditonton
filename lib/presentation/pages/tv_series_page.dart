import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/bloc_tv/tv_list_bloc/tv_list_bloc.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/custom_information.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page_tv_series.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-series';

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TvListBloc>().add(FetchTvList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tv Series'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPageTvSeries.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, WatchlistTvPage.ROUTE_NAME);
              },
              icon: Icon(Icons.download))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Now Playing',
                  style: kHeading6,
                ),
                BlocBuilder<TvListBloc, TvListState>(
                  builder: (context, state) {
                    if (state is TvListLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TvListHasData) {
                      final result = state.onTheAirTvSeries;
                      return TvList(result);
                    } else if (state is TvListError) {
                      return Expanded(
                        child: Center(
                          child: Text(state.message),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: CustomInformation(
                          asset: 'assets/search.svg',
                          title: 'Data tidak ditemukan',
                          subtitle: '',
                        ),
                      );
                    }
                  },
                ),
                _buildSubHeading(
                    title: 'Popular',
                    onTap: () {
                      Navigator.pushNamed(
                          context, PopularTvSeriesPage.ROUTE_NAME);
                    }),
                BlocBuilder<TvListBloc, TvListState>(
                  builder: (context, state) {
                    if (state is TvListLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TvListHasData) {
                      final result = state.popularTvSeries;
                      return TvList(result);
                    } else if (state is TvListError) {
                      return Expanded(
                        child: Center(
                          child: Text(state.message),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: CustomInformation(
                          asset: 'assets/search.svg',
                          title: 'Data tidak ditemukan',
                          subtitle: '',
                        ),
                      );
                    }
                  },
                ),
                _buildSubHeading(
                    title: 'Top Rated',
                    onTap: () {
                      Navigator.pushNamed(
                          context, TopRatedTvSeriesPage.ROUTE_NAME);
                    }),
                BlocBuilder<TvListBloc, TvListState>(
                  builder: (context, state) {
                    if (state is TvListLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TvListHasData) {
                      final result = state.topRatedTvSeries;
                      return TvList(result);
                    } else if (state is TvListError) {
                      return Expanded(
                        child: Center(
                          child: Text(state.message),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: CustomInformation(
                          asset: 'assets/search.svg',
                          title: 'Data tidak ditemukan',
                          subtitle: '',
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Row _buildSubHeading({required String title, required Function() onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: kHeading6,
      ),
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
          ),
        ),
      )
    ],
  );
}

class TvList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  TvList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, TvDetailPage.ROUTE_NAME,
                    arguments: tv.id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
