import 'dart:convert';

import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/datasources/zipcode_info_local_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/models/zipcode_info_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'zipcode_info_local_data_source_test.mocks.dart';

// class MockSharedPreferences extends Mock implements SharedPreferences {}

@GenerateMocks(
  [SharedPreferences],
  // customMocks: [MockSpec<SharedPreferences>(returnNullOnMissingStub: true)],
)
void main() {
  late ZipcodeInfoLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ZipcodeInfoLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastZipcodeInfo', () {
    final tZipcodeInfoModel =
        ZipcodeInfoModel.fromJson(json.decode(fixture('info_cached.json')));

    test(
      'should return ZipcodeInfo from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('info_cached.json'));
        // act
        final result = await dataSource.getLastZipcodeInfo();
        // assert
        verify(mockSharedPreferences.getString(CACHED_ZIPCODE_INFO));
        expect(result, equals(tZipcodeInfoModel));
      },
    );

    test(
      'should throw a CacheExeption when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastZipcodeInfo;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheZipcodeInfo', () {
    final tZipcodeInfoModel = ZipcodeInfoModel(
        zipcode: 1,
        country: 'test zipcode',
        city: 'Chicago',
        state: 'Illinois');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        //Arrange
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) => Future.value(true));
        // act
        dataSource.cacheZipcodeInfo(tZipcodeInfoModel);
        // assert
        final expectedJsonString = json.encode(tZipcodeInfoModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_ZIPCODE_INFO,
          expectedJsonString,
        ));
      },
    );
  });
}
