part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent {
  const MovieDetailEvent();
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;
  const FetchMovieDetail(this.id);
}
