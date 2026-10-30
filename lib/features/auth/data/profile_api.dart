import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/constants/di_names.dart';
import '../../../core/network/data_envelope.dart';
import 'models/profile_dto.dart';

part 'profile_api.g.dart';

@lazySingleton
@RestApi()
abstract class ProfileApi {
  @factoryMethod
  factory ProfileApi(@Named(DiNames.apiDio) Dio dio) = _ProfileApi;

  @GET(ApiPaths.profile)
  Future<DataEnvelope<ProfileDto>> getProfile();
}
