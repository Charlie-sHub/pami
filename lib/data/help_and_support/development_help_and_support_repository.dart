import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/domain/core/entities/contact_message.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/help_and_support/help_and_support_repository_interface.dart';

/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: HelpAndSupportRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentHelpAndSupportRepository
    implements HelpAndSupportRepositoryInterface {
  /// Default constructor
  DevelopmentHelpAndSupportRepository(this._logger);

  final Logger _logger;

  @override
  Future<Either<Failure, Unit>> submitContact(ContactMessage message) async {
    _logger.d(
      'Submitting contact message: '
      'id: ${message.id.getOrCrash()}, '
      'type: ${message.type}, '
      'Content: ${message.content.getOrCrash()}',
    );
    return right(unit);
  }
}
