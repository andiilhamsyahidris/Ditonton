import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/presentation/bloc_tv/tv_list_bloc/tv_list_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvListBloc tvListBloc;
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    tvListBloc = TvListBloc(
        getNowPlayingTv: mockGetNowPlayingTv,
        getPopularTvSeries: mockGetPopularTvSeries,
        getTopRatedTvSeries: mockGetTopRatedTvSeries);
  });

  test('Initial state should be empty', () {
    expect(tvListBloc.state, TvListEmpty());
  });

  blocTest<TvListBloc, TvListState>(
    'Should emit Loading, HasData when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchTvList()),
    expect: () => [
      TvListLoading(),
      TvListHasData(testTvList, testTvList, testTvList),
    ],
    verify: (_) {
      verify(mockGetNowPlayingTv.execute());
      verify(mockGetPopularTvSeries.execute());
      verify(mockGetTopRatedTvSeries.execute());
    },
  );
  blocTest<TvListBloc, TvListState>(
    'Should emit Loading, HasData when data is gotten unsuccessful',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchTvList()),
    expect: () => [
      TvListLoading(),
      TvListError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetNowPlayingTv.execute());
      verify(mockGetPopularTvSeries.execute());
      verify(mockGetTopRatedTvSeries.execute());
    },
  );
}
