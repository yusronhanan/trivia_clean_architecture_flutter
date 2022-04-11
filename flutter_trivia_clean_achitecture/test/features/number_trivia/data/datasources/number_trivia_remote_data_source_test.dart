import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_trivia_clean_achitecture/core/error/exceptions.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
//flutter pub run build_runner build
void main() {
  late NumberTriviaRemoteDataSourceImpl remoteDataSource;
  late MockClient mockHttpClient;
  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });
  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        remoteDataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get(Uri.parse('$API_TRIVIA_BY_NUMBER/$tNumber'),
            headers: REQUEST_HEADERS));
      },
    );

    test(
      'should return NumberTrivia when response code is 200',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should return ServerException when response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDataSource.getConcreteNumberTrivia;

        // assert
        expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        remoteDataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get(Uri.parse(API_TRIVIA_BY_RANDOM),
            headers: REQUEST_HEADERS));
      },
    );
    test(
      'should return NumberTrivia when response code is 200',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await remoteDataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw ServerException when response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
