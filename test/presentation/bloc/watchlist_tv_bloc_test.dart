import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/bloc_tv/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTv mockGetWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    watchlistTvBloc = WatchlistTvBloc(getWatchlistTv: mockGetWatchlistTv);
  });

  test('Initial state should be empty', () {
    expect(watchlistTvBloc.state, WatchlistTvEmpty());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit Loading, HasData when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => Right(<TvSeries>[testWatchlistTv]));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvHasData(<TvSeries>[testWatchlistTv]),
    ],
    verify: (_) => verify(mockGetWatchlistTv.execute()),
  );
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit Loading, HasData when data is gotten unsuccessful',
    build: () {
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvError('Database Failure'),
    ],
    verify: (_) => verify(mockGetWatchlistTv.execute()),
  );
}
