import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailBloc(
      {required this.getMovieDetail, required this.getMovieRecommendations})
      : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());

      final id = event.id;
      final detailResult = await getMovieDetail.execute(id);
      final recommendationResult = await getMovieRecommendations.execute(id);

      detailResult.fold((failure) {
        emit(MovieDetailError(failure.message));
      }, (movieDetail) {
        recommendationResult.fold((failure) {
          emit(MovieDetailError(failure.message));
        }, (recommendations) {
          emit(MovieDetailHasData(
              movieDetail: movieDetail, recommendations: recommendations));
        });
      });
    });
  }
}
