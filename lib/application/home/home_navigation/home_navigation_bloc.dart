import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_navigation_bloc.freezed.dart';
part 'home_navigation_event.dart';
part 'home_navigation_state.dart';

/// Home navigation bloc
@injectable
class HomeNavigationBloc
    extends Bloc<HomeNavigationEvent, HomeNavigationState> {
  /// Default constructor
  HomeNavigationBloc() : super(const HomeNavigationState()) {
    on<HomeNavigationEvent>(
      (event, emit) => event.when(
        tabSelected: (index) {
          var newIndex = index;
          if (newIndex < 0 || newIndex > 4) {
            newIndex = 0;
          }
          emit(
            state.copyWith(currentIndex: newIndex),
          );
          return null;
        },
      ),
    );
  }
}
