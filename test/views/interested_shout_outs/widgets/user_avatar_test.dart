import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pami/core/dev/dev_helpers.dart';
import 'package:pami/domain/core/entities/user.dart';
import 'package:pami/domain/core/validation/objects/name.dart';
import 'package:pami/domain/core/validation/objects/url.dart';
import 'package:pami/views/interested_shout_outs/widgets/user_avatar.dart';

void main() {
  final user = getValidUser().copyWith(
    avatar: Url(''),
    name: Name('John Doe'),
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
      await tester.pumpWidget(buildWidget(size: 80, user: user));
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
      await tester.pumpWidget(buildWidget(size: 64, user: userNoName));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    },
  );

  testWidgets(
    'respects size (radius = size/2)',
    (tester) async {
      // Arrange
      const size = 72.0;

      // Act
      await tester.pumpWidget(buildWidget(size: size, user: user));
      await tester.pump();

      // Assert
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, size / 2);
    },
  );
}
