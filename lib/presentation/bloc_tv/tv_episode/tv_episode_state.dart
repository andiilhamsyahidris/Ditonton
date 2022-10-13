part of 'tv_episode_bloc.dart';

abstract class TvEpisodeState extends Equatable {
  const TvEpisodeState();

  @override
  List<Object> get props => [];
}

class TvEpisodeEmpty extends TvEpisodeState {}

class TvEpisodeLoading extends TvEpisodeState {}

class TvEpisodeError extends TvEpisodeState {
  final String message;

  const TvEpisodeError(this.message);

  @override
  List<Object> get props => [message];
}

class TvEpisodeHasData extends TvEpisodeState {
  final List<Episode> episodes;

  const TvEpisodeHasData(this.episodes);

  @override
  List<Object> get props => [episodes];
}
