import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_clean_architecture/core/error/exceptions.dart';
import 'package:trivia_clean_architecture/core/error/failures.dart';
import 'package:trivia_clean_architecture/core/platform/network_info.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
// Then run: flutter pub run build_runner build

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTrivialModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');

    final NumberTrivia tNumberTrivia = tNumberTrivialModel;
    // test(
    //   'should check if the connection is online',
    //   () async {
    //     // arrange
    //     when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //     // act
    //     repository.getConcreteNumberTrivia(tNumber);
    //     // assert
    //     verify(mockNetworkInfo.isConnected);
    //   },
    // );

    runTestsOnline(() {
      test(
        'should return remote data WHEN the call to remote data is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTrivialModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally WHEN the call remote data is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTrivialModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivialModel));
        },
      );

      test(
        'should return Server Failure WHEN the call to remote data is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTrivialModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'should return cached failure when there is no cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTrivialModel =
        NumberTriviaModel(number: 123, text: 'test trivia');

    final NumberTrivia tNumberTrivia = tNumberTrivialModel;
    // test(
    //   'should check if the connection is online',
    //   () async {
    //     // arrange
    //     when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //     // act
    //     repository.getRandomNumberTrivia();
    //     // assert
    //     verify(mockNetworkInfo.isConnected);
    //   },
    // );

    runTestsOnline(() {
      test(
        'should return remote data WHEN the call to remote data is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTrivialModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());

          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally WHEN the call remote data is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTrivialModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());

          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivialModel));
        },
      );

      test(
        'should return Server Failure WHEN the call to remote data is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTrivialModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'should return cached failure when there is no cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
