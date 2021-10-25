// ignore_for_file: must_be_immutable

import 'package:dartz/dartz.dart';
import 'package:trivia_clean_architecture/core/error/failures.dart';

class InputConverter {
  Either<Failures, int> stringToUnsignedInteger(String str) {
    try {
      final integerNum = int.parse(str);
      if (integerNum < 0) throw const FormatException();
      return Right(integerNum);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failures {}
