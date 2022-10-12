import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetNowPlayingTv(mockTvRepository);
  });

  final tTvSeries = <TvSeries>[];

  test('should get list of tv series from the repository', () async {
    when(mockTvRepository.getNowPlayingTvSeries())
        .thenAnswer((_) async => Right(tTvSeries));
    final result = await usecase.execute();
    expect(result, Right(tTvSeries));
  });
}
