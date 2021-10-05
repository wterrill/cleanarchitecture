import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/failures.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/usecases/get_fixed_zipcode_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/presentation/bloc/zipcode_info_event.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/presentation/bloc/zipcode_info_state.dart';

class ZipcodeInfoBloc extends Bloc<ZipcodeInfoEvent, ZipcodeInfoState> {
  final GetFixedZipcodeInfo getFixedZipcodeInfo;
  final InputConverter inputConverter;

  ZipcodeInfoBloc({
    required GetFixedZipcodeInfo fixed,
    required this.inputConverter,
  })  : getFixedZipcodeInfo = fixed,
        super(EmptyZip());

  ZipcodeInfoState get initialState => EmptyZip();

  @override
  Stream<ZipcodeInfoState> mapEventToState(
    ZipcodeInfoEvent event,
  ) async* {
    if (event is GetInfoForFixedZipcode) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.zipcodeString);

      yield* inputEither.fold(
        (failure) async* {
          yield ErrorZip(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield LoadingZip();
          final failureOrInfo =
              await getFixedZipcodeInfo(ParamsZip(zipcode: integer));
          yield* _eitherLoadedOrErrorState(failureOrInfo);
        },
      );
    }
  }

  Stream<ZipcodeInfoState> _eitherLoadedOrErrorState(
    Either<Failure, ZipcodeInfo> failureOrInfo,
  ) async* {
    yield failureOrInfo.fold(
      (failure) => ErrorZip(message: _mapFailureToMessage(failure)),
      (info) => LoadedZip(info: info),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
