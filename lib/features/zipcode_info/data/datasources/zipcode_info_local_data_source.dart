import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/models/zipcode_info_model.dart';

abstract class ZipcodeInfoLocalDataSource {
  /// Gets the cached [ZipcodeInfoModel] (which is analogous to the zipcode one)
  ///  which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<ZipcodeInfoModel> getLastZipcodeInfo();

  Future<bool> cacheZipcodeInfo(ZipcodeInfoModel infoToCache);
}

const CACHED_ZIPCODE_INFO = 'CACHED_ZIPCODE_INFO';

class ZipcodeInfoLocalDataSourceImpl implements ZipcodeInfoLocalDataSource {
  final SharedPreferences sharedPreferences;

  ZipcodeInfoLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ZipcodeInfoModel> getLastZipcodeInfo() {
    final jsonString = sharedPreferences.getString(CACHED_ZIPCODE_INFO);
    if (jsonString != null) {
      return Future.value(ZipcodeInfoModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheZipcodeInfo(ZipcodeInfoModel infoToCache) {
    return sharedPreferences.setString(
      CACHED_ZIPCODE_INFO,
      json.encode(infoToCache.toJson()),
    );
  }
}
