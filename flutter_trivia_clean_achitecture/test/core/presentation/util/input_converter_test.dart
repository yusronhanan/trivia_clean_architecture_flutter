// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_clean_achitecture/core/presentation/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    final randomIntNumber = 123;
    final randomDoubleNumber = 12.3;
    final randomNegativeIntNumber = -123;

    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // arrange
        final str = randomIntNumber.toString();
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Right(randomIntNumber));
      },
    );

    test(
      'should return a FAILURE when the string is not an integer (after converted)',
      () async {
        // arrange
        final str = randomDoubleNumber.toString();
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a FAILURE when the string is a negative integer (after converted)',
      () async {
        // arrange
        final str = randomNegativeIntNumber.toString();
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
