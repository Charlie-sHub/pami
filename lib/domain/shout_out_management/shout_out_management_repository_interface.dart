import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the shout out management repository
abstract class ShoutOutManagementRepositoryInterface {
  /// Creates a new shout out
  Future<Either<Failure, Unit>> createShoutOut({
    required ShoutOut shoutOut,
    required XFile imageFile,
  });

  /// Edits an existing shout out
  Future<Either<Failure, Unit>> editShoutOut({
    required ShoutOut shoutOut,
    required Option<XFile> imageFile,
  });

  /// Deletes an existing shout out
  Future<Either<Failure, Unit>> deleteShoutOut(UniqueId id);
}
