import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/shout_out_management/shout_out_deletion_actor/shout_out_deletion_actor_bloc.dart';
import 'package:pami/application/transactions/karma_vote_actor/karma_vote_actor_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/views/home/widgets/shout_out_card.dart';
import 'package:pami/views/home/widgets/shout_out_header_image.dart';
import 'package:pami/views/interested_shout_outs/widgets/button_column.dart';
import 'package:pami/views/interested_shout_outs/widgets/creator_actions_row.dart';
import 'package:pami/views/interested_shout_outs/widgets/user_avatar.dart';
import 'package:pami/views/my_shout_outs/widgets/qr_expandable.dart';

import 'shout_out_card_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterestedShoutOutsActorBloc>(),
  MockSpec<ShoutOutDeletionActorBloc>(),
  MockSpec<KarmaVoteActorBloc>(),
])
void main() {
  late MockInterestedShoutOutsActorBloc interestedActorBloc;
  late MockShoutOutDeletionActorBloc deletionActorBloc;
  late MockKarmaVoteActorBloc voteBloc;
  late StreamController<InterestedShoutOutsActorState> interestedActorStream;

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
      provideDummy<InterestedShoutOutsActorState>(
        const InterestedShoutOutsActorState.initial(),
      );
      provideDummy<ShoutOutDeletionActorState>(
        const ShoutOutDeletionActorState.initial(),
      );
      provideDummy<KarmaVoteActorState>(
        const KarmaVoteActorState.initial(),
      );
    },
  );

  setUp(
    () {
      interestedActorBloc = MockInterestedShoutOutsActorBloc();
      deletionActorBloc = MockShoutOutDeletionActorBloc();
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
        deletionActorBloc.stream,
      ).thenAnswer((_) => const Stream<ShoutOutDeletionActorState>.empty());
      when(
        deletionActorBloc.state,
      ).thenReturn(const ShoutOutDeletionActorState.initial());

      when(
        voteBloc.stream,
      ).thenAnswer((_) => const Stream<KarmaVoteActorState>.empty());
      when(voteBloc.state).thenReturn(const KarmaVoteActorState.initial());
    },
  );

  tearDown(
    () async {
      await interestedActorStream.close();
    },
  );

  Widget buildWidget({required ShoutOut shoutOut}) => MaterialApp(
    home: Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<InterestedShoutOutsActorBloc>.value(
            value: interestedActorBloc,
          ),
          BlocProvider<ShoutOutDeletionActorBloc>.value(
            value: deletionActorBloc,
          ),
          BlocProvider<KarmaVoteActorBloc>.value(
            value: voteBloc,
          ),
        ],
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ShoutOutCard(shoutOut: shoutOut),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets(
    'renders header image, text, avatar and button column when user present',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(shoutOut: shoutOut));

      // Assert
      expect(find.byType(ShoutOutHeaderImage), findsOneWidget);
      expect(find.byType(CreatorActionsRow), findsOneWidget);
      expect(find.byType(ButtonColumn), findsOneWidget);
      expect(find.text(shoutOut.title.getOrCrash()), findsWidgets);
      expect(find.text(shoutOut.description.getOrCrash()), findsWidgets);
      expect(find.byType(UserAvatar), findsOneWidget);
      shoutOut.creatorUser.fold(
        () => fail('Expected creator user to be present in getValidShoutOut()'),
        (user) {
          expect(find.text(user.name.getOrCrash()), findsWidgets);
          expect(find.text(user.username.getOrCrash()), findsWidgets);
        },
      );
      expect(find.byType(QrExpandable), findsNothing);
    },
  );

  testWidgets(
    'shows QR expandable and hides interested controls '
    'when creatorUser is none',
    (tester) async {
      // Arrange
      final shoutOutNoUser = shoutOut.copyWith(creatorUser: none());

      // Act
      await tester.pumpWidget(buildWidget(shoutOut: shoutOutNoUser));

      // Assert
      expect(find.byType(ShoutOutHeaderImage), findsOneWidget);
      expect(find.byType(QrExpandable), findsOneWidget);
      expect(find.byType(CreatorActionsRow), findsNothing);
      expect(find.byType(ButtonColumn), findsNothing);
      expect(find.byType(UserAvatar), findsNothing);
      expect(find.text(shoutOutNoUser.title.getOrCrash()), findsWidgets);
      expect(find.text(shoutOutNoUser.description.getOrCrash()), findsWidgets);
    },
  );

  testWidgets(
    'rebuilds without throwing when interested actor state changes',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(shoutOut: shoutOut));
      interestedActorStream.add(
        const InterestedShoutOutsActorState.actionInProgress(),
      );
      await tester.pump();
      interestedActorStream.add(
        const InterestedShoutOutsActorState.scanSuccess(),
      );
      await tester.pump();

      // Assert
      expect(find.byType(ShoutOutCard), findsOneWidget);
      expect(find.byType(ButtonColumn), findsOneWidget);
    },
  );

  testWidgets(
    'dismiss taps route to correct bloc: interested => '
    'InterestedShoutOutsActorBloc',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(shoutOut: shoutOut));
      final closeFinder = find.byIcon(Icons.close);
      expect(closeFinder, findsOneWidget);
      await tester.tap(closeFinder);
      await tester.pump();

      // Assert
      verify(interestedActorBloc.add(any)).called(1);
      verifyNever(deletionActorBloc.add(any));
    },
  );

  testWidgets(
    'dismiss taps route to correct bloc: my shout-outs => '
    'ShoutOutDeletionActorBloc',
    (tester) async {
      // Arrange
      final shoutOutNoUser = shoutOut.copyWith(creatorUser: none());

      // Act
      await tester.pumpWidget(buildWidget(shoutOut: shoutOutNoUser));
      final closeFinder = find.byIcon(Icons.close);
      expect(closeFinder, findsOneWidget);
      await tester.tap(closeFinder);
      await tester.pump();

      // Assert
      verify(deletionActorBloc.add(any)).called(1);
      verifyNever(interestedActorBloc.add(any));
    },
  );
}
