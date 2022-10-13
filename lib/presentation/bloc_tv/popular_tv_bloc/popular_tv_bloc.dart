import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvBloc({required this.getPopularTvSeries}) : super(PopularTvEmpty()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(PopularTvLoading());

      final result = await getPopularTvSeries.execute();
      result.fold((failure) {
        emit(PopularTvError(failure.message));
      }, (data) {
        emit(PopularTvHasData(data));
      });
    });
  }
}
