import 'dart:convert';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/models/zipcode_info_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tZipcodeInfoModel = ZipcodeInfoModel(
      zipcode: 60606,
      country: 'United States',
      city: 'Chicago',
      state: 'Illinois');

  test(
    'should be a subclass of ZipcodeInfo entity',
    () async {
      // assert
      expect(tZipcodeInfoModel, isA<ZipcodeInfo>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON zipcode is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('info.json'));
        // act
        final result = ZipcodeInfoModel.fromJson(jsonMap);
        // assert
        expect(result, tZipcodeInfoModel);
      },
    );

    test(
      'should return a valid model when the JSON zipcode is regarded as a double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('info_double.json'));
        // act
        final result = ZipcodeInfoModel.fromJson(jsonMap);
        // assert
        expect(result, tZipcodeInfoModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tZipcodeInfoModel.toJson();
        // assert
        final expectedMap = {
          "country": "United States",
          "post code": 60606,
          "city": "Chicago",
          "state": "Illinois"
        };
        expect(result, expectedMap);
      },
    );
  });
}
