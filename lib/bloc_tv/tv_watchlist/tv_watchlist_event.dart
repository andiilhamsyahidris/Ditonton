part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistEvent {
  const TvWatchlistEvent();
}

class LoadTvWatchlistStatus extends TvWatchlistEvent {
  final int id;

  const LoadTvWatchlistStatus(this.id);
}

class InsertTvWatchlist extends TvWatchlistEvent {
  final TvDetail tvDetail;

  const InsertTvWatchlist(this.tvDetail);
}

class RemoveTvWatchlist extends TvWatchlistEvent {
  final TvDetail tvDetail;

  const RemoveTvWatchlist(this.tvDetail);
}
