import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/transactions/karma_vote_actor/karma_vote_actor_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/views/interested_shout_outs/widgets/button_column.dart';
import 'package:pami/views/interested_shout_outs/widgets/creator_actions_row.dart';
import 'package:pami/views/interested_shout_outs/widgets/user_avatar.dart';

import 'creator_actions_row_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterestedShoutOutsActorBloc>(),
  MockSpec<KarmaVoteActorBloc>(),
])
void main() {
  late MockInterestedShoutOutsActorBloc interestedActorBloc;
  late MockKarmaVoteActorBloc voteBloc;
  late StreamController<InterestedShoutOutsActorState> interestedActorStream;

  final shoutWithCreator = getValidShoutOut().copyWith(
    creatorUser: some(
      getValidUser().copyWith(
        avatar: Url(''),
      ),
    ),
  );
  final shoutWithoutCreator = shoutWithCreator.copyWith(
    creatorUser: none(),
  );

  setUpAll(
    () {
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
      interestedActorBloc = MockInterestedShoutOutsActorBloc();
      voteBloc = MockKarmaVoteActorBloc();

      interestedActorStream =
          StreamController<InterestedShoutOutsActorState>.broadcast();
      when(
        interestedActorBloc.stream,
      ).thenAnswer((_) => interestedActorStream.stream);
      when(
        interestedActorBloc.state,
      ).thenReturn(const InterestedShoutOutsActorState.initial());

      when(
        voteBloc.stream,
      ).thenAnswer((_) => const Stream<KarmaVoteActorState>.empty());
      when(voteBloc.state).thenReturn(const KarmaVoteActorState.initial());
    },
  );

  tearDown(
    () async => interestedActorStream.close(),
  );

  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<InterestedShoutOutsActorBloc>.value(
            value: interestedActorBloc,
          ),
          BlocProvider<KarmaVoteActorBloc>.value(
            value: voteBloc,
          ),
        ],
        child: child,
      ),
    ),
  );

  testWidgets(
    'shows avatar, name, username, and ButtonColumn when creator present',
    (tester) async {
      // Arrange
      await tester.pumpWidget(
        wrap(CreatorActionsRow(shoutOut: shoutWithCreator)),
      ); // Act

      // Assert
      expect(find.byType(UserAvatar), findsOneWidget);
      expect(find.byType(ButtonColumn), findsOneWidget);

      shoutWithCreator.creatorUser.fold(
        () => fail('Expected creator to be present in shoutWithCreator'),
        (user) {
          expect(find.text(user.name.getOrCrash()), findsWidgets);
          expect(find.text(user.username.getOrCrash()), findsWidgets);
        },
      );
    },
  );

  testWidgets(
    'hides avatar/name/username when no creator, but still shows ButtonColumn',
    (tester) async {
      // Arrange
      await tester.pumpWidget(
        wrap(CreatorActionsRow(shoutOut: shoutWithoutCreator)),
      ); // Act

      // Assert
      expect(find.byType(UserAvatar), findsNothing);
      expect(find.byType(ButtonColumn), findsOneWidget);
    },
  );

  testWidgets(
    'rebuilds safely when actor state changes',
    (tester) async {
      // Arrange
      await tester.pumpWidget(
        wrap(CreatorActionsRow(shoutOut: shoutWithCreator)),
      );

      // Act
      interestedActorStream.add(
        const InterestedShoutOutsActorState.actionInProgress(),
      );
      await tester.pump();
      interestedActorStream.add(
        const InterestedShoutOutsActorState.scanSuccess(),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CreatorActionsRow), findsOneWidget);
      expect(find.byType(ButtonColumn), findsOneWidget);
    },
  );
}
