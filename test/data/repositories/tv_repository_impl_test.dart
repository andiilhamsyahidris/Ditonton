import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repositoryImpl;
  late MockTvRemoteDataSource mockTvRemoteDataSource;
  late MockTvLocalDataSource mockTvLocalDataSource;

  setUp(() {
    mockTvRemoteDataSource = MockTvRemoteDataSource();
    mockTvLocalDataSource = MockTvLocalDataSource();
    repositoryImpl = TvRepositoryImpl(
        remoteDataSource: mockTvRemoteDataSource,
        tvLocalDataSource: mockTvLocalDataSource);
  });

  final tTvModel = TvModel(
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
    voteCount: 2552,
  );

  final tTv = TvSeries(
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
    voteCount: 2552,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <TvSeries>[tTv];

  const tEpisodeModel = EpisodeModel(
    airDate: "2013-09-12",
    episodeNumber: 1,
    name: "Episode 1",
    overview:
        "Birmingham, 1919. Thomas Shelby controls the Peaky Blinders, one of the city's most feared criminal organisations, but his ambitions go beyond running the streets. When a crate of guns goes missing, Thomas recognises an opportunity to move up in the world.",
    stillPath: "/tplu6cXP312IN5rrT5K81zFZpMd.jpg",
  );
  const tEpisode = Episode(
    airDate: "2013-09-12",
    episodeNumber: 1,
    name: "Episode 1",
    overview:
        "Birmingham, 1919. Thomas Shelby controls the Peaky Blinders, one of the city's most feared criminal organisations, but his ambitions go beyond running the streets. When a crate of guns goes missing, Thomas recognises an opportunity to move up in the world.",
    stillPath: "/tplu6cXP312IN5rrT5K81zFZpMd.jpg",
  );
  final tEpisodeModelList = <EpisodeModel>[tEpisodeModel];
  final tEpisodeList = <Episode>[tEpisode];

  group('On The Air Tv', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockTvRemoteDataSource.getNowPlayingTvSeries())
          .thenAnswer((_) async => tTvModelList);
      final result = await repositoryImpl.getNowPlayingTvSeries();
      verify(mockTvRemoteDataSource.getNowPlayingTvSeries());

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockTvRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(ServerException());

      final result = await repositoryImpl.getNowPlayingTvSeries();
      verify(mockTvRemoteDataSource.getNowPlayingTvSeries());

      expect(result, equals(Left(ServerFailure(''))));
    });
  });

  group('Popular Tv Series', () {
    test('should return tv list when call to data source is success', () async {
      when(mockTvRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tTvModelList);
      final result = await repositoryImpl.getPopularTvSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });
    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      when(mockTvRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());
      final result = await repositoryImpl.getPopularTvSeries();
      expect(result, Left(ServerFailure('')));
    });
    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      when(mockTvRemoteDataSource.getPopularTvSeries())
          .thenThrow(SocketException('Failed to Connect to the Network'));
      final result = await repositoryImpl.getPopularTvSeries();
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
  group('Top Rated Tv Series', () {
    test('should return tv list when call to data source is success', () async {
      when(mockTvRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvModelList);
      final result = await repositoryImpl.getTopRatedTvSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });
    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      when(mockTvRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      final result = await repositoryImpl.getTopRatedTvSeries();
      expect(result, Left(ServerFailure('')));
    });
    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      when(mockTvRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(SocketException('Failed to Connect to the Network'));
      final result = await repositoryImpl.getTopRatedTvSeries();
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Series Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailModel(
        id: 1,
        name: 'name',
        genres: [GenreModel(id: 1, name: 'Action')],
        overview: 'overview',
        popularity: 1,
        posterPath: 'poster_path',
        backdropPath: 'backdropPath',
        voteCount: 1,
        voteAverage: 1,
        originalName: 'originalName',
        releaseDate: 'releaseDate',
        firstAirDate: 'firstAirDate',
        lastAirDate: 'lastAirDate',
        numberOfEpisodes: 1,
        numberOfSeasons: 1,
        seasons: [
          SeasonModel(
              airDate: 'airDate',
              episodeCount: 1,
              name: 'name',
              overview: 'overview',
              posterPath: 'posterPath',
              seasonNumber: 1)
        ]);

    test(
        'should return Tv Series data when the call to remote data source is successful',
        () async {
      when(mockTvRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvResponse);
      final result = await repositoryImpl.getTvDetail(tId);
      verify(mockTvRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(testTvDetail)));
    });
    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      when(mockTvRemoteDataSource.getTvDetail(tId))
          .thenThrow(ServerException());
      final result = await repositoryImpl.getTvDetail(tId);
      verify(mockTvRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      when(mockTvRemoteDataSource.getTvDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repositoryImpl.getTvDetail(tId);
      verify(mockTvRemoteDataSource.getTvDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
    group('Get Tv Series Recommendations', () {
      final tTvList = <TvModel>[];
      final tId = 1;

      test('should return data when the call is successful', () async {
        when(mockTvRemoteDataSource.getTvRecommendations(tId))
            .thenAnswer((_) async => tTvList);

        final result = await repositoryImpl.getTvRecommendations(tId);
        verify(mockTvRemoteDataSource.getTvRecommendations(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvList));
      });
      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        when(mockTvRemoteDataSource.getTvRecommendations(tId))
            .thenThrow(ServerException());
        final result = await repositoryImpl.getTvRecommendations(tId);
        verify(mockTvRemoteDataSource.getTvRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      });
      test(
          'should return connection failure when the device is not connected to the internet',
          () async {
        when(mockTvRemoteDataSource.getTvRecommendations(tId))
            .thenThrow(SocketException('Failed to connect to the network'));
        final result = await repositoryImpl.getTvRecommendations(tId);
        verify(mockTvRemoteDataSource.getTvRecommendations(tId));
        expect(
            result,
            equals(
                Left(ConnectionFailure('Failed to connect to the network'))));
      });
    });
    group('Search Tv Series', () {
      final tQuery = 'arcane';

      test(
          'should return tv series list when call to data source is successful',
          () async {
        when(mockTvRemoteDataSource.searchTvSeries(tQuery))
            .thenAnswer((_) async => tTvModelList);
        final result = await repositoryImpl.searchTvSeries(tQuery);
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      });
      test(
          'should return ServerFailure when call to data source is unsuccessful',
          () async {
        when(mockTvRemoteDataSource.searchTvSeries(tQuery))
            .thenThrow(ServerException());
        final result = await repositoryImpl.searchTvSeries(tQuery);
        expect(result, Left(ServerFailure('')));
      });
      test(
          'should return ConnectionFailure when device is not connect to the internet',
          () async {
        when(mockTvRemoteDataSource.searchTvSeries(tQuery))
            .thenThrow(SocketException('Failed to connect to the network'));
        final result = await repositoryImpl.searchTvSeries(tQuery);
        expect(result,
            Left(ConnectionFailure('Failed to connect to the network')));
      });
    });
  });
  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockTvLocalDataSource.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repositoryImpl.saveWatchlist(testTvDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockTvLocalDataSource.insertWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repositoryImpl.saveWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });
  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockTvLocalDataSource.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repositoryImpl.removeWatchlist(testTvDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockTvLocalDataSource.removeWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repositoryImpl.removeWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });
  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockTvLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repositoryImpl.isAddedToWatchlist(tId);
      // assert
      expect(result, Right(false));
    });
  });
  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockTvLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repositoryImpl.getWatchlistTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });

  group('get tv show episodes', () {
    const tId = 1;
    const tSeasonNumber = 1;
    test('should return tv show episodes', () async {
      when(mockTvRemoteDataSource.getTvShowEpisodes(tId, tSeasonNumber))
          .thenAnswer((_) async => tEpisodeModelList);

      final result = await repositoryImpl.getTvShowEpisodes(tId, tSeasonNumber);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tEpisodeList);
    });
    test('should return server failure when call data is unsuccessful',
        () async {
      when(mockTvRemoteDataSource.getTvShowEpisodes(tId, tSeasonNumber))
          .thenThrow(ServerException());
      final result = await repositoryImpl.getTvShowEpisodes(tId, tSeasonNumber);
      expect(
        result,
        Left(ServerFailure('')),
      );
    });
  });
}
