// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter_trivia_clean_achitecture/core/error/exceptions.dart';

import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

const BASE_API_TRIVIA = 'http://numbersapi.com';
const API_TRIVIA_BY_NUMBER = BASE_API_TRIVIA;
const API_TRIVIA_BY_RANDOM = '$BASE_API_TRIVIA/random';

const REQUEST_HEADERS = {'Content-Type': 'application/json'};

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return _getTriviaFromUrl('$API_TRIVIA_BY_NUMBER/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return _getTriviaFromUrl(API_TRIVIA_BY_RANDOM);
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String API_URL) async {
    final response =
        await client.get(Uri.parse(API_URL), headers: REQUEST_HEADERS);
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
