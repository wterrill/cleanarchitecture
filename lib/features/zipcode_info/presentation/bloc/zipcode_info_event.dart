import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ZipcodeInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInfoForFixedZipcode extends ZipcodeInfoEvent {
  final String zipcodeString;

  GetInfoForFixedZipcode(this.zipcodeString);

  @override
  List<Object> get props => [zipcodeString];
}

class GetInfoForRandomZipcode extends ZipcodeInfoEvent {}
