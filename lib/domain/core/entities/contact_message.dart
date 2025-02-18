import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/misc/enums/contact_message_type.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'contact_message.freezed.dart';

/// Contact Message entity
@freezed
class ContactMessage with _$ContactMessage {
  const ContactMessage._();

  /// Default constructor
  const factory ContactMessage({
    required UniqueId id,
    required UniqueId senderId,
    required ContactMessageType type,
    required MessageContent content,
    required PastDate dateCreated,
  }) = _ContactMessage;

  /// Empty constructor
  factory ContactMessage.empty() => ContactMessage(
        id: UniqueId(),
        senderId: UniqueId.fromUniqueString(''),
        type: ContactMessageType.other,
        content: MessageContent(''),
        dateCreated: PastDate(DateTime.now()),
      );

  /// Gets an [Option] of [Failure] of any of its fields
  Option<Failure<dynamic>> get failureOption => Either.map2(
        content.failureOrUnit,
        dateCreated.failureOrUnit,
        (_, __) => unit,
      ).fold(
        some,
        (_) => none(),
      );

  /// Gets an [Either] of [Failure] or [Unit] based on the [failureOption]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [ContactMessage] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
