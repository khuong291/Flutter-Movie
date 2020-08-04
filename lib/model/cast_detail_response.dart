import 'package:movie_app/model/person.dart';

class CastDetailResponse {
  final Person cast;
  final String error;

  CastDetailResponse(this.cast, this.error);

  CastDetailResponse.fromJson(Map<String, dynamic> json)
      : cast = Person.fromJson(json),
        error = "";

  CastDetailResponse.withError(String errorValue)
      : cast = Person(null, null, null, null, null, null, null),
        error = errorValue;
}