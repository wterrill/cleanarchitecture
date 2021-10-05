import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/models/zipcode_info_model.dart';

import '../../../../core/error/exceptions.dart';

abstract class ZipcodeInfoRemoteDataSource {
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ZipcodeInfoModel> getFixedZipcodeInfo(int zipcode);

  ///
  /// Throws a [ServerException] for all error codes.
  Future<ZipcodeInfoModel> getRandomZipcodeInfo();
}

class ZipcodeInfoRemoteDataSourceImpl implements ZipcodeInfoRemoteDataSource {
  final http.Client client;

  ZipcodeInfoRemoteDataSourceImpl({required this.client});

  @override
  Future<ZipcodeInfoModel> getFixedZipcodeInfo(int zipcode) =>
      _getInfoFromUrl('http://api.zippopotam.us/us/$zipcode');

  @override
  Future<ZipcodeInfoModel> getRandomZipcodeInfo() =>
      _getInfoFromUrl('http://api.zippopotam.us/us/60606');

  Future<ZipcodeInfoModel> _getInfoFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ZipcodeInfoModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
