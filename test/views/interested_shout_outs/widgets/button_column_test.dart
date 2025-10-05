import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/transactions/karma_vote_actor/karma_vote_actor_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/views/interested_shout_outs/widgets/button_column.dart';

import 'button_column_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterestedShoutOutsActorBloc>(),
  MockSpec<KarmaVoteActorBloc>(),
  MockSpec<StackRouter>(),
])
void main() {
  late MockInterestedShoutOutsActorBloc actorBloc;
  late MockKarmaVoteActorBloc voteBloc;
  late MockStackRouter router;
  late StreamController<InterestedShoutOutsActorState> actorStream;
  final shoutOut = getValidShoutOut();

  setUpAll(
    () => provideDummy<InterestedShoutOutsActorState>(
      const InterestedShoutOutsActorState.initial(),
    ),
  );

  setUp(
    () {
      actorBloc = MockInterestedShoutOutsActorBloc();
      voteBloc = MockKarmaVoteActorBloc();
      router = MockStackRouter();

      actorStream = StreamController<InterestedShoutOutsActorState>.broadcast();

      when(actorBloc.stream).thenAnswer((_) => actorStream.stream);
      when(actorBloc.state).thenReturn(
        const InterestedShoutOutsActorState.initial(),
      );

      when(router.push(any)).thenAnswer((_) async => null);
    },
  );

  tearDown(
    () async => actorStream.close(),
  );

  Widget buildWidget() => MaterialApp(
    home: StackRouterScope(
      controller: router,
      stateHash: 0,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InterestedShoutOutsActorBloc>.value(value: actorBloc),
          BlocProvider<KarmaVoteActorBloc>.value(value: voteBloc),
        ],
        child: Scaffold(
          body: Row(
            children: [
              ButtonColumn(shoutOut: shoutOut),
            ],
          ),
        ),
      ),
    ),
  );

  testWidgets(
    'renders Chat & Scan by default (non-scan state)',
    (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Assert
      expect(find.text('Go to chat'), findsOneWidget);
      expect(find.text('Scan QR'), findsOneWidget);
      expect(find.byIcon(Icons.thumb_up_alt_rounded), findsNothing);
      expect(find.byIcon(Icons.thumb_down_alt_rounded), findsNothing);
    },
  );

  testWidgets(
    'shows voting thumbs when state is ScanSuccess',
    (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(buildWidget());
      actorStream.add(
        const InterestedShoutOutsActorState.actionInProgress(),
      );
      await tester.pump();
      actorStream.add(const InterestedShoutOutsActorState.scanSuccess());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));

      // Assert
      expect(find.byIcon(Icons.thumb_up_alt_rounded), findsOneWidget);
      expect(find.byIcon(Icons.thumb_down_alt_rounded), findsOneWidget);
      expect(find.text('Go to chat'), findsNothing);
      expect(find.text('Scan QR'), findsNothing);
    },
  );

  testWidgets(
    'tapping thumbs dispatches voteSubmitted with correct polarity',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget());
      actorStream.add(const InterestedShoutOutsActorState.scanSuccess());
      await tester.pump();
      await tester.tap(find.byIcon(Icons.thumb_up_alt_rounded));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.thumb_down_alt_rounded));
      await tester.pump();

      // Assert
      verify(
        voteBloc.add(
          argThat(
            isA<KarmaVoteActorEvent>().having(
              (event) => event.mapOrNull(
                voteSubmitted: (vote) => vote.isPositive,
              ),
              'isPositive for upvote',
              true,
            ),
          ),
        ),
      ).called(1);

      verify(
        voteBloc.add(
          argThat(
            isA<KarmaVoteActorEvent>().having(
              (event) => event.mapOrNull(
                voteSubmitted: (vote) => vote.isPositive,
              ),
              'isPositive for downvote',
              false,
            ),
          ),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'scan button pushes ScanRoute and then dispatches scanCompleted',
    (tester) async {
      // Arrange
      when(router.push(any)).thenAnswer((_) async => 'payload-123');

      await tester.pumpWidget(buildWidget());

      // Act
      await tester.tap(find.text('Scan QR'));
      await tester.pumpAndSettle();

      // Assert
      verify(router.push(any)).called(1);
      verify(
        actorBloc.add(
          argThat(
            isA<InterestedShoutOutsActorEvent>().having(
              (event) => event.mapOrNull(scanCompleted: (scan) => scan.payload),
              'payload',
              'payload-123',
            ),
          ),
        ),
      ).called(1);
    },
  );
}
