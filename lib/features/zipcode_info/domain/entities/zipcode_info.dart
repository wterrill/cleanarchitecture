import 'package:equatable/equatable.dart';

class ZipcodeInfo extends Equatable {
  final String country;
  final int zipcode;
  final String city;
  final String state;

  ZipcodeInfo(
      {required this.country,
      required this.zipcode,
      required this.city,
      required this.state});

  @override
  List<Object> get props => [country, zipcode, city, state];
}
