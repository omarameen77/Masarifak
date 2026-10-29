import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/data_envelope.dart';
import 'models/profile_dto.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio) = _ProfileApi;

  @GET(ApiPaths.profile)
  Future<DataEnvelope<ProfileDto>> getProfile();
}
