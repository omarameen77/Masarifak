import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/network/data_envelope.dart';
import 'package:masarifak/features/auth/data/models/auth_requests.dart';
import 'package:masarifak/features/auth/data/models/profile_dto.dart';
import 'package:masarifak/features/auth/data/models/session_dto.dart';
import 'package:masarifak/features/auth/data/models/verified_email_dto.dart';
import 'package:masarifak/features/auth/domain/entities/auth_session.dart';
import 'package:masarifak/features/auth/domain/entities/auth_user.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';
import 'package:masarifak/features/auth/domain/entities/login_outcome.dart';
import 'package:masarifak/features/auth/domain/entities/verified_email.dart';

const loginResponseJson = '''
{ "data": {
  "access_token": "eyJ0eXAiOiJKV1Qi…",
  "refresh_token": "rt_9f3c…",
  "expires_in": 900,
  "user": { "id": "01M5Z7…", "name": "أحمد", "email_verified": true },
  "features": { "version": 14, "features": { "ask": { "enabled": true } } }
} }
''';

const profileResponseJson = '''
{ "data": { "onboarded": true, "timezone": "Africa/Cairo",
  "week_start": 6, "theme": "system",
  "has_pending_review": false, "unread_notifications": 3 } }
''';

const verifyResponseJson = '''
{ "data": { "email": "ahmed@example.com", "email_verified": true } }
''';

Map<String, dynamic> decode(String json) => jsonDecode(json) as Map<String, dynamic>;

DataEnvelope<SessionDto> parseSession(String json) => DataEnvelope.fromJson(
  decode(json),
  (data) => SessionDto.fromJson(data as Map<String, dynamic>),
);

void main() {
  const expectedLoginOutcome = LoginOutcome(
    session: AuthSession(
      accessToken: 'eyJ0eXAiOiJKV1Qi…',
      refreshToken: 'rt_9f3c…',
      expiresInSeconds: 900,
      user: AuthUser(id: '01M5Z7…', name: 'أحمد', emailVerified: true),
    ),
    flags: FeatureFlags({'ask': true}),
  );

  group('session response (§8.2 login; §8.3 register, §8.2 restore, §8.4 reset share this shape)', () {
    test('fromJson reads every documented field', () {
      final dto = parseSession(loginResponseJson).data;

      expect(dto.accessToken, 'eyJ0eXAiOiJKV1Qi…');
      expect(dto.refreshToken, 'rt_9f3c…');
      expect(dto.expiresIn, 900);
      expect(dto.user.id, '01M5Z7…');
      expect(dto.user.name, 'أحمد');
      expect(dto.user.email, isNull);
      expect(dto.user.emailVerified, isTrue);
      expect(dto.features.version, 14);
    });

    test('toDomain builds the LoginOutcome with a null email and mapped flags', () {
      expect(parseSession(loginResponseJson).data.toDomain(), expectedLoginOutcome);
    });
  });

  group('profile response (§8.7)', () {
    test('fromJson reads onboarded and ignores the other fields', () {
      final dto = DataEnvelope.fromJson(
        decode(profileResponseJson),
        (data) => ProfileDto.fromJson(data as Map<String, dynamic>),
      ).data;

      expect(dto.onboarded, isTrue);
      expect(dto.toDomain(), isTrue);
    });
  });

  group('verify email response (§8.5)', () {
    test('fromJson and toDomain', () {
      final dto = DataEnvelope.fromJson(
        decode(verifyResponseJson),
        (data) => VerifiedEmailDto.fromJson(data as Map<String, dynamic>),
      ).data;

      expect(dto.email, 'ahmed@example.com');
      expect(dto.emailVerified, isTrue);
      expect(
        dto.toDomain(),
        const VerifiedEmail(email: 'ahmed@example.com', emailVerified: true),
      );
    });
  });

  group('request bodies use the documented field names', () {
    test('register (§8.3)', () {
      expect(
        const RegisterRequest(
          name: 'أحمد المصري',
          email: 'ahmed@example.com',
          password: 'at-least-8-chars',
          locale: 'ar',
          digits: 'arabic',
        ).toJson(),
        {
          'name': 'أحمد المصري',
          'email': 'ahmed@example.com',
          'password': 'at-least-8-chars',
          'locale': 'ar',
          'digits': 'arabic',
        },
      );
    });

    test('restore (§8.2) sends restore_token', () {
      expect(
        const RestoreAccountRequest(restoreToken: 'restore-token').toJson(),
        {'restore_token': 'restore-token'},
      );
    });

    test('login, forgot, reset and verify', () {
      expect(
        const LoginRequest(email: 'ahmed@example.com', password: 'test-password-1').toJson(),
        {'email': 'ahmed@example.com', 'password': 'test-password-1'},
      );
      expect(
        const ForgotPasswordRequest(email: 'ahmed@example.com').toJson(),
        {'email': 'ahmed@example.com'},
      );
      expect(
        const ResetPasswordRequest(token: 'reset-token', password: 'new-password').toJson(),
        {'token': 'reset-token', 'password': 'new-password'},
      );
      expect(
        const VerifyEmailRequest(token: 'verify-token').toJson(),
        {'token': 'verify-token'},
      );
    });
  });
}
