import 'dart:convert';

import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/datasources/zipcode_info_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/models/zipcode_info_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'zipcode_info_remote_data_source_test.mocks.dart';

// class MockHttpClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  late ZipcodeInfoRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ZipcodeInfoRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('info_full.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getFixedZipcodeInfo', () {
    final tZipcode = 60606;
    final tZipcodeInfoModel =
        ZipcodeInfoModel.fromJson(json.decode(fixture('info.json')));

    test(
      '''should perform a GET request on a URL with zipcode
       being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getFixedZipcodeInfo(tZipcode);
        // assert
        verify(mockHttpClient.get(
          Uri.parse('http://api.zippopotam.us/us/$tZipcode'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return ZipcodeInfo when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getFixedZipcodeInfo(tZipcode);
        // assert
        expect(result, equals(tZipcodeInfoModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getFixedZipcodeInfo;
        // assert
        expect(() => call(tZipcode), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
