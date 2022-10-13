import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchlistTvStatus getWatchlistTvStatus;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvWatchlistBloc({
    required this.getWatchlistTvStatus,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(TvWatchlistStatusEmpty()) {
    on<LoadTvWatchlistStatus>((event, emit) async {
      final id = event.id;
      final result = await getWatchlistTvStatus.execute(id);

      result.fold(
        (failure) => emit(TvWatchlistStatusError(failure.message)),
        (isWatchlist) => emit(
          TvWatchlistStatusHasData(isWatchlist),
        ),
      );
    });
    on<InsertTvWatchlist>((event, emit) async {
      final tv = event.tvDetail;
      final result = await saveWatchlistTv.execute(tv);

      result.fold((failure) {
        emit(InsertOrRemoveWatchlistFailed(failure.message));
      }, (data) {
        emit(InsertOrRemoveWatchlistSuccess(data));
      });
      add(LoadTvWatchlistStatus(tv.id));
    });
    on<RemoveTvWatchlist>(
      (event, emit) async {
        final tv = event.tvDetail;
        final result = await removeWatchlistTv.execute(tv);

        result.fold((failure) {
          emit(InsertOrRemoveWatchlistFailed(failure.message));
        }, (data) {
          emit(InsertOrRemoveWatchlistSuccess(data));
        });
        add(LoadTvWatchlistStatus(tv.id));
      },
    );
  }
}
