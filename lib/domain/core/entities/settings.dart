import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

/// Settings entity
/// We don't have a good idea of what the settings should be
/// this entity is basically a placeholder
@freezed
class Settings with _$Settings {
  const Settings._();

  /// Default constructor
  const factory Settings({
    // Placeholder setting
    required bool notificationsEnabled,
  }) = _Settings;

  /// Empty constructor
  factory Settings.empty() => const Settings(
        notificationsEnabled: true,
      );
}
