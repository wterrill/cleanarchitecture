import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/failures.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/datasources/zipcode_info_local_data_source.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/datasources/zipcode_info_remote_data_source.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/models/zipcode_info_model.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/repositories/zipcode_info_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';

import 'zipcode_info_repository_impl_test.mocks.dart';

@GenerateMocks([
  ZipcodeInfoLocalDataSource,
  ZipcodeInfoRemoteDataSource,
  NetworkInfo,
])
void main() {
  late ZipcodeInfoRepositoryImpl repository;
  late MockZipcodeInfoRemoteDataSource mockRemoteDataSource;
  late MockZipcodeInfoLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockZipcodeInfoRemoteDataSource();
    mockLocalDataSource = MockZipcodeInfoLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ZipcodeInfoRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
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

  group('getFixedZipcodeInfo', () {
    final tZipcode = 60606;
    final tZipcodeInfoModel = ZipcodeInfoModel(
        zipcode: tZipcode,
        country: 'United States',
        city: 'Chicago',
        state: 'Illinois');
    final ZipcodeInfo tZipcodeInfo = tZipcodeInfoModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockLocalDataSource.cacheZipcodeInfo(any))
            .thenAnswer((_) async => false);
        when(mockRemoteDataSource.getFixedZipcodeInfo(any))
            .thenAnswer((_) async => tZipcodeInfoModel);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getFixedZipcodeInfo(tZipcode);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getFixedZipcodeInfo(any))
              .thenAnswer((_) async => tZipcodeInfoModel);
          when(mockLocalDataSource.cacheZipcodeInfo(any))
              .thenAnswer((_) async => false);
          // act
          final result = await repository.getFixedZipcodeInfo(tZipcode);
          // assert
          verify(mockRemoteDataSource.getFixedZipcodeInfo(tZipcode));
          expect(result, equals(Right(tZipcodeInfo)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getFixedZipcodeInfo(any))
              .thenAnswer((_) async => tZipcodeInfoModel);
          when(mockLocalDataSource.cacheZipcodeInfo(any))
              .thenAnswer((_) async => false);
          // act
          await repository.getFixedZipcodeInfo(tZipcode);
          // assert
          verify(mockRemoteDataSource.getFixedZipcodeInfo(tZipcode));
          verify(mockLocalDataSource.cacheZipcodeInfo(tZipcodeInfoModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getFixedZipcodeInfo(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getFixedZipcodeInfo(tZipcode);
          // assert
          verify(mockRemoteDataSource.getFixedZipcodeInfo(tZipcode));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastZipcodeInfo())
              .thenAnswer((_) async => tZipcodeInfoModel);
          // act
          final result = await repository.getFixedZipcodeInfo(tZipcode);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastZipcodeInfo());
          expect(result, equals(Right(tZipcodeInfo)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastZipcodeInfo())
              .thenThrow(CacheException());
          // act
          final result = await repository.getFixedZipcodeInfo(tZipcode);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastZipcodeInfo());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomZipcodeInfo', () {
    final tZipcodeInfoModel = ZipcodeInfoModel(
        zipcode: 60606,
        country: 'United States',
        city: 'Chicago',
        state: 'Illinois');
    final ZipcodeInfo tZipcodeInfo = tZipcodeInfoModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        when(mockRemoteDataSource.getRandomZipcodeInfo())
            .thenAnswer((_) async => tZipcodeInfoModel);

        when(mockLocalDataSource.cacheZipcodeInfo(any))
            .thenAnswer((_) async => false);

        // act
        repository.getRandomZipcodeInfo();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomZipcodeInfo())
              .thenAnswer((_) async => tZipcodeInfoModel);
          when(mockLocalDataSource.cacheZipcodeInfo(any))
              .thenAnswer((_) async => false);
          // act
          final result = await repository.getRandomZipcodeInfo();
          // assert
          verify(mockRemoteDataSource.getRandomZipcodeInfo());
          expect(result, equals(Right(tZipcodeInfo)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomZipcodeInfo())
              .thenAnswer((_) async => tZipcodeInfoModel);
          when(mockLocalDataSource.cacheZipcodeInfo(any))
              .thenAnswer((_) async => false);
          // act
          await repository.getRandomZipcodeInfo();
          // assert
          verify(mockRemoteDataSource.getRandomZipcodeInfo());
          verify(mockLocalDataSource.cacheZipcodeInfo(tZipcodeInfoModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomZipcodeInfo())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomZipcodeInfo();
          // assert
          verify(mockRemoteDataSource.getRandomZipcodeInfo());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastZipcodeInfo())
              .thenAnswer((_) async => tZipcodeInfoModel);
          // act
          final result = await repository.getRandomZipcodeInfo();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastZipcodeInfo());
          expect(result, equals(Right(tZipcodeInfo)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastZipcodeInfo())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomZipcodeInfo();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastZipcodeInfo());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
