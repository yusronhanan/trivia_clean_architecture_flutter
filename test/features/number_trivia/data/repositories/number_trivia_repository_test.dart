import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_clean_architecture/core/platform/network_info.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

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
}
