import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final String airDate;
  final int episodeNumber;
  final String name;
  final String overview;
  final String stillPath;

  const Episode(
      {required this.airDate,
      required this.episodeNumber,
      required this.name,
      required this.overview,
      required this.stillPath});

  @override
  List<Object> get props => [
        airDate,
        episodeNumber,
        name,
        overview,
        stillPath,
      ];
}
