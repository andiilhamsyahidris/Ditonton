import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    id: 1,
    name: 'name',
    genreIds: [0, 1, 2],
    originalName: 'Original Name',
    popularity: 1,
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    voteAverage: 1.0,
    voteCount: 1,
    overview: 'Overview',
  );
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/on_the_air.json'));
      final result = TvResponse.fromJson(jsonMap);
      expect(result, tTvResponseModel);
    });
  });
  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTvResponseModel.toJson();
      final expectedJsonMap = {
        "results": [
          {
            "id": 1,
            "name": "name",
            "genre_ids": [0, 1, 2],
            "original_name": "Original Name",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "release_date": "2020-05-05",
            "vote_average": 1.0,
            "vote_count": 1,
            "overview": "Overview"
          }
        ]
      };
      expect(result, expectedJsonMap);
    });
  });
}
