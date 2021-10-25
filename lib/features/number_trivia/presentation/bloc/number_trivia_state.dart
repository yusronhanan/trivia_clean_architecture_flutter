// ignore_for_file: prefer_const_constructors_in_immutables

part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

// class NumberTriviaInitial extends NumberTriviaState {}
class EmptyNumberTrivia extends NumberTriviaState {}

/// Hold the NumberTrivia Entity
class LoadedNumberTrivia extends NumberTriviaState {
  final NumberTrivia trivia;

  LoadedNumberTrivia({required this.trivia});

  @override
  List<Object> get props => [trivia];
}

/// Hold the NumberTrivia Entity
class ErrorNumberTrivia extends NumberTriviaState {
  final String message;

  ErrorNumberTrivia({required this.message});

  @override
  List<Object> get props => [message];
}
