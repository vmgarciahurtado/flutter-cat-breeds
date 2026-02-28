import 'package:dartz/dartz.dart';
import 'package:catbreeds/core/error/error_handler.dart';
import 'package:catbreeds/core/error/failure.dart';

Future<Either<Failure, T>> executeApiCall<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } catch (e) {
    return Left(ErrorHandler.handle(e));
  }
}
