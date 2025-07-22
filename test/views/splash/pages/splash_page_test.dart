import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/authentication/authentication/authentication_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/views/core/routes/router.gr.dart';
import 'package:pami/views/splash/pages/splash_page.dart';
import 'package:pami/views/splash/widgets/pami_loading_animation.dart';

import 'splash_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationBloc>(),
  MockSpec<StackRouter>(),
])
void main() {
  late MockAuthenticationBloc mockBloc;
  late MockStackRouter mockRouter;
  late StreamController<AuthenticationState> streamController;

  setUp(
    () {
      mockBloc = MockAuthenticationBloc();
      mockRouter = MockStackRouter();
      streamController = StreamController<AuthenticationState>.broadcast();
      provideDummy<AuthenticationState>(const AuthenticationState.initial());
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
    },
  );

  tearDown(
    () async {
      await streamController.close();
      await mockBloc.close();
    },
  );

  Widget buildWidget() => MaterialApp(
        builder: (context, child) => StackRouterScope(
          controller: mockRouter,
          stateHash: 0,
          child: BlocProvider<AuthenticationBloc>.value(
            value: mockBloc,
            child: const SplashPage(),
          ),
        ),
      );

  testWidgets(
    'displays PamiLoadingAnimation',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());

      // Assert
      expect(find.byType(PamiLoadingAnimation), findsOneWidget);
    },
  );

  group(
    'Navigation tests',
    () {
      testWidgets(
        'navigates to HomeRoute when authenticated',
        (tester) async {
          // Arrange
          final expectedState = AuthenticationState.authenticated(
            getValidUser(),
          );

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(expectedState);
          await tester.pump();

          // Assert
          verify(
            mockRouter.replace(const HomeRoute()),
          ).called(1);
        },
      );

      testWidgets(
        'navigates to LoginRoute when unauthenticated',
        (tester) async {
          // Arrange
          const expectedState = AuthenticationState.unAuthenticated();

          // Act
          await tester.pumpWidget(buildWidget());
          streamController.add(expectedState);
          await tester.pump();

          // Assert
          verify(
            mockRouter.replace(const LoginRoute()),
          ).called(1);
        },
      );
    },
  );
}
