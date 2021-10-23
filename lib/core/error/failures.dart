import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Failures extends Equatable {
  List properties;

  Failures({this.properties = const <dynamic>[]});

  @override
  List<Object> get props => [properties];
}
