import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/datasources/zipcode_info_local_data_source.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/datasources/zipcode_info_remote_data_source.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/repositories/zipcode_info_repository_impl.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/repositories/zipcode_info_repository.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/usecases/get_fixed_zipcode_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/presentation/bloc/zipcode_info_bloc.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  // Bloc
  sl.registerFactory(
    () => ZipcodeInfoBloc(
      fixed: sl(),
      inputConverter: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetFixedZipcodeInfo(sl()));

  // Repository
  sl.registerLazySingleton<ZipcodeInfoRepository>(
    () => ZipcodeInfoRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ZipcodeInfoRemoteDataSource>(
    () => ZipcodeInfoRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ZipcodeInfoLocalDataSource>(
    () => ZipcodeInfoLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
