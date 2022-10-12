import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
      id: 1,
      name: 'name',
      genreIds: [1, 2, 3],
      originalName: 'original_name',
      overview: 'overview',
      popularity: 1,
      posterPath: 'poster_path',
      releaseDate: 'release_date',
      voteAverage: 1,
      voteCount: 1);
  final tTv = TvSeries(
      id: 1,
      name: 'name',
      genreIds: [1, 2, 3],
      originalName: 'original_name',
      overview: 'overview',
      popularity: 1,
      posterPath: 'poster_path',
      releaseDate: 'release_date',
      voteAverage: 1,
      voteCount: 1);

  test('should be a subclass of Tv Entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}
