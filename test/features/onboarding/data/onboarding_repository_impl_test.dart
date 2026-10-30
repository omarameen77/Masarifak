import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_error_codes.dart';
import 'package:masarifak/core/constants/api_error_fields.dart';
import 'package:masarifak/core/error/failure.dart';
import 'package:masarifak/core/result/result.dart';
import 'package:masarifak/features/onboarding/data/models/onboarding_request.dart';
import 'package:masarifak/features/onboarding/data/models/onboarding_response_dto.dart';
import 'package:masarifak/features/onboarding/data/onboarding_remote_data_source.dart';
import 'package:masarifak/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_draft.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRemoteDataSource extends Mock
    implements OnboardingRemoteDataSource {}

class FakeOnboardingRequest extends Fake implements OnboardingRequest {}

void main() {
  const draft = OnboardingDraft(
    currencyCode: 'EGP',
    timezone: 'Africa/Cairo',
    weekStart: 6,
    salaryMinor: 500000,
    payday: 1,
    safetyBalanceMinor: 100000,
    savingsContributionMinor: 0,
    savingsOpeningBalanceMinor: 0,
    spentSoFarMinor: 0,
    obligations: [],
  );
  const response = OnboardingResponseDto(
    summary: OnboardingSummaryDto(
      remainingMinor: 500000,
      spendableMinor: 500000,
      spentMinor: 0,
      reservedMinor: 0,
      savingsMinor: 0,
      dailyBudgetMinor: 12903,
      status: 'ok',
    ),
    obligationIds: {'c-1': 'server-id'},
  );
  final request = RequestOptions();

  DioException badResponse(int status, Map<String, dynamic> error) =>
      DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response<Object?>(
          requestOptions: request,
          statusCode: status,
          data: {ApiErrorFields.error: error},
        ),
      );

  late MockOnboardingRemoteDataSource remote;
  late OnboardingRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(FakeOnboardingRequest()));

  setUp(() {
    remote = MockOnboardingRemoteDataSource();
    repository = OnboardingRepositoryImpl(remote);
  });

  test('complete sends the idempotency key and maps the result', () async {
    when(
      () => remote.complete(any(), idempotencyKey: 'key-1'),
    ).thenAnswer((_) async => response);

    final result = await repository.complete(draft, idempotencyKey: 'key-1');

    expect(result, isA<Success<Object?>>());
    final data = (result as Success).data;
    expect(data.obligationIds, {'c-1': 'server-id'});
    verify(() => remote.complete(any(), idempotencyKey: 'key-1')).called(1);
  });

  test('422 with a step maps to ValidationFailure carrying the step', () async {
    when(() => remote.preview(any())).thenThrow(
      badResponse(422, {ApiErrorFields.step: 3}),
    );

    final result = await repository.preview(draft);

    expect(result, isA<Error<Object?>>());
    expect((result as Error).failure, const ValidationFailure(null, step: 3));
  });

  test('409 already_onboarded maps to ConflictFailure', () async {
    when(
      () => remote.complete(any(), idempotencyKey: any(named: 'idempotencyKey')),
    ).thenThrow(
      badResponse(409, {ApiErrorFields.code: ApiErrorCodes.alreadyOnboarded}),
    );

    final result = await repository.complete(draft, idempotencyKey: 'key-1');

    expect(
      (result as Error).failure,
      const ConflictFailure(ApiErrorCodes.alreadyOnboarded),
    );
  });
}
