import 'package:movie_app/model/movie_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class SearchedMoviesBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<Tuple2<MovieResponse, bool>> _subject =
      BehaviorSubject<Tuple2<MovieResponse, bool>>();

  searchMovies(String q) async {
    _subject.sink.add(Tuple2(MovieResponse([], ""), true));
    MovieResponse response = await _repository.searchMovies(q);
    _subject.sink.add(Tuple2(response, false));
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Tuple2<MovieResponse, bool>> get subject => _subject;
}
