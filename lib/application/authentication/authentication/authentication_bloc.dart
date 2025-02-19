import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/authentication/authentication_repository_interface.dart';
import 'package:pami/domain/core/entities/user.dart';

part 'authentication_bloc.freezed.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

/// Authentication bloc
@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// Default constructor
  AuthenticationBloc(
    this._repository,
  ) : super(const AuthenticationState.initial()) {
    on<AuthenticationEvent>(
      (event, emit) => event.when(
        authenticationCheckRequested: () async {
          final userOption = await _repository.getLoggedInUser();
          emit(
            userOption.fold(
              () => const AuthenticationState.unAuthenticated(),
              AuthenticationState.authenticated,
            ),
          );
          return null;
        },
        loggedOut: () async {
          await _repository.logOut();
          emit(const AuthenticationState.unAuthenticated());
          return null;
        },
      ),
    );
  }

  final AuthenticationRepositoryInterface _repository;
}
