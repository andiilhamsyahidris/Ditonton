import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  TvDetail(
      {required this.id,
      required this.name,
      required this.genres,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.backdropPath,
      required this.voteCount,
      required this.voteAverage,
      required this.originalName,
      required this.releaseDate,
      required this.firstAirDate,
      required this.lastAirDate,
      required this.numberOfEpisodes,
      required this.numberOfSeasons,
      required this.seasons});

  final int id;
  final String name;
  final List<Genre> genres;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? backdropPath;
  final int voteCount;
  final double voteAverage;
  final String originalName;
  final String? releaseDate;
  final int numberOfEpisodes;
  final String firstAirDate;
  final String lastAirDate;
  final int numberOfSeasons;
  final List<Season> seasons;

  @override
  List<Object?> get props => [
        id,
        name,
        genres,
        overview,
        popularity,
        posterPath,
        backdropPath,
        voteCount,
        voteAverage,
        originalName,
        releaseDate,
        firstAirDate,
        lastAirDate,
        numberOfEpisodes,
        numberOfSeasons,
        seasons
      ];
}
