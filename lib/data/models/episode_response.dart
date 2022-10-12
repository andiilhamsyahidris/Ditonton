import 'package:ditonton/data/models/episode_model.dart';
import 'package:equatable/equatable.dart';

class EpisodeResponse extends Equatable {
  final List<EpisodeModel> episodes;

  const EpisodeResponse({required this.episodes});

  factory EpisodeResponse.fromJson(Map<String, dynamic> season) {
    return EpisodeResponse(
      episodes: List<EpisodeModel>.from(
        (season['episodes'] as List).map((eps) => EpisodeModel.fromJson(eps)),
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'episodes': List<dynamic>.from(episodes.map((eps) => eps.toJson()))
    };
  }

  @override
  List<Object> get props => [episodes];
}
