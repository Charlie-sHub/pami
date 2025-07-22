import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/views/map/widgets/shout_out_modal_button_row.dart';

import 'shout_out_modal_button_row_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterestedShoutOutsActorBloc>(),
  MockSpec<StackRouter>(),
])
void main() {
  late MockInterestedShoutOutsActorBloc mockInterestedShoutOutsActorBloc;
  late MockStackRouter mockRouter;
  late UniqueId testShoutOutId;

  setUp(
    () {
      mockInterestedShoutOutsActorBloc = MockInterestedShoutOutsActorBloc();
      mockRouter = MockStackRouter();
      testShoutOutId = UniqueId.fromUniqueString('test-id');
      provideDummy<InterestedShoutOutsActorState>(
        const InterestedShoutOutsActorState.initial(),
      );
    },
  );

  Widget buildWidget({UniqueId? shoutOutId}) => MaterialApp(
    home: StackRouterScope(
      controller: mockRouter,
      stateHash: 0,
      child: BlocProvider<InterestedShoutOutsActorBloc>.value(
        value: mockInterestedShoutOutsActorBloc,
        child: Scaffold(
          body: ShoutOutModalButtonRow(
            shoutOutId: shoutOutId ?? testShoutOutId,
          ),
        ),
      ),
    ),
  );

  group(
    'ShoutOutModalButtonRow UI and Initial State',
    () {
      testWidgets(
        'renders "Not Interested" and "Add to Interested" buttons by default',
        (tester) async {
          // Arrange
          when(mockInterestedShoutOutsActorBloc.state).thenReturn(
            const InterestedShoutOutsActorState.initial(),
          );
          when(mockInterestedShoutOutsActorBloc.stream).thenAnswer(
            (_) => Stream.value(
              const InterestedShoutOutsActorState.initial(),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());

          // Assert
          expect(
            find.widgetWithText(TextButton, 'Not Interested'),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(ElevatedButton, 'Add to Interested'),
            findsOneWidget,
          );
          expect(find.byType(CircularProgressIndicator), findsNothing);
        },
      );

      testWidgets(
        'renders CircularProgressIndicator when state is ActionInProgress',
        (tester) async {
          // Arrange
          when(mockInterestedShoutOutsActorBloc.state).thenReturn(
            const InterestedShoutOutsActorState.actionInProgress(),
          );
          when(mockInterestedShoutOutsActorBloc.stream).thenAnswer(
            (_) => Stream.value(
              const InterestedShoutOutsActorState.actionInProgress(),
            ),
          );

          // Act
          await tester.pumpWidget(buildWidget());

          // Assert
          expect(
            find.widgetWithText(TextButton, 'Not Interested'),
            findsOneWidget,
          );
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(
            find.widgetWithText(ElevatedButton, 'Add to Interested'),
            findsNothing,
          );
        },
      );
    },
  );

  group(
    'ShoutOutModalButtonRow Interactions',
    () {
      testWidgets(
        '"Not Interested" button pops the router',
        (tester) async {
          // Arrange
          when(mockRouter.pop()).thenAnswer((_) async => true);

          // Act
          await tester.pumpWidget(buildWidget());
          await tester.tap(find.widgetWithText(TextButton, 'Not Interested'));

          // Assert
          verify(mockRouter.pop()).called(1);
        },
      );

      testWidgets(
        '"Add to Interested" button adds event to BLoC',
        (tester) async {
          // Act
          await tester.pumpWidget(buildWidget(shoutOutId: testShoutOutId));
          await tester.tap(
            find.widgetWithText(ElevatedButton, 'Add to Interested'),
          );

          // Assert
          verify(
            mockInterestedShoutOutsActorBloc.add(
              InterestedShoutOutsActorEvent.addToInterested(
                shoutOutId: testShoutOutId,
              ),
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'ShoutOutModalButtonRow BLoC Listener Logic',
    () {
      testWidgets(
        'listener calls router.pop() on AdditionSuccess',
        (tester) async {
          // Arrange
          final controller =
              StreamController<InterestedShoutOutsActorState>.broadcast();
          when(mockInterestedShoutOutsActorBloc.state).thenReturn(
            const InterestedShoutOutsActorState.initial(),
          );
          when(mockInterestedShoutOutsActorBloc.stream).thenAnswer(
            (_) => controller.stream,
          );
          when(mockRouter.pop()).thenAnswer((_) async => true);

          // Act
          await tester.pumpWidget(buildWidget());
          controller.add(const InterestedShoutOutsActorState.additionSuccess());
          await tester.pump();

          // Assert
          verify(mockRouter.pop()).called(1);
          await controller.close();
        },
      );

      testWidgets(
        'listener handles AdditionFailure correctly (e.g., does not pop)',
        (tester) async {
          // Arrange
          final controller =
              StreamController<InterestedShoutOutsActorState>.broadcast();
          const testFailure = Failure.unexpectedError(
            errorMessage: 'Test error',
          );
          when(mockInterestedShoutOutsActorBloc.state).thenReturn(
            const InterestedShoutOutsActorState.initial(),
          );
          when(mockInterestedShoutOutsActorBloc.stream).thenAnswer(
            (_) => controller.stream,
          );

          // Act
          await tester.pumpWidget(buildWidget());
          controller.add(
            const InterestedShoutOutsActorState.additionFailure(
              testFailure,
            ),
          );

          // Assert
          verifyNever(mockRouter.pop());
          await controller.close();
        },
      );
    },
  );
}
