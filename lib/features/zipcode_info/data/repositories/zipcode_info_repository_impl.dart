import 'package:dartz/dartz.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/datasources/zipcode_info_local_data_source.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/datasources/zipcode_info_remote_data_source.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/data/models/zipcode_info_model.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/repositories/zipcode_info_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

typedef Future<ZipcodeInfo> _FixedOrRandomChooser();

class ZipcodeInfoRepositoryImpl implements ZipcodeInfoRepository {
  final ZipcodeInfoRemoteDataSource remoteDataSource;
  final ZipcodeInfoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ZipcodeInfoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ZipcodeInfo>> getFixedZipcodeInfo(
    int zipcode,
  ) async {
    return await _getInfo(() {
      return remoteDataSource.getFixedZipcodeInfo(zipcode);
    });
  }

  @override
  Future<Either<Failure, ZipcodeInfo>> getRandomZipcodeInfo() async {
    return await _getInfo(() {
      return remoteDataSource.getRandomZipcodeInfo();
    });
  }

  Future<Either<Failure, ZipcodeInfo>> _getInfo(
    _FixedOrRandomChooser getFixedOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteInfo = await getFixedOrRandom();
        localDataSource.cacheZipcodeInfo(remoteInfo as ZipcodeInfoModel);
        return Right(remoteInfo);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localInfo = await localDataSource.getLastZipcodeInfo();
        return Right(localInfo);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
