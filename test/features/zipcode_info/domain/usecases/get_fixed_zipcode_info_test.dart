import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/repositories/zipcode_info_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/usecases/get_fixed_zipcode_info.dart';

import 'get_fixed_zipcode_info_test.mocks.dart';

@GenerateMocks([ZipcodeInfoRepository])
void main() {
  late GetFixedZipcodeInfo usecase;
  late MockZipcodeInfoRepository mockZipcodeInfoRepository;

  setUp(() {
    mockZipcodeInfoRepository = MockZipcodeInfoRepository();
    usecase = GetFixedZipcodeInfo(mockZipcodeInfoRepository);
  });

  final tZipcode = 1;
  final tZipcodeInfo = ZipcodeInfo(
      zipcode: 60606,
      country: 'United States',
      city: 'Chicago',
      state: 'Illinois');

  test(
    'should get info for the zipcode from the repository',
    () async {
      // arrange
      when(mockZipcodeInfoRepository.getFixedZipcodeInfo(any))
          .thenAnswer((_) async => Right(tZipcodeInfo));
      // act
      final result = await usecase(ParamsZip(zipcode: tZipcode));
      // assert
      expect(result, Right(tZipcodeInfo));
      verify(mockZipcodeInfoRepository.getFixedZipcodeInfo(tZipcode));
      verifyNoMoreInteractions(mockZipcodeInfoRepository);
    },
  );
}
