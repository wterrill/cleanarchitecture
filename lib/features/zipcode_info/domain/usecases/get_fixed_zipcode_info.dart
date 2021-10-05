import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/failures.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/repositories/zipcode_info_repository.dart';

class GetFixedZipcodeInfo implements UseCase<ZipcodeInfo, ParamsZip> {
  final ZipcodeInfoRepository repository;

  GetFixedZipcodeInfo(this.repository);

  @override
  Future<Either<Failure, ZipcodeInfo>> call(ParamsZip params) async {
    return await repository.getFixedZipcodeInfo(params.zipcode);
  }
}

class ParamsZip extends Equatable {
  final int zipcode;

  ParamsZip({required this.zipcode});

  @override
  List<Object> get props => [zipcode];
}
