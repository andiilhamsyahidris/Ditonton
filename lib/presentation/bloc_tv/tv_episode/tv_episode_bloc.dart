import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/usecases/get_tv_episodes.dart';
import 'package:equatable/equatable.dart';

part 'tv_episode_event.dart';
part 'tv_episode_state.dart';

class TvEpisodeBloc extends Bloc<TvEpisodeEvent, TvEpisodeState> {
  final GetTvEpisodes getTvEpisodes;

  TvEpisodeBloc({required this.getTvEpisodes}) : super(TvEpisodeEmpty()) {
    on<FetchTvEpisodes>((event, emit) async {
      emit(TvEpisodeLoading());

      final id = event.id;
      final seasonNumber = event.seasonNumber;
      final result = await getTvEpisodes.execute(id, seasonNumber);

      result.fold((failure) {
        emit(TvEpisodeError(failure.message));
      }, (data) {
        emit(TvEpisodeHasData(data));
      });
    });
  }
}
