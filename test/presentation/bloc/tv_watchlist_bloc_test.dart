import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/presentation/bloc_tv/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvStatus, SaveWatchlistTv, RemoveWatchlistTv])
void main() {
  late TvWatchlistBloc tvWatchlistBloc;
  late MockGetWatchlistTvStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  const tId = 1;

  setUp(() {
    mockGetWatchlistTvStatus = MockGetWatchlistTvStatus();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    tvWatchlistBloc = TvWatchlistBloc(
        getWatchlistTvStatus: mockGetWatchlistTvStatus,
        saveWatchlistTv: mockSaveWatchlistTv,
        removeWatchlistTv: mockRemoveWatchlistTv);
  });

  test('Initial state should be empty', () {
    expect(tvWatchlistBloc.state, TvWatchlistStatusEmpty());
  });

  group('Tv watchlist status test', () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit HasData when tv watchlist status is gotten successfully',
      build: () {
        when(mockGetWatchlistTvStatus.execute(tId))
            .thenAnswer((_) async => Right(true));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(LoadTvWatchlistStatus(tId)),
      expect: () => [TvWatchlistStatusHasData(true)],
      verify: (_) => verify(mockGetWatchlistTvStatus.execute(tId)),
    );
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit HasData when tv watchlist status is gotten unsuccessful',
      build: () {
        when(mockGetWatchlistTvStatus.execute(tId))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(LoadTvWatchlistStatus(tId)),
      expect: () => [TvWatchlistStatusError('Database Failure')],
      verify: (_) => verify(mockGetWatchlistTvStatus.execute(tId)),
    );
  });
  group('Insert tv watchlist test', () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit Success when insert tv to database successfully',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Right('Added tv to watchlist'));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => Right(true));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(InsertTvWatchlist(testTvDetail)),
      expect: () => [
        InsertOrRemoveWatchlistSuccess('Added tv to watchlist'),
        TvWatchlistStatusHasData(true)
      ],
    );
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit failed when insert tv to database unsuccessful',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => Right(false));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(InsertTvWatchlist(testTvDetail)),
      expect: () => [
        InsertOrRemoveWatchlistFailed('Database Failure'),
        TvWatchlistStatusHasData(false),
      ],
    );
  });
  group('Remove tv watchlist test', () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit Success when remove tv from database successfully',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Right('Remove tv from watchlist'));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => Right(true));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveTvWatchlist(testTvDetail)),
      expect: () => [
        InsertOrRemoveWatchlistSuccess('Remove tv from watchlist'),
        TvWatchlistStatusHasData(true)
      ],
    );
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit failed when remove tv from database unsuccessful',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => Right(false));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveTvWatchlist(testTvDetail)),
      expect: () => [
        InsertOrRemoveWatchlistFailed('Database Failure'),
        TvWatchlistStatusHasData(false),
      ],
    );
  });
}
