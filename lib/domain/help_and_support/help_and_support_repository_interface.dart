import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/message.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Interface for the help and support repository
abstract class HelpAndSupportRepositoryInterface {
  /// Submits feedback
  Future<Either<Failure, Unit>> submitFeedback(Message feedback);

  /// Submits contact request
  Future<Either<Failure, Unit>> submitContactRequest(Message request);
}
