import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchListStatus getWatchlistStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieWatchlistBloc({
    required this.getWatchlistStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieWatchlistStatusEmpty()) {
    on<LoadMovieWatchlistStatus>((event, emit) async {
      final id = event.id;
      final result = await getWatchlistStatus.execute(id);

      result.fold(
        (failure) => emit(MovieWatchlistStatusError(failure.message)),
        (isWatchlist) => emit(MovieWatchlistStatusHasData(isWatchlist)),
      );
    });
    on<InsertMovieWatchlist>((event, emit) async {
      final movie = event.movieDetail;
      final result = await saveWatchlist.execute(movie);

      result.fold((failure) {
        emit(InsertOrRemoveWatchlistFailed(failure.message));
      }, (data) {
        emit(InsertOrRemoveWatchlistSuccess(data));
      });
      add(LoadMovieWatchlistStatus(movie.id));
    });
    on<RemoveMovieWatchlist>(
      (event, emit) async {
        final movie = event.movieDetail;
        final result = await removeWatchlist.execute(movie);

        result.fold((failure) {
          emit(InsertOrRemoveWatchlistFailed(failure.message));
        }, (data) {
          emit(InsertOrRemoveWatchlistSuccess(data));
        });
        add(LoadMovieWatchlistStatus(movie.id));
      },
    );
  }
}
