part of 'tv_episode_bloc.dart';

abstract class TvEpisodeEvent {
  const TvEpisodeEvent();
}

class FetchTvEpisodes extends TvEpisodeEvent {
  final int id;
  final int seasonNumber;

  const FetchTvEpisodes(this.id, this.seasonNumber);
}
