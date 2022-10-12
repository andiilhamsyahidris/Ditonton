import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  TvSeries(
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

  TvSeries.watchlist(
      {required this.id,
      required this.name,
      required this.posterPath,
      required this.overview});

  int id;
  String name;
  List<int>? genreIds;
  String? originalName;
  String? releaseDate;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;
  String? overview;

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
