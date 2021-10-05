import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';

class ZipcodeInfoModel extends ZipcodeInfo {
  ZipcodeInfoModel({
    required String country,
    required int zipcode,
    required String city,
    required String state,
  }) : super(country: country, zipcode: zipcode, city: city, state: state);

  factory ZipcodeInfoModel.fromJson(Map<String, dynamic> json) {
    return ZipcodeInfoModel(
      country: json['country'],
      zipcode: int.parse(json['post code'] as String),
      city: json['city'] ?? json['places'][0]['place name'],
      state: json['state'] ?? json['places'][0]['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'post code': zipcode,
      'city': city,
      'state': state
    };
  }
}
