import 'package:movie_app/model/genre_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GenresListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<GenreResponse> _subject =
      BehaviorSubject<GenreResponse>();

  getGenres() async {
    GenreResponse response = await _repository.getGenres();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GenreResponse> get subject => _subject;
  
}
final genresBloc = GenresListBloc();