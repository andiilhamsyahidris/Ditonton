import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailModel extends Equatable {
  TvDetailModel(
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
  final List<GenreModel> genres;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? backdropPath;
  final int voteCount;
  final double voteAverage;
  final String originalName;
  final String? releaseDate;
  final String? firstAirDate;
  final String? lastAirDate;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<SeasonModel> seasons;

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
      id: json["id"],
      name: json["name"],
      genres: List<GenreModel>.from(
        json["genres"].map((x) => GenreModel.fromJson(x)),
      ),
      overview: json["overview"],
      popularity: json["popularity"].toDouble(),
      posterPath: json["poster_path"],
      backdropPath: json["backdrop_path"] ?? '',
      voteCount: json["vote_count"],
      voteAverage: json["vote_average"],
      originalName: json["original_name"],
      releaseDate: json["release_date"] ?? '',
      firstAirDate: json['first_air_date'] ?? '',
      lastAirDate: json['last_air_date'] ?? '',
      numberOfEpisodes: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons'],
      seasons: List<SeasonModel>.from(
          (json['seasons']).map((e) => SeasonModel.fromJson(e))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "genres": List<dynamic>.from(genres.map((e) => e.toJson())),
        "overview": overview,
        "populariy": popularity,
        "poster_path": posterPath,
        "backdrop_path": backdropPath,
        "vote_count": voteCount,
        "vote_average": voteAverage,
        "original_name": originalName,
        "release_date": releaseDate,
        'first_air_date': firstAirDate,
        'last_air_date': lastAirDate,
        'number_of_episodes': numberOfEpisodes,
        'number_of_seasons': numberOfSeasons,
        'seasons': List<dynamic>.from(
          seasons.map((e) => e.toJson()),
        ),
      };

  TvDetail toEntity() {
    return TvDetail(
        id: this.id,
        name: this.name,
        genres: this.genres.map((genre) => genre.toEntity()).toList(),
        overview: this.overview,
        popularity: this.popularity,
        posterPath: this.posterPath,
        backdropPath: this.backdropPath,
        voteAverage: this.voteAverage,
        voteCount: this.voteCount,
        originalName: this.originalName,
        releaseDate: this.releaseDate,
        firstAirDate: firstAirDate ?? '',
        lastAirDate: lastAirDate ?? '',
        numberOfEpisodes: numberOfEpisodes,
        numberOfSeasons: numberOfSeasons,
        seasons: seasons.map((season) => season.toEntity()).toList());
  }

  @override
  List<Object?> get props => [
        id,
        name,
        genres,
        overview,
        popularity,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        originalName,
        releaseDate,
        firstAirDate,
        lastAirDate,
        numberOfEpisodes,
        numberOfSeasons,
        seasons,
      ];
}
