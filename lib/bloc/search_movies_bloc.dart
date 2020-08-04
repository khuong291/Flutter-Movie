import 'package:movie_app/model/movie_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchedMoviesBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
  BehaviorSubject<MovieResponse>();

  searchMovies(String q) async {
    MovieResponse response = await _repository.searchMovies(q);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;

}
final searchedMoviesBloc = SearchedMoviesBloc();