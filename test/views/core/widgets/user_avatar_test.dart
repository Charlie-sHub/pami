import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/validation/objects/karma_percentage.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/views/core/widgets/user_avatar.dart';

void main() {
  const size = 72.0;
  final user = getValidUser().copyWith(
    avatar: Url(''),
    name: Name('John Doe'),
    karma: KarmaPercentage(60),
  );

  Widget buildWidget({
    required double size,
    required User user,
  }) => MaterialApp(
    home: Scaffold(
      body: Center(
        child: UserAvatar(user: user, size: size),
      ),
    ),
  );

  testWidgets(
    'shows initials when avatar url is empty',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(size: size, user: user));
      await tester.pump();

      // Assert
      expect(find.text('JD'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsNothing);
    },
  );

  testWidgets(
    'falls back to person icon when name invalid/empty',
    (tester) async {
      // Arrange
      final userNoName = user.copyWith(name: Name(''));

      // Act
      await tester.pumpWidget(buildWidget(size: size, user: userNoName));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    },
  );

  testWidgets(
    'renders karma ring as CustomPaint',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(size: size, user: user));
      await tester.pump();

      // Assert
      expect(find.byType(CustomPaint), findsWidgets);
    },
  );

  testWidgets(
    'respects size (radius = size/2)',
    (tester) async {
      // Act
      await tester.pumpWidget(buildWidget(size: size, user: user));
      await tester.pump();

      // Assert
      final avatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar).first,
      );
      expect(avatar.radius, size / 2);
    },
  );
}
