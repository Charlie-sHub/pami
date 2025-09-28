import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';
import 'package:pami/domain/shout_out_management/shout_out_management_repository_interface.dart';

// coverage:ignore-files
/// Simple repository to work in dev, does nothing except return success
@LazySingleton(
  as: ShoutOutManagementRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentShoutOutManagementRepository
    implements ShoutOutManagementRepositoryInterface {
  /// Default constructor
  DevelopmentShoutOutManagementRepository(this._logger);

  final Logger _logger;

  @override
  Future<Either<Failure, Unit>> createShoutOut({
    required ShoutOut shoutOut,
    required XFile imageFile,
  }) async {
    _logger.d('Creating shout out: ${shoutOut.id.getOrCrash()}');
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> editShoutOut({
    required ShoutOut shoutOut,
    required Option<XFile> imageFile,
  }) async {
    _logger.d('Editing shout out: ${shoutOut.id.getOrCrash()}');
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteShoutOut(UniqueId id) async {
    _logger.d('Deleting shout out: ${id.getOrCrash()}');
    return right(unit);
  }
}
