part of 'tv_list_bloc.dart';

abstract class TvListState extends Equatable {
  const TvListState();

  @override
  List<Object> get props => [];
}

class TvListEmpty extends TvListState {}

class TvListLoading extends TvListState {}

class TvListError extends TvListState {
  final String message;
  TvListError(this.message);

  @override
  List<Object> get props => [message];
}

class TvListHasData extends TvListState {
  final List<TvSeries> onTheAirTvSeries;
  final List<TvSeries> popularTvSeries;
  final List<TvSeries> topRatedTvSeries;

  const TvListHasData(
    this.onTheAirTvSeries,
    this.popularTvSeries,
    this.topRatedTvSeries,
  );

  @override
  List<Object> get props => [
        onTheAirTvSeries,
        popularTvSeries,
        topRatedTvSeries,
      ];
}
