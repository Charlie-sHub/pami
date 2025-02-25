import 'package:flutter_test/flutter_test.dart';
import 'package:pami/domain/core/entities/settings.dart';

void main() {
  const validSettings = Settings(notificationsEnabled: true);

  group(
    'Testing on success',
    () {
      test(
        'should be valid when all inputs are valid',
        () {
          // Act
          const result = validSettings;

          // Assert
          expect(result.notificationsEnabled, true);
        },
      );
    },
  );
}
