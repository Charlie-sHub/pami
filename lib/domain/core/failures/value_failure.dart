import 'package:freezed_annotation/freezed_annotation.dart';

import 'failure.dart';

part 'value_failure.freezed.dart';

/// Represents validation failures tied to a specific value type.
@freezed
sealed class ValueFailure<T> extends Failure with _$ValueFailure<T> {
  const ValueFailure._();

  const factory ValueFailure.invalidDate({
    required DateTime failedValue,
  }) = InvalidDate<T>;

  const factory ValueFailure.invalidEmail({
    required String failedValue,
  }) = InvalidEmail<T>;

  const factory ValueFailure.invalidPassword({
    required String failedValue,
  }) = InvalidPassword<T>;

  const factory ValueFailure.invalidName({
    required String failedValue,
  }) = InvalidName<T>;

  const factory ValueFailure.emptyString({
    required String failedValue,
  }) = EmptyString<T>;

  const factory ValueFailure.multiLineString({
    required String failedValue,
  }) = MultiLineString<T>;

  const factory ValueFailure.stringMismatch({
    required String failedValue,
  }) = StringMismatch<T>;

  const factory ValueFailure.doubleOutOfBounds({
    required double failedValue,
  }) = DoubleOutOfBounds<T>;

  const factory ValueFailure.intOutOfBounds({
    required int failedValue,
  }) = IntegerOutOfBounds<T>;

  const factory ValueFailure.invalidCoordinate({
    required double failedValue,
  }) = InvalidCoordinates<T>;

  const factory ValueFailure.emptySet({
    required T failedValue,
  }) = EmptySet<T>;

  const factory ValueFailure.emptyList({
    required T failedValue,
  }) = EmptyList<T>;

  const factory ValueFailure.stringExceedsLength({
    required String failedValue,
    required int maxLength,
  }) = StringExceedsLength<T>;

  const factory ValueFailure.collectionExceedsLength({
    required T failedValue,
    required int maxLength,
  }) = CollectionExceedsLength<T>;

  const factory ValueFailure.invalidUrl({
    required String failedValue,
  }) = InvalidUrl<T>;

  const factory ValueFailure.invalidQr({
    required String failedValue,
  }) = InvalidQr<T>;

  const factory ValueFailure.emptyFields() = EmptyFields<T>;

  @override
  String get message => switch (this) {
    InvalidDate(:final failedValue) => 'Invalid date: $failedValue',
    InvalidEmail(:final failedValue) => 'Invalid email: $failedValue',
    InvalidPassword() => 'Invalid password format.',
    InvalidName(:final failedValue) => 'Invalid name: $failedValue',
    EmptyString() => 'This field cannot be empty.',
    MultiLineString() => 'This field must be a single line.',
    StringMismatch(:final failedValue) => 'Invalid format: $failedValue',
    DoubleOutOfBounds(:final failedValue) =>
      'Double value is out of bounds: $failedValue',
    IntegerOutOfBounds(:final failedValue) =>
      'Int value is out of bounds: $failedValue',
    InvalidCoordinates(:final failedValue) =>
      'Invalid coordinate: $failedValue',
    EmptySet() => 'Selection cannot be empty.',
    EmptyList() => 'List cannot be empty.',
    StringExceedsLength(:final maxLength) =>
      'Text exceeds maximum length of $maxLength characters.',
    CollectionExceedsLength(:final maxLength) =>
      'Collection exceeds maximum length of $maxLength items.',
    InvalidUrl(:final failedValue) => 'Invalid URL: $failedValue',
    InvalidQr(:final failedValue) => 'Invalid QR code: $failedValue',
    EmptyFields() => 'Some required fields are empty.',
  };
}
