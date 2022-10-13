import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/presentation/bloc_movies/movie_watchlist_bloc/movie_watchlist_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchListStatus, SaveWatchlist, RemoveWatchlist])
void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  const tId = 1;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieWatchlistBloc = MovieWatchlistBloc(
        getWatchlistStatus: mockGetWatchListStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist);
  });

  test('Initial state should be empty', () {
    expect(movieWatchlistBloc.state, MovieWatchlistStatusEmpty());
  });

  group('Movie watchlist status test', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit HasData when movie watchlist status is gotten successfully',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => Right(true));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(LoadMovieWatchlistStatus(tId)),
      expect: () => [MovieWatchlistStatusHasData(true)],
      verify: (_) => verify(mockGetWatchListStatus.execute(tId)),
    );
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit Error when movie watchlist status is gotten unsuccessful',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(LoadMovieWatchlistStatus(tId)),
      expect: () => [MovieWatchlistStatusError('Database Failure')],
      verify: (_) => verify(mockGetWatchListStatus.execute(tId)),
    );
  });
  group('Insert movie watchlist test', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit Success when insert movie to database successfully',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added movie to Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => Right(true));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(InsertMovieWatchlist(testMovieDetail)),
      expect: () => [
        InsertOrRemoveWatchlistSuccess('Added movie to Watchlist'),
        MovieWatchlistStatusHasData(true)
      ],
      verify: (_) => verify(mockSaveWatchlist.execute(testMovieDetail)),
    );
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit Failed when insert movie to database unsuccessful',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => Right(false));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(InsertMovieWatchlist(testMovieDetail)),
      expect: () => [
        InsertOrRemoveWatchlistFailed('Database Failure'),
        MovieWatchlistStatusHasData(false)
      ],
      verify: (_) => verify(mockSaveWatchlist.execute(testMovieDetail)),
    );
  });
  group('Remove movie watchlist test', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit Success when remove movie to database successfully',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Remove movie from Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => Right(true));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveMovieWatchlist(testMovieDetail)),
      expect: () => [
        InsertOrRemoveWatchlistSuccess('Remove movie from Watchlist'),
        MovieWatchlistStatusHasData(true)
      ],
      verify: (_) => verify(mockRemoveWatchlist.execute(testMovieDetail)),
    );
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit Failed when remove movie to database unsuccessful',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => Right(false));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveMovieWatchlist(testMovieDetail)),
      expect: () => [
        InsertOrRemoveWatchlistFailed('Database Failure'),
        MovieWatchlistStatusHasData(false),
      ],
      verify: (_) => verify(mockRemoveWatchlist.execute(testMovieDetail)),
    );
  });
}
