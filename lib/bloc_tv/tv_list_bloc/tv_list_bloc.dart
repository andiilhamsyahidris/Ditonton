import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTv getNowPlayingTv;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvListBloc({
    required this.getNowPlayingTv,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(TvListEmpty()) {
    on<FetchTvList>((event, emit) async {
      emit(TvListLoading());

      final onTheAirResult = await getNowPlayingTv.execute();
      final popularResult = await getPopularTvSeries.execute();
      final topRatedResult = await getTopRatedTvSeries.execute();

      onTheAirResult.fold((failure) => emit(TvListError(failure.message)),
          (onTheAirTv) {
        popularResult.fold((failure) => emit(TvListError(failure.message)),
            (popularTv) {
          topRatedResult.fold((failure) => emit(TvListError(failure.message)),
              (topRatedTv) {
            emit(
              TvListHasData(onTheAirTv, popularTv, topRatedTv),
            );
          });
        });
      });
    });
  }
}
