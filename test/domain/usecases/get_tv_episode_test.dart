import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/usecases/get_tv_episodes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetTvEpisodes getTvEpisodes;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getTvEpisodes = GetTvEpisodes(mockTvRepository);
  });

  const tId = 1;
  const tSeasonNumber = 1;
  final tEpisodes = <Episode>[];

  test('should get list of episodes', () async {
    when(mockTvRepository.getTvShowEpisodes(tId, tSeasonNumber))
        .thenAnswer((_) async => Right(tEpisodes));
    final result = await getTvEpisodes.execute(tId, tSeasonNumber);
    expect(result, Right(tEpisodes));
  });
}
