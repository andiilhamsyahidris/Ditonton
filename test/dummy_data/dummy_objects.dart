import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_series.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);
final testTv = TvSeries(
    id: 94605,
    name: 'Arcane',
    genreIds: [16, 10765, 10759, 18],
    originalName: 'Arcane',
    overview:
        'Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic technologies and clashing convictions.',
    popularity: 119.061,
    posterPath: '/xQ6GijOFnxTyUzqiwGpVxgfcgqI.jpg',
    releaseDate: '2020-05-05',
    voteAverage: 8.8,
    voteCount: 2552);

final testMovieList = [testMovie];
final testTvList = [testTv];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testWatchlistTv = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'poster_path',
  overview: 'overview',
);

final testTvDetail = TvDetail(
    id: 1,
    name: 'name',
    genres: [Genre(id: 1, name: 'Action')],
    overview: 'overview',
    originalName: 'originalName',
    popularity: 1,
    posterPath: 'poster_path',
    backdropPath: 'backdropPath',
    releaseDate: 'releaseDate',
    voteAverage: 1,
    voteCount: 1);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};
final testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'poster_path',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'name': 'name',
  'poster_path': 'poster_path',
  'overview': 'overview',
};
