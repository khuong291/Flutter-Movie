import 'package:movie_app/model/person.dart';

import 'cast_movie.dart';

class CastDetailResponse {
  final Person cast;
  final List<CastMovie> movies;
  final String error;

  CastDetailResponse(this.cast, this.movies, this.error);

  CastDetailResponse.fromJson(Map<String, dynamic> json, Map<String, dynamic> moviesJson)
      : cast = Person.fromJson(json),
        movies =
        (moviesJson["cast"] as List).map((i) => CastMovie.fromJson(i)).toList(),
        error = "";

  CastDetailResponse.withError(String errorValue)
      : cast = Person(null, null, null, null, null, null, null, null, null),
        movies = List(),
        error = errorValue;
}