import 'package:dartz/dartz.dart';
import '../error/error_handler.dart';
import '../error/failure.dart';

Future<Either<Failure, T>> executeApiCall<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } catch (e) {
    return Left(ErrorHandler.handle(e));
  }
}
