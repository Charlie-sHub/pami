import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/authentication/authentication_bloc.dart';
import 'package:pami/domain/authentication/authentication_repository_interface.dart';
import 'package:pami/domain/core/entities/user.dart';

import '../../../misc/get_valid_user.dart';
import 'authentication_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepositoryInterface>()])
void main() {
  late MockAuthenticationRepositoryInterface mockRepository;
  late AuthenticationBloc authenticationBloc;
  final user = getValidUser();

  setUp(
    () {
      mockRepository = MockAuthenticationRepositoryInterface();
      authenticationBloc = AuthenticationBloc(mockRepository);
    },
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [UnAuthenticated] when event AuthenticationCheckRequested '
    'is added and repository returns none',
    setUp: () {
      when(mockRepository.getLoggedInUser()).thenAnswer(
        (_) async => none<User>(),
      );
    },
    build: () => authenticationBloc,
    act: (bloc) => bloc.add(
      const AuthenticationEvent.authenticationCheckRequested(),
    ),
    verify: (_) => mockRepository.getLoggedInUser(),
    expect: () => const [AuthenticationState.unAuthenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [Authenticated] when event AuthenticationCheckRequested '
    'is added and repository returns some',
    setUp: () {
      when(mockRepository.getLoggedInUser()).thenAnswer(
        (_) async => some(user),
      );
    },
    build: () => authenticationBloc,
    act: (bloc) => bloc.add(
      const AuthenticationEvent.authenticationCheckRequested(),
    ),
    verify: (_) => mockRepository.getLoggedInUser(),
    expect: () => [AuthenticationState.authenticated(user)],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [UnAuthenticated] when event LoggedOut is added',
    setUp: () {
      when(mockRepository.logOut()).thenAnswer(
        (_) => Future.value(),
      );
    },
    build: () => authenticationBloc,
    act: (bloc) => bloc.add(
      const AuthenticationEvent.loggedOut(),
    ),
    verify: (_) => mockRepository.logOut(),
    expect: () => const [AuthenticationState.unAuthenticated()],
  );
}
