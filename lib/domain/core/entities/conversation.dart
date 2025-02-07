import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/message_content.dart';
import 'package:pami/domain/core/validation/objects/past_date.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

part 'conversation.freezed.dart';

/// Conversation entity
@freezed
class Conversation with _$Conversation {
  const Conversation._();

  /// Default constructor
  const factory Conversation({
    required UniqueId id,
    required UniqueId shoutOutCreatorId,
    required UniqueId interestedId,
    required MessageContent lastMessage,
    required DateTime lastMessageDate,
    required PastDate dateCreated,
  }) = _Conversation;

  /// Empty constructor
  factory Conversation.empty() => Conversation(
        id: UniqueId(),
        shoutOutCreatorId: UniqueId(),
        interestedId: UniqueId(),
        lastMessage: MessageContent(''),
        lastMessageDate: DateTime.now(),
        dateCreated: PastDate(DateTime.now()),
      );

  /// Gets an [Option] of [Failure]
  Option<Failure<dynamic>> get failureOption => lastMessage.failureOrUnit
      .andThen(dateCreated.failureOrUnit)
      .fold(some, (_) => none());

  /// Gets an [Either] of [Failure] or [Unit]
  Either<Failure<dynamic>, Unit> get failureOrUnit => failureOption.fold(
        () => right(unit),
        left,
      );

  /// Checks if the [Conversation] is valid
  /// That  is if the [failureOption] is [None]
  bool get isValid => failureOption.isNone();
}
