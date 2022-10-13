import 'package:ditonton/domain/entities/episode.dart';
import 'package:equatable/equatable.dart';

class EpisodeModel extends Equatable {
  final String? airDate;
  final int episodeNumber;
  final String? name;
  final String? overview;
  final String? stillPath;

  const EpisodeModel(
      {required this.airDate,
      required this.episodeNumber,
      required this.name,
      required this.overview,
      required this.stillPath});

  factory EpisodeModel.fromJson(Map<String, dynamic> episode) {
    return EpisodeModel(
        airDate: episode['air_date'] ?? '',
        episodeNumber: episode['episode_number'],
        name: episode['name'],
        overview: episode['overview'],
        stillPath: episode['still_path']);
  }
  Map<String, dynamic> toJson() {
    return {
      'air_date': airDate,
      'episode_number': episodeNumber,
      'name': name,
      'overview': overview,
      'still_path': stillPath
    };
  }

  Episode toEntity() {
    return Episode(
      airDate: airDate ?? '',
      episodeNumber: episodeNumber,
      name: name ?? '',
      overview: overview ?? '',
      stillPath: stillPath ?? '',
    );
  }

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        name,
        overview,
        stillPath,
      ];
}
