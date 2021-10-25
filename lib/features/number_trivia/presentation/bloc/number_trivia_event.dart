part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaConcreteNumber(this.numberString);

  //replacement for super
  @override
  List<Object> get props => [numberString];
}

class GetTriviaRandomNumber extends NumberTriviaEvent {}
