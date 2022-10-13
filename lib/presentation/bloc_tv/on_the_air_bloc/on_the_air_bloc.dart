import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:equatable/equatable.dart';

part 'on_the_air_event.dart';
part 'on_the_air_state.dart';

class OnTheAirBloc extends Bloc<OnTheAirEvent, OnTheAirState> {
  final GetNowPlayingTv getNowPlayingTv;

  OnTheAirBloc({required this.getNowPlayingTv}) : super(OnTheAirEmpty()) {
    on<FetchOnTheAirTvSeries>((event, emit) async {
      emit(OnTheAirLoading());

      final result = await getNowPlayingTv.execute();
      result.fold((failure) {
        emit(OnTheAirError(failure.message));
      }, (data) {
        emit(OnTheAirHasData(data));
      });
    });
  }
}
