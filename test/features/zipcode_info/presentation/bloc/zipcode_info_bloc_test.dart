import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/failures.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/repositories/zipcode_info_repository.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/usecases/get_fixed_zipcode_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'zipcode_info_bloc_test.mocks.dart';

@GenerateMocks([
  ZipcodeInfoRepository,
  GetFixedZipcodeInfo,
  InputConverter,
])
void main() {
  late ZipcodeInfoBloc bloc;

  late MockGetFixedZipcodeInfo mockGetFixedZipcodeInfo;
  late MockInputConverter mockInputConverter;
  late MockZipcodeInfoRepository mockZipcodeInfoRepository;

  setUp(() {
    mockGetFixedZipcodeInfo = MockGetFixedZipcodeInfo();
    mockInputConverter = MockInputConverter();
    mockZipcodeInfoRepository = MockZipcodeInfoRepository();

    bloc = ZipcodeInfoBloc(
      fixed: mockGetFixedZipcodeInfo,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(EmptyZip()));
  });

  group('GetInfoForFixedZipcode', () {
    final tZipcodeString = '12345';
    final tZipcodeParsed = 12345;
    final tZipcodeInfo = ZipcodeInfo(
        zipcode: 12345,
        city: 'Chicago',
        country: 'United States',
        state: 'Illinois');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tZipcodeParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        when(mockZipcodeInfoRepository.getFixedZipcodeInfo(any))
            .thenAnswer((_) async => Right(tZipcodeInfo));

        when(mockZipcodeInfoRepository.getRandomZipcodeInfo())
            .thenAnswer((_) async => Right(tZipcodeInfo));

        when(mockGetFixedZipcodeInfo.call(any)).thenAnswer((_) async =>
            mockZipcodeInfoRepository.getFixedZipcodeInfo(tZipcodeParsed));

        // act
        bloc.add(GetInfoForFixedZipcode(tZipcodeString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tZipcodeString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          ErrorZip(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetInfoForFixedZipcode(tZipcodeString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetFixedZipcodeInfo(any))
            .thenAnswer((_) async => Right(tZipcodeInfo));
        // act
        bloc.add(GetInfoForFixedZipcode(tZipcodeString));
        await untilCalled(mockGetFixedZipcodeInfo(any));
        // assert
        verify(mockGetFixedZipcodeInfo(ParamsZip(zipcode: tZipcodeParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetFixedZipcodeInfo(any))
            .thenAnswer((_) async => Right(tZipcodeInfo));
        // assert later
        final expected = [
          LoadingZip(),
          LoadedZip(info: tZipcodeInfo),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetInfoForFixedZipcode(tZipcodeString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetFixedZipcodeInfo(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          LoadingZip(),
          ErrorZip(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetInfoForFixedZipcode(tZipcodeString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetFixedZipcodeInfo(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          LoadingZip(),
          ErrorZip(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetInfoForFixedZipcode(tZipcodeString));
      },
    );
  });
}
