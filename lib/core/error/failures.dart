import 'package:equatable/equatable.dart';

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}
