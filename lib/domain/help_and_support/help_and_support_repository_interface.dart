import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/contact_message.dart';
import 'package:pami/domain/core/failures/failure.dart';

/// Interface for the help and support repository
abstract class HelpAndSupportRepositoryInterface {
  /// Submits contact request
  Future<Either<Failure, Unit>> submitContact(ContactMessage message);
}
