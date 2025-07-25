import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/profile/profile_repository_interface.dart';

part 'profile_watcher_bloc.freezed.dart';

part 'profile_watcher_event.dart';

part 'profile_watcher_state.dart';

/// Profile outs watcher bloc
@injectable
class ProfileWatcherBloc
    extends Bloc<ProfileWatcherEvent, ProfileWatcherState> {
  /// Default constructor
  ProfileWatcherBloc(
    this._repository,
  ) : super(const ProfileWatcherState.initial()) {
    on<_FetchProfile>(_onFetchProfile);
  }

  final ProfileRepositoryInterface _repository;

  Future<void> _onFetchProfile(_, Emitter emit) async {
    emit(const ProfileWatcherState.loadInProgress());
    final result = await _repository.getCurrentUser();
    emit(
      result.fold(
        ProfileWatcherState.loadFailure,
        ProfileWatcherState.loadSuccess,
      ),
    );
  }
}
