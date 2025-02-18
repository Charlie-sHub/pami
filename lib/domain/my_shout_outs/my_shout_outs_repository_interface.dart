import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/conversation.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the my shout outs repository
abstract class MyShoutOutsRepositoryInterface {
  /// Fetches the shout outs of the current user
  Stream<Either<Failure, Set<ShoutOut>>> watchMyShoutOuts();

  /// Fetches the conversations of the given shout out
  Stream<Either<Failure, List<Conversation>>> watchConversations(
    UniqueId shoutOutId,
  );
}
