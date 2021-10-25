import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trivia_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc() : super(EmptyNumberTrivia()) {
    on<NumberTriviaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
