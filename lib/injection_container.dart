import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_clean_architecture/core/network/network_info.dart';
import 'package:trivia_clean_architecture/core/presentation/util/input_converter.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

//? Dependency Injection was the missing link between production code and test code where we sort of inject the dependency manually with passing the mock class (when test), which now it's called in production code with get_it as service locator

final sl = GetIt.instance;
Future<void> init() async {
  //! Features - Number Trivia => instantiate data sources go here
  initFeatures();

  //! Core => instantiate core/*
  initCore();
  //! External => instantiate third party

  await initExternal();
}

void initFeatures() {
  //Bloc
  //? use sl() to invoke
  //? registerFactory() => create new instance every called
  //? Bloc should always use registerFactory
  //? register..Singleton() => only called once in the first place, not create new instance every called afterwards. Stream isn't closed, if not lazy, it's register immediately if app started
  //? registerLazySingleton() => called when its necessary

  sl.registerFactory<NumberTriviaBloc>(() => NumberTriviaBloc(
      inputConverter: sl<InputConverter>(),
      getConcreteNumberTrivia: sl<GetConcreteNumberTrivia>(),
      getRandomNumberTrivia: sl<GetRandomNumberTrivia>()));
  //Usecases
  sl.registerLazySingleton(
      () => GetConcreteNumberTrivia(sl<NumberTriviaRepository>()));
  sl.registerLazySingleton(
      () => GetRandomNumberTrivia(sl<NumberTriviaRepository>()));

  //Repository
  ///? use NumberTriviaRepository as type (bcs it's contract) and NumberTriviaRepositoryImpl since it's the implementation of contract
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          localDataSource: sl<NumberTriviaLocalDataSource>(),
          remoteDataSource: sl<NumberTriviaRemoteDataSource>(),
          networkInfo: sl<NetworkInfo>()));

  //Data
  //?same implementation with Repository, since it has contract that implement in different class
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl<http.Client>()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() =>
      NumberTriviaLocalDataSourceImpl(
          sharedPreferences: sl<SharedPreferences>()));
}

void initCore() {
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl<DataConnectionChecker>()));
}

Future<void> initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
