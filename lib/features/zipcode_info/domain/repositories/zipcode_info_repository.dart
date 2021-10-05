import 'package:dartz/dartz.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';

import '../../../../core/error/failures.dart';

abstract class ZipcodeInfoRepository {
  Future<Either<Failure, ZipcodeInfo>> getFixedZipcodeInfo(int zipcode);
  Future<Either<Failure, ZipcodeInfo>> getRandomZipcodeInfo();
}
