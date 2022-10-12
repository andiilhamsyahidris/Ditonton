import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvBloc({required this.getTopRatedTvSeries})
      : super(TopRatedTvEmpty()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(TopRatedTvLoading());

      final result = await getTopRatedTvSeries.execute();
      result.fold((failure) {
        emit(TopRatedTvError(failure.message));
      }, (data) {
        emit(TopRatedTvHasData(data));
      });
    });
  }
}
