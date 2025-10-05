import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/views/interested_shout_outs/widgets/shout_out_header_image.dart';

import 'shout_out_header_image_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterestedShoutOutsActorBloc>(),
])
void main() {
  late MockInterestedShoutOutsActorBloc actorBloc;
  late StreamController<InterestedShoutOutsActorState> actorStream;

  final id = UniqueId();

  setUpAll(
    () {
      provideDummy<InterestedShoutOutsActorState>(
        const InterestedShoutOutsActorState.initial(),
      );
    },
  );

  setUp(
    () {
      actorBloc = MockInterestedShoutOutsActorBloc();
      actorStream = StreamController<InterestedShoutOutsActorState>.broadcast();

      when(actorBloc.stream).thenAnswer((_) => actorStream.stream);
      when(actorBloc.state).thenReturn(
        const InterestedShoutOutsActorState.initial(),
      );
      when(actorBloc.add(any)).thenReturn(null);
    },
  );

  tearDown(
    () async => actorStream.close(),
  );

  Widget buildWidget({required UniqueId id}) => MaterialApp(
    home: Scaffold(
      body: BlocProvider<InterestedShoutOutsActorBloc>.value(
        value: actorBloc,
        child: ShoutOutHeaderImage(
          imageUrls: const [],
          id: id,
        ),
      ),
    ),
  );

  group(
    'ShoutOutHeaderImage',
    () {
      testWidgets(
        'renders placeholder (no images) and close button',
        (
          tester,
        ) async {
          // Act & Assert
          await tester.pumpWidget(buildWidget(id: id));
          expect(find.byType(AspectRatio), findsOneWidget);
          expect(find.byType(Stack), findsWidgets);
          expect(
            find.byType(CarouselSlider),
            findsNothing,
          );
          expect(find.byIcon(Icons.close), findsOneWidget);
        },
      );

      testWidgets(
        'tapping close dispatches addToInterested with id',
        (
          tester,
        ) async {
          // Act
          await tester.pumpWidget(buildWidget(id: id));
          await tester.tap(find.byIcon(Icons.close));
          await tester.pump();

          // Assert
          verify(
            actorBloc.add(
              InterestedShoutOutsActorEvent.addToInterested(shoutOutId: id),
            ),
          ).called(1);
        },
      );
    },
  );
}
