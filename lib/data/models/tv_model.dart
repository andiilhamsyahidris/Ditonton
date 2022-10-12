import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class TvModel extends Equatable {
  TvModel(
      {required this.id,
      required this.name,
      required this.genreIds,
      required this.originalName,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.releaseDate,
      required this.voteAverage,
      required this.voteCount});

  final int id;
  final String name;
  final List<int> genreIds;
  final String originalName;
  final String? releaseDate;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;
  final String? overview;

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
        id: json["id"],
        name: json["name"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        originalName: json["original_name"],
        releaseDate: json["release_date"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        overview: json['overview'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "genre_ids": genreIds,
        "original_name": originalName,
        "release_date": releaseDate,
        "popularity": popularity,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "overview": overview,
      };
  TvSeries toEntity() {
    return TvSeries(
        id: this.id,
        name: this.name,
        genreIds: this.genreIds,
        originalName: this.originalName,
        releaseDate: this.releaseDate,
        popularity: this.popularity,
        posterPath: this.posterPath,
        voteAverage: this.voteAverage,
        voteCount: this.voteCount,
        overview: this.overview);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        genreIds,
        originalName,
        releaseDate,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
        overview
      ];
}
