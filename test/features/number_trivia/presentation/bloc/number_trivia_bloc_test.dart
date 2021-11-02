import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:trivia_clean_architecture/core/presentation/util/input_converter.dart';
import 'package:trivia_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([InputConverter, GetConcreteNumberTrivia, GetRandomNumberTrivia])
// Then run: flutter pub run build_runner build
void main() {
  late MockInputConverter mockInputConverter;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late NumberTriviaBloc bloc;
  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();

    bloc = NumberTriviaBloc(
        inputConverter: mockInputConverter,
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia);
  });

  test(
    'should empty for initial state',
    () async {
      // assert
      /*
        https://github.com/felangel/bloc/issues/1518#issuecomment-663014717
        You can test your initial state via:
        test(‘initial state is correct’, () {
          expect(SampleBloc(‘a’).state, ‘a’);
        });
        */
      expect(bloc.state, equals(NumberTriviaInitial()));
    },
  );
  group('GetTriviaConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia =
        NumberTrivia(text: "Test Trivia", number: tNumberParsed);

    test(
      'should call input converter to vaildate and convert the string to unsigned integer',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // act
        /*
        //bloc.dispatch is deprecated 
        https://github.com/felangel/bloc/issues/603#issuecomment-545305975
        There were core api changes introduced into 1.0.0:
        bloc.state.listen -> bloc.listen
        bloc.currentState -> bloc.state
        bloc.dispatch -> bloc.add
        bloc.dispose -> bloc.close

        Check out https://link.medium.com/qnfMcEcW00 for more details.
        */
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString)); //return void
        // assert later
        final expected = [
          const NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(
            bloc.stream,
            emitsInOrder(
                expected)); //make until all of the value is actually emmited, this test will be put on hold (same like async await until event is emitted)
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString)); //return void
        await untilCalled(mockGetConcreteNumberTrivia(
            any)); // need this because we call event of bloc
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));

        verify(mockGetConcreteNumberTrivia(
            ParamsGetConcreteNumberTrivia(number: tNumberParsed)));
      },
    );
  });
}
