import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia
    implements UseCase<NumberTrivia, ParamsGetConcreteNumberTrivia> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failures, NumberTrivia>> call(
      ParamsGetConcreteNumberTrivia params) //prev: execute
  async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class ParamsGetConcreteNumberTrivia extends Equatable {
  final int number;

  const ParamsGetConcreteNumberTrivia({required this.number});

  @override
  List<Object> get props => [number];
}
