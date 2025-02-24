import 'package:flutter_test/flutter_test.dart';
import 'package:pami/data/core/misc/server_date_string_converter.dart';

void main() {
  const converter = ServerDateStringConverter();
  final dateTime = DateTime.now();
  final iso8601String = dateTime.toIso8601String();

  group(
    'Testing on success',
    () {
      test(
        'fromJson should convert a valid ISO 8601 string to a DateTime',
        () {
          // Act
          final result = converter.fromJson(iso8601String);
          // Assert
          expect(result, equals(dateTime));
        },
      );

      test(
        'toJson should convert a DateTime to an ISO 8601 string',
        () {
          // Act
          final result = converter.toJson(dateTime);
          // Assert
          expect(result, equals(iso8601String));
        },
      );
    },
  );

  group(
    'Testing on failure',
    () {
      test(
        'fromJson should throw a FormatException for an invalid string',
        () {
          // Assert
          expect(
            () => converter.fromJson('invalid-date'),
            throwsFormatException,
          );
        },
      );
    },
  );
}
