import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';

@immutable
abstract class ZipcodeInfoState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyZip extends ZipcodeInfoState {}

class LoadingZip extends ZipcodeInfoState {}

class LoadedZip extends ZipcodeInfoState {
  final ZipcodeInfo info;

  LoadedZip({required this.info});

  @override
  List<Object> get props => [info];
}

class ErrorZip extends ZipcodeInfoState {
  final String message;

  ErrorZip({required this.message});

  @override
  List<Object> get props => [message];
}
