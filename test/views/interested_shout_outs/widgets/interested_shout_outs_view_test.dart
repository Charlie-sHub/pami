import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_watcher/interested_shout_outs_watcher_bloc.dart';
import 'package:pami/application/transactions/karma_vote_actor/karma_vote_actor_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/home/widgets/shout_out_card.dart';
import 'package:pami/views/interested_shout_outs/widgets/interested_shout_outs_view.dart';

import 'interested_shout_outs_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterestedShoutOutsWatcherBloc>(),
  MockSpec<InterestedShoutOutsActorBloc>(),
  MockSpec<KarmaVoteActorBloc>(),
])
void main() {
  late MockInterestedShoutOutsWatcherBloc watcherBloc;
  late MockInterestedShoutOutsActorBloc actorBloc;
  late MockKarmaVoteActorBloc voteBloc;
  late StreamController<InterestedShoutOutsWatcherState> watcherStream;

  final shoutOut = getValidShoutOut().copyWith(
    creatorUser: some(
      getValidUser().copyWith(
        avatar: Url(''),
      ),
    ),
    imageUrls: {},
  );

  setUpAll(
    () {
      provideDummy<InterestedShoutOutsWatcherState>(
        const InterestedShoutOutsWatcherState.initial(),
      );
      provideDummy<InterestedShoutOutsActorState>(
        const InterestedShoutOutsActorState.initial(),
      );
      provideDummy<KarmaVoteActorState>(
        const KarmaVoteActorState.initial(),
      );
    },
  );

  setUp(
    () {
      watcherBloc = MockInterestedShoutOutsWatcherBloc();
      actorBloc = MockInterestedShoutOutsActorBloc();
      voteBloc = MockKarmaVoteActorBloc();

      watcherStream =
          StreamController<InterestedShoutOutsWatcherState>.broadcast();

      when(watcherBloc.stream).thenAnswer((_) => watcherStream.stream);
      when(watcherBloc.state).thenReturn(
        const InterestedShoutOutsWatcherState.initial(),
      );
      when(
        watcherBloc.add(
          const InterestedShoutOutsWatcherEvent.watchStarted(),
        ),
      ).thenReturn(null);

      when(actorBloc.stream).thenAnswer(
        (_) => const Stream<InterestedShoutOutsActorState>.empty(),
      );
      when(actorBloc.state).thenReturn(
        const InterestedShoutOutsActorState.initial(),
      );
      when(voteBloc.stream).thenAnswer(
        (_) => const Stream<KarmaVoteActorState>.empty(),
      );
      when(voteBloc.state).thenReturn(const KarmaVoteActorState.initial());

      getIt
        ..registerFactory<InterestedShoutOutsWatcherBloc>(() => watcherBloc)
        ..registerFactory<InterestedShoutOutsActorBloc>(() => actorBloc)
        ..registerFactory<KarmaVoteActorBloc>(() => voteBloc);
    },
  );

  tearDown(
    () async {
      await getIt.reset();
      await watcherStream.close();
    },
  );

  Widget buildWidget() => const MaterialApp(
    home: Scaffold(
      body: InterestedShoutOutsView(),
    ),
  );

  testWidgets(
    'shows loader on initial and actionInProgress',
    (tester) async {
      // Act & Assert
      await tester.pumpWidget(buildWidget());
      watcherStream.add(const InterestedShoutOutsWatcherState.initial());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      watcherStream.add(
        const InterestedShoutOutsWatcherState.actionInProgress(),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(
        watcherBloc.add(
          const InterestedShoutOutsWatcherEvent.watchStarted(),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'shows empty message when LoadSuccess with no items',
    (tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget());

      // Act
      watcherStream.add(
        const InterestedShoutOutsWatcherState.loadSuccess(<ShoutOut>[]),
      );
      await tester.pump();

      // Assert
      expect(find.text('No interested shout-outs yet.'), findsOneWidget);
      expect(find.byType(ShoutOutCard), findsNothing);
    },
  );

  testWidgets(
    'renders a list of cards when LoadSuccess has items',
    (tester) async {
      // Arrange
      final shoutOuts = [shoutOut];
      await tester.pumpWidget(buildWidget());

      // Act
      watcherStream.add(
        InterestedShoutOutsWatcherState.loadSuccess(shoutOuts),
      );
      await tester.pump();

      // Assert
      expect(
        find.byType(ShoutOutCard),
        findsNWidgets(shoutOuts.length),
      );
    },
  );

  testWidgets(
    'shows error text on LoadFailure',
    (tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget());

      // Act
      watcherStream.add(
        const InterestedShoutOutsWatcherState.loadFailure(
          Failure.serverError(errorString: 'error'),
        ),
      );
      await tester.pump();

      // Assert
      expect(
        find.textContaining('Error loading shout-outs'),
        findsOneWidget,
      );
    },
  );
}
