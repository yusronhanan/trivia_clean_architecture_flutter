// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_trivia_clean_achitecture/core/error/failures.dart';
import 'package:flutter_trivia_clean_achitecture/core/presentation/util/input_converter.dart';
import 'package:flutter_trivia_clean_achitecture/core/usecases/usecase.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invaild Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final InputConverter inputConverter;
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  NumberTriviaBloc({
    required this.inputConverter,
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
  }) : super(NumberTriviaInitial()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        try {
          emit(NumberTriviaLoading());

          final inputEither =
              inputConverter.stringToUnsignedInteger(event.numberString);

          final int number = extractNumber(inputEither);
          if (number == -1) {
            emit(const NumberTriviaError(INVALID_INPUT_FAILURE_MESSAGE));
          } else {
            final failureOrTrivia = await getConcreteNumberTrivia(
                ParamsGetConcreteNumberTrivia(number: number));
            _eitherLoadedOrErrorState(failureOrTrivia, emit);
          }
        } on Failures {
          emit(const NumberTriviaError('Error on Bloc'));
        }
      } else if (event is GetTriviaForRandomNumber) {
        try {
          emit(NumberTriviaLoading());
          final failureOrTrivia = await getRandomNumberTrivia(NoParams());
          _eitherLoadedOrErrorState(failureOrTrivia, emit);
        } on Failures {
          emit(const NumberTriviaError('Error on Bloc'));
        }
      }
    });
  }
  int extractNumber(Either<Failures, int> inputEither) {
    return inputEither.fold(
      (failure) => -1,
      (integer) => integer,
    );
  }

  void _eitherLoadedOrErrorState(Either<Failures, NumberTrivia> failureOrTrivia,
      Emitter<NumberTriviaState> emit) async {
    emit(
      failureOrTrivia.fold(
          (failure) => NumberTriviaError(_mapFailureToMessage(failure)),
          (trivia) => NumberTriviaLoaded(trivia)),
    );
  }

  String _mapFailureToMessage(Failures failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
  /* 
  //Template Override to use async* and yield
  @override
   Stream<CollectionState> mapEventToState(
    CollectionEvent event,
  ) async* {
    if (event is EventName) {
      
    }
  }*/

/*
  //IMPLEMENTING dartz EITHER ON OLD BLOC VERSION
  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield const NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (integer) => throw UnimplementedError());
    }
  }
  */

  /*
  //IMPLEMENTING dartz EITHER ON CURRENT BLOC VERSION
on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        inputEither.fold((failure) async {
          emit(const NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE));
        }, (integer) => throw UnimplementedError());
      }
    });
    */
}
