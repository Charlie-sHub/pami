import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'message.freezed.dart';

/// Message entity
@freezed
class Message with _$Message {
  const Message._();

  /// Default constructor
  const factory Message({
    required UniqueId id,
    required UniqueId senderId,
    required MessageContent content,
    required bool isRead,
    required PastDate dateCreated,
  }) = _Message;

  /// Empty constructor
  factory Message.empty() => Message(
        id: UniqueId(),
        senderId: UniqueId(),
        content: MessageContent(''),
        isRead: false,
        dateCreated: PastDate(DateTime.now()),
      );

  /// Gets an [Option] of [Failure]
  Option<Failure<dynamic>> get failureOption => content.failureOrUnit
      .andThen(dateCreated.failureOrUnit)
      .fold(some, (_) => none());

  /// Gets an [Either] of [Failure] or [Unit]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [Message] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
