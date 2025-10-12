import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/my_shout_outs/my_shout_outs_watcher/my_shout_outs_watcher_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/home/widgets/shout_out_card.dart';
import 'package:pami/views/my_shout_outs/widgets/my_shout_outs_view.dart';

import 'my_shout_outs_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MyShoutOutsWatcherBloc>(),
])
void main() {
  late MockMyShoutOutsWatcherBloc watcherBloc;
  late StreamController<MyShoutOutsWatcherState> watcherStream;

  setUpAll(
    () {
      provideDummy<MyShoutOutsWatcherState>(
        const MyShoutOutsWatcherState.initial(),
      );
    },
  );

  setUp(
    () async {
      // Arrange
      watcherBloc = MockMyShoutOutsWatcherBloc();
      watcherStream = StreamController<MyShoutOutsWatcherState>.broadcast();

      when(watcherBloc.stream).thenAnswer((_) => watcherStream.stream);
      when(watcherBloc.state).thenReturn(
        const MyShoutOutsWatcherState.initial(),
      );

      if (getIt.isRegistered<MyShoutOutsWatcherBloc>()) {
        await getIt.unregister<MyShoutOutsWatcherBloc>();
      }
      getIt.registerFactory<MyShoutOutsWatcherBloc>(() => watcherBloc);
    },
  );

  tearDown(
    () async {
      await watcherStream.close();
      await getIt.reset();
    },
  );

  Widget build() => const MaterialApp(
    home: Scaffold(
      body: MyShoutOutsView(),
    ),
  );

  testWidgets(
    'shows progress during Initial and ActionInProgress',
    (tester) async {
      // Arrange
      when(watcherBloc.state).thenReturn(
        const MyShoutOutsWatcherState.initial(),
      );

      // Act
      await tester.pumpWidget(build());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      watcherStream.add(const MyShoutOutsWatcherState.actionInProgress());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'shows empty message when LoadSuccess has no shout-outs',
    (tester) async {
      // Arrange
      when(watcherBloc.state).thenReturn(
        const MyShoutOutsWatcherState.actionInProgress(),
      );

      // Act
      await tester.pumpWidget(build());
      watcherStream.add(const MyShoutOutsWatcherState.loadSuccess({}));
      await tester.pump();

      // Assert
      expect(
        find.text('You have not created any shout-outs yet.'),
        findsOneWidget,
      );
      expect(find.byType(ShoutOutCard), findsNothing);
    },
  );

  testWidgets(
    'renders a list of ShoutOutCard when LoadSuccess has data',
    (tester) async {
      // Arrange
      final items = {
        getValidShoutOut().copyWith(creatorUser: none()),
        getValidShoutOut().copyWith(creatorUser: none()),
      };

      when(watcherBloc.state).thenReturn(
        const MyShoutOutsWatcherState.actionInProgress(),
      );

      // Act
      await tester.pumpWidget(build());
      watcherStream.add(MyShoutOutsWatcherState.loadSuccess(items));
      await tester.pump();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ShoutOutCard), findsNWidgets(items.length));
    },
  );

  testWidgets(
    'shows error message on LoadFailure',
    (tester) async {
      // Arrange
      const failure = Failure.serverError(errorString: '');
      when(watcherBloc.state).thenReturn(
        const MyShoutOutsWatcherState.actionInProgress(),
      );

      // Act
      await tester.pumpWidget(build());
      watcherStream.add(const MyShoutOutsWatcherState.loadFailure(failure));
      await tester.pump();

      // Assert
      expect(
        find.textContaining('Error loading your shout-outs'),
        findsOneWidget,
      );
    },
  );
}
