// Mocks generated by Mockito 5.0.14 from annotations
// in will_terrill_based_on_resocoder_clean_architecture_tdd_course/test/features/zipcode_info/domain/usecases/get_fixed_zipcode_info_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/core/error/failures.dart'
    as _i5;
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/entities/zipcode_info.dart'
    as _i6;
import 'package:will_terrill_based_on_resocoder_clean_architecture_tdd_course/features/zipcode_info/domain/repositories/zipcode_info_repository.dart'
    as _i3;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [ZipcodeInfoRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockZipcodeInfoRepository extends _i1.Mock
    implements _i3.ZipcodeInfoRepository {
  MockZipcodeInfoRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.ZipcodeInfo>> getFixedZipcodeInfo(
          int? zipcode) =>
      (super.noSuchMethod(Invocation.method(#getFixedZipcodeInfo, [zipcode]),
          returnValue: Future<_i2.Either<_i5.Failure, _i6.ZipcodeInfo>>.value(
              _FakeEither_0<_i5.Failure, _i6.ZipcodeInfo>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i6.ZipcodeInfo>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.ZipcodeInfo>> getRandomZipcodeInfo() =>
      (super.noSuchMethod(Invocation.method(#getRandomZipcodeInfo, []),
          returnValue: Future<_i2.Either<_i5.Failure, _i6.ZipcodeInfo>>.value(
              _FakeEither_0<_i5.Failure, _i6.ZipcodeInfo>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i6.ZipcodeInfo>>);
  @override
  String toString() => super.toString();
}