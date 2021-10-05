import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
