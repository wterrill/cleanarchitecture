import 'package:dartz/dartz.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      if (!RegExp(r'\d{5}').hasMatch(str)) {
        throw FormatException();
      }

      final integer = int.parse(str);

      if (integer < 0) throw FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
