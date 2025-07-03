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
    on<_TabSelected>(_onTabSelected);
  }

  void _onTabSelected(_TabSelected event, Emitter emit) {
    var newIndex = event.index;
    if (newIndex < 0 || newIndex > 4) {
      newIndex = 0;
    }
    emit(
      state.copyWith(currentIndex: newIndex),
    );
  }
}
