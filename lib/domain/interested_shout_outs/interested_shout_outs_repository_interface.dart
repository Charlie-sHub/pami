import 'package:dartz/dartz.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/failures/app_failure.dart';
import 'package:pami/domain/core/validation/objects/unique_id.dart';

/// Interface for the interested shout outs repository
abstract class InterestedShoutOutsRepositoryInterface {
  /// Fetches the interested shout outs
  Stream<Either<AppFailure, List<ShoutOut>>> watchInterestedShoutOuts();

  /// Adds a shout out to the list of interested shout outs
  Future<Either<AppFailure, Unit>> addInterestedShoutOut(UniqueId shoutOutId);

  /// Dismisses a shout out from the list of interested shout outs
  Future<Either<AppFailure, Unit>> dismissInterestedShoutOut(
    UniqueId shoutOutId,
  );

  /// Dismisses a shout out from the list of interested shout outs
  Future<Either<AppFailure, Unit>> confirmScan({
    required UniqueId shoutOutId,
    required UniqueId scannerUserId,
    // Raw payload is optional may be useful for server-side verification/telemetry later
    required Option<String> rawPayload,
  });
}
