import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/entities/settings.dart';

part 'settings_dto.freezed.dart';
part 'settings_dto.g.dart';

/// Settings DTO
@freezed
abstract class SettingsDto with _$SettingsDto {
  const SettingsDto._();

  /// Default constructor
  const factory SettingsDto({
    required bool notificationsEnabled,
  }) = _SettingsDto;

  /// Constructor from [Settings]
  factory SettingsDto.fromDomain(Settings settings) => SettingsDto(
        notificationsEnabled: settings.notificationsEnabled,
      );

  /// Factory constructor from JSON [Map]
  factory SettingsDto.fromJson(Map<String, dynamic> json) =>
      _$SettingsDtoFromJson(json);

  /// Returns a [Settings] from this DTO
  Settings toDomain() => Settings(
        notificationsEnabled: notificationsEnabled,
      );
}
