part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent {
  const TvDetailEvent();
}

class FetchTvDetail extends TvDetailEvent {
  final int id;
  const FetchTvDetail(this.id);
}
