// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_trivia_clean_achitecture/core/error/exceptions.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
//flutter pub run build_runner build
void main() {
  late NumberTriviaLocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await localDataSource.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw CACHE EXCEPTION, when there is not a CACHED value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = localDataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test(
      'should call SharedPreferences to cache the data',
      () async {
        //arrange
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);
        // act
        localDataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonToString = jsonEncode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJsonToString));
      },
    );
  });
}
