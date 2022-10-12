import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTvEpisodes {
  final TvRepository tvRepository;

  GetTvEpisodes(this.tvRepository);

  Future<Either<Failure, List<Episode>>> execute(int id, int seasonNumber) {
    return tvRepository.getTvShowEpisodes(id, seasonNumber);
  }
}
