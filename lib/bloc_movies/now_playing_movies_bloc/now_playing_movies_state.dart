part of 'now_playing_movies_bloc.dart';

abstract class NowPlayingMoviesState extends Equatable {
  const NowPlayingMoviesState();

  @override
  List<Object> get props => [];
}

class MovieListEmpty extends NowPlayingMoviesState {}

class MovieListLoading extends NowPlayingMoviesState {}

class MovieListError extends NowPlayingMoviesState {
  final String message;

  MovieListError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieListHasData extends NowPlayingMoviesState {
  final List<Movie> resultMovie;

  MovieListHasData(this.resultMovie);

  @override
  List<Object> get props => [resultMovie];
}
