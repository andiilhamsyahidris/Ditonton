import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class SeasonModel extends Equatable {
  final String? airDate;
  final int episodeCount;
  final String? name;
  final String? overview;
  final String? posterPath;
  final int seasonNumber;

  const SeasonModel(
      {required this.airDate,
      required this.episodeCount,
      required this.name,
      required this.overview,
      required this.posterPath,
      required this.seasonNumber});

  factory SeasonModel.fromJson(Map<String, dynamic> season) {
    return SeasonModel(
        airDate: season['air_date'] ?? '',
        episodeCount: season['episode_count'],
        name: season['name'] ?? '',
        overview: season['overview'] ?? '',
        posterPath: season['poster_path'] ?? '',
        seasonNumber: season['season_number']);
  }
  Map<String, dynamic> toJson() {
    return {
      'air_date': airDate,
      'episode_count': episodeCount,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'season_number': seasonNumber,
    };
  }

  Season toEntity() {
    return Season(
      airDate: airDate ?? '',
      episodeCount: episodeCount,
      name: name ?? '',
      overview: overview ?? '',
      posterPath: posterPath ?? '',
      seasonNumber: seasonNumber,
    );
  }

  @override
  List<Object?> get props => [
        airDate,
        episodeCount,
        name,
        overview,
        posterPath,
        seasonNumber,
      ];
}
