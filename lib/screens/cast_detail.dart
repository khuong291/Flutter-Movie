import 'dart:ui';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/bloc/get_cast_detail_bloc.dart';
import 'package:movie_app/bloc/get_movie_videos_bloc.dart';
import 'package:movie_app/model/cast_detail_response.dart';
import 'package:movie_app/model/person.dart';
import 'package:movie_app/model/person_response.dart';

class CastDetailScreen extends StatefulWidget {
  final Person person;

  CastDetailScreen({Key key, @required this.person}) : super(key: key);

  @override
  _CastDetailScreenState createState() => _CastDetailScreenState(person);
}

class _CastDetailScreenState extends State<CastDetailScreen> {
  final Person person;

  _CastDetailScreenState(this.person);

  @override
  void initState() {
    super.initState();
    castDetailBloc.getCastDetail(person.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CastDetailResponse>(
      stream: castDetailBloc.subject.stream,
      builder: (context, AsyncSnapshot<CastDetailResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildHomeWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 4.0,
          ),
        )
      ],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildHomeWidget(CastDetailResponse data) {
    return Center(child: Text(data.cast.biography));
  }
}
