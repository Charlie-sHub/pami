import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/validation/objects/entity_description.dart';
import 'package:pami/domain/core/validation/objects/minutes.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/views/map/widgets/shout_out_modal.dart';
import 'package:pami/views/map/widgets/shout_out_modal_button_row.dart';
import 'package:pami/views/map/widgets/shout_out_modal_image_slider.dart';

import 'shout_out_modal_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InterestedShoutOutsActorBloc>(),
])
void main() {
  late MockInterestedShoutOutsActorBloc mockInterestedShoutOutsActorBloc;
  late ShoutOut validShoutOut;

  setUpAll(
    () => validShoutOut = getValidShoutOut().copyWith(
      imageUrls: {},
    ),
  );

  setUp(
    () {
      mockInterestedShoutOutsActorBloc = MockInterestedShoutOutsActorBloc();
      provideDummy<InterestedShoutOutsActorState>(
        const InterestedShoutOutsActorState.initial(),
      );
    },
  );

  Widget buildWidget(ShoutOut shoutOut) =>
      BlocProvider<InterestedShoutOutsActorBloc>.value(
        value: mockInterestedShoutOutsActorBloc,
        child: MaterialApp(
          home: Scaffold(
            body: ShoutOutModal(shoutOut: shoutOut),
          ),
        ),
      );

  testWidgets(
    'renders all basic UI elements and text data from ShoutOut',
    (tester) async {
      // Arrange
      final testShoutOut = validShoutOut.copyWith(
        title: Name('Amazing Event From Base'),
        description: EntityDescription('Come join us from base!'),
        duration: Minutes(30),
      );

      // Act
      await tester.pumpWidget(buildWidget(testShoutOut));

      // Assert
      expect(find.text('Amazing Event From Base'), findsOneWidget);
      expect(find.text('Come join us from base!'), findsOneWidget);
      expect(find.text('30 min'), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
      expect(find.byType(ShoutOutModalImageSlider), findsOneWidget);
      expect(find.byType(ShoutOutModalButtonRow), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    },
  );

  testWidgets(
    'passes correct shoutOutId to ShoutOutModalButtonRow',
    (tester) async {
      // Arrange
      final testId = UniqueId.fromUniqueString(
        'unique-shoutout-id-for-button-row',
      );
      final testShoutOut = validShoutOut.copyWith(id: testId);

      // Act
      await tester.pumpWidget(buildWidget(testShoutOut));

      // Assert
      final buttonRow = tester.widget<ShoutOutModalButtonRow>(
        find.byType(ShoutOutModalButtonRow),
      );
      expect(buttonRow.shoutOutId, equals(testId));
    },
  );

  testWidgets(
    'handles ShoutOut with empty image URLs correctly',
    (tester) async {
      // Arrange
      final testShoutOut = validShoutOut.copyWith(
        imageUrls: <Url>{},
      ); // Empty set

      // Act
      await tester.pumpWidget(buildWidget(testShoutOut));

      // Assert
      final imageSlider = tester.widget<ShoutOutModalImageSlider>(
        find.byType(ShoutOutModalImageSlider),
      );
      expect(imageSlider.imageUrls, isEmpty);
      expect(
        find.descendant(
          of: find.byType(ShoutOutModalImageSlider),
          matching: find.byIcon(Icons.image_not_supported),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'TextOverflow.ellipsis is applied to the title',
    (tester) async {
      // Arrange
      const longTitle = 'This is a long title that should overflow';
      final testShoutOut = validShoutOut.copyWith(
        title: Name(longTitle),
      );

      await tester.pumpWidget(buildWidget(testShoutOut));

      // Act
      final titleTextWidget = tester.widget<Text>(find.text(longTitle));

      // Assert
      expect(titleTextWidget.overflow, TextOverflow.ellipsis);
    },
  );
}
