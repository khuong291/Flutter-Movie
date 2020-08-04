import 'package:flutter/material.dart';
import 'package:movie_app/model/cast_detail_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class CastDetailBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<CastDetailResponse> _subject =
  BehaviorSubject<CastDetailResponse>();

  getCastDetail(int id) async {
    CastDetailResponse response = await _repository.getCastDetail(id);
    _subject.sink.add(response);
  }

  void drainStream(){ _subject.value = null; }
  @mustCallSuper
  void dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<CastDetailResponse> get subject => _subject;

}
final castDetailBloc = CastDetailBloc();