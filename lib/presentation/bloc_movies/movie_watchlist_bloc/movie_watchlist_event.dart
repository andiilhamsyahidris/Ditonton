part of 'movie_watchlist_bloc.dart';

abstract class MovieWatchlistEvent {
  const MovieWatchlistEvent();
}

class LoadMovieWatchlistStatus extends MovieWatchlistEvent {
  final int id;

  const LoadMovieWatchlistStatus(this.id);
}

class InsertMovieWatchlist extends MovieWatchlistEvent {
  final MovieDetail movieDetail;

  const InsertMovieWatchlist(this.movieDetail);
}

class RemoveMovieWatchlist extends MovieWatchlistEvent {
  final MovieDetail movieDetail;

  const RemoveMovieWatchlist(this.movieDetail);
}
