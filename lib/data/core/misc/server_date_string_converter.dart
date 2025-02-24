import 'package:freezed_annotation/freezed_annotation.dart';

/// Converter for [DateTime] into [String]s and vice versa
class ServerDateStringConverter implements JsonConverter<DateTime, String> {
  /// Default constructor
  const ServerDateStringConverter();

  @override
  DateTime fromJson(String iso8601String) => DateTime.parse(iso8601String);

  @override
  String toJson(DateTime dateTime) => dateTime.toIso8601String();
}
