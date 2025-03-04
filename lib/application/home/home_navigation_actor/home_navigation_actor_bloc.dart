import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_navigation_actor_bloc.freezed.dart';
part 'home_navigation_actor_event.dart';
part 'home_navigation_actor_state.dart';

/// Home navigation bloc
@injectable
class HomeNavigationActorBloc
    extends Bloc<HomeNavigationActorEvent, HomeNavigationActorState> {
  /// Default constructor
  HomeNavigationActorBloc() : super(const HomeNavigationActorState()) {
    on<HomeNavigationActorEvent>(
      (event, emit) => switch (event) {
        _TabSelected(:final index) => _handleTabSelected(index, emit),
      },
    );
  }

  void _handleTabSelected(int index, Emitter emit) {
    var newIndex = index;
    if (newIndex < 0 || newIndex > 4) {
      newIndex = 0;
    }
    emit(
      state.copyWith(currentIndex: newIndex),
    );
  }
}
