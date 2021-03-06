// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  List properties;

  Failures({this.properties = const <dynamic>[]});

  @override
  List<Object> get props => [properties];
}

//General Failures
class ServerFailure extends Failures {}

class CacheFailure extends Failures {}
