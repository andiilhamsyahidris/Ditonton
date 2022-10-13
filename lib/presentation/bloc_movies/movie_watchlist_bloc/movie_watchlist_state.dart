part of 'movie_watchlist_bloc.dart';

abstract class MovieWatchlistState extends Equatable {
  const MovieWatchlistState();

  @override
  List<Object> get props => [];
}

class MovieWatchlistStatusEmpty extends MovieWatchlistState {}

class MovieWatchlistStatusError extends MovieWatchlistState {
  final String message;
  const MovieWatchlistStatusError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistStatusHasData extends MovieWatchlistState {
  final bool isWatchlist;
  const MovieWatchlistStatusHasData(this.isWatchlist);

  @override
  List<Object> get props => [isWatchlist];
}

class InsertOrRemoveWatchlistSuccess extends MovieWatchlistState {
  final String successMessage;

  const InsertOrRemoveWatchlistSuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class InsertOrRemoveWatchlistFailed extends MovieWatchlistState {
  final String failureMessage;

  const InsertOrRemoveWatchlistFailed(this.failureMessage);

  @override
  List<Object> get props => [failureMessage];
}
