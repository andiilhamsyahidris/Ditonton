part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistState extends Equatable {
  const TvWatchlistState();

  @override
  List<Object> get props => [];
}

class TvWatchlistStatusEmpty extends TvWatchlistState {}

class TvWatchlistStatusError extends TvWatchlistState {
  final String message;
  const TvWatchlistStatusError(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistStatusHasData extends TvWatchlistState {
  final bool isWatchlist;
  const TvWatchlistStatusHasData(this.isWatchlist);

  @override
  List<Object> get props => [isWatchlist];
}

class InsertOrRemoveWatchlistSuccess extends TvWatchlistState {
  final String successMessage;

  const InsertOrRemoveWatchlistSuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class InsertOrRemoveWatchlistFailed extends TvWatchlistState {
  final String failureMessage;

  const InsertOrRemoveWatchlistFailed(this.failureMessage);

  @override
  List<Object> get props => [failureMessage];
}
