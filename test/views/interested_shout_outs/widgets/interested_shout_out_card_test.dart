import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/transactions/karma_vote_actor/karma_vote_actor_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/interested_shout_outs/widgets/button_column.dart';
import 'package:pami/views/interested_shout_outs/widgets/interested_shout_out_card.dart';
import 'package:pami/views/interested_shout_outs/widgets/shout_out_header_image.dart';
import 'package:pami/views/interested_shout_outs/widgets/user_avatar.dart';

import 'interested_shout_out_card_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterestedShoutOutsActorBloc>(),
  MockSpec<KarmaVoteActorBloc>(),
])
void main() {
  late MockInterestedShoutOutsActorBloc actorBloc;
  late MockKarmaVoteActorBloc voteBloc;
  late StreamController<InterestedShoutOutsActorState> actorStream;

  final shoutOut = getValidShoutOut().copyWith(
    creatorUser: some(
      getValidUser().copyWith(
        avatar: Url(''),
      ),
    ),
    imageUrls: {},
  );

  setUpAll(
    () => provideDummy<InterestedShoutOutsActorState>(
      const InterestedShoutOutsActorState.initial(),
    ),
  );

  setUp(
    () {
      actorBloc = MockInterestedShoutOutsActorBloc();
      voteBloc = MockKarmaVoteActorBloc();

      actorStream = StreamController<InterestedShoutOutsActorState>.broadcast();
      when(actorBloc.stream).thenAnswer((_) => actorStream.stream);
      when(actorBloc.state).thenReturn(
        const InterestedShoutOutsActorState.initial(),
      );

      getIt
        ..registerFactory<InterestedShoutOutsActorBloc>(() => actorBloc)
        ..registerFactory<KarmaVoteActorBloc>(() => voteBloc);
    },
  );

  tearDown(
    () async {
      await getIt.reset();
      await actorStream.close();
    },
  );

  Widget buildWidget({required ShoutOut shoutOut}) => MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: InterestedShoutOutCard(shoutOut: shoutOut),
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
      expect(find.byType(ButtonColumn), findsOneWidget);
      expect(find.text(shoutOut.title.getOrCrash()), findsWidgets);
      expect(find.text(shoutOut.description.getOrCrash()), findsWidgets);
      expect(find.byType(UserAvatar), findsOneWidget);
      shoutOut.creatorUser.fold(
        () => fail(
          'Expected creator user to be present in getValidShoutOut()',
        ),
        (user) {
          expect(find.text(user.name.getOrCrash()), findsWidgets);
          expect(find.text(user.username.getOrCrash()), findsWidgets);
        },
      );
    },
  );

  testWidgets(
    'hides avatar and creator texts when creatorUser is none',
    (tester) async {
      // Arrange
      final shoutOutNoUser = shoutOut.copyWith(
        creatorUser: none(),
      );

      // Act
      await tester.pumpWidget(buildWidget(shoutOut: shoutOutNoUser));

      // Assert
      expect(find.byType(ShoutOutHeaderImage), findsOneWidget);
      expect(find.byType(ButtonColumn), findsOneWidget);
      expect(find.byType(UserAvatar), findsNothing);
      expect(find.text(shoutOutNoUser.title.getOrCrash()), findsWidgets);
      expect(find.text(shoutOutNoUser.description.getOrCrash()), findsWidgets);
    },
  );

  testWidgets(
    'rebuilds without throwing when actor state changes',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(shoutOut: shoutOut));
      actorStream.add(
        const InterestedShoutOutsActorState.actionInProgress(),
      );
      await tester.pump();
      actorStream.add(const InterestedShoutOutsActorState.scanSuccess());
      await tester.pump();

      // Assert
      expect(find.byType(InterestedShoutOutCard), findsOneWidget);
      expect(find.byType(ButtonColumn), findsOneWidget);
    },
  );
}
