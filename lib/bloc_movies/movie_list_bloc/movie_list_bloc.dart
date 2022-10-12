import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc(
      {required this.getNowPlayingMovies,
      required this.getPopularMovies,
      required this.getTopRatedMovies})
      : super(MovieListEmpty()) {
    on<FetchMoviesList>(
      (event, emit) async {
        emit(MovieListLoading());

        final nowPlayingResult = await getNowPlayingMovies.execute();
        final popularResult = await getPopularMovies.execute();
        final topRatedResult = await getTopRatedMovies.execute();

        nowPlayingResult.fold(
            (failure) => emit(
                  MovieListError(failure.message),
                ), (nowPlayingMovies) {
          popularResult.fold(
              (failure) => emit(
                    MovieListError(failure.message),
                  ), (popularMovies) {
            topRatedResult.fold(
                (failure) => emit(
                      MovieListError(failure.message),
                    ), (topRatedMovies) {
              emit(
                MovieListHasData(
                    nowPlayingMovies, popularMovies, topRatedMovies),
              );
            });
          });
        });
      },
    );
  }
}
