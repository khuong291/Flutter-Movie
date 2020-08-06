import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/bloc/get_cast_detail_bloc.dart';
import 'package:movie_app/model/cast_detail_response.dart';
import 'package:movie_app/style/theme.dart' as Style;

class CastDetailScreen extends StatefulWidget {
  final int castId;
  final String castName;

  CastDetailScreen({Key key, @required this.castId, this.castName})
      : super(key: key);

  @override
  _CastDetailScreenState createState() =>
      _CastDetailScreenState(castId, castName);
}

class _CastDetailScreenState extends State<CastDetailScreen> {
  final int castId;
  final String castName;

  _CastDetailScreenState(this.castId, this.castName);

  @override
  void initState() {
    super.initState();
    castDetailBloc.getCastDetail(castId);
  }

  @override
  void dispose() {
    castDetailBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.Colors.mainColor,
        appBar: AppBar(
          backgroundColor: Style.Colors.mainColor,
          centerTitle: true,
          title: Text(castName),
        ),
        body: StreamBuilder<CastDetailResponse>(
          stream: castDetailBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastDetailResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(snapshot.data.error);
              }
              return _buildHomeWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ));
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
    final screenWidth = MediaQuery.of(context).size.width;
    final cast = data.cast;
    final movies = data.movies;
    print(movies.length);
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(cast.birthday);
    String birthDate = DateFormat("dd/MM/yyyy").format(tempDate);
    String gender = (cast.gender == 0) ? "Female" : "Male";

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Flexible(
              flex: 1,
              child: Container(
                  height: screenWidth / 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage("https://image.tmdb.org/t/p/w200/" +
                            cast.profileImg)),
                  ))),
          SizedBox(width: 20.0),
          Flexible(
              flex: 2,
              child: Container(
                height: screenWidth / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Gender: " + gender,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0)),
                    Text("Known for: " + cast.known,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0)),
                    Text("Birthday: " + birthDate,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0)),
                    Text("Place of Birth: " + cast.placeOfBirth,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0)),
                    Text("Popularity: " + cast.popularity.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0)),
                  ],
                ),
              ))
        ]),
        SizedBox(height: 20.0),
        Text("Known for:",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0)),
        SizedBox(height: 8.0),
        Container(
          height: 270.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: movies[index].id,
                      child: Container(
                          width: 120.0,
                          height: 180.0,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200/" +
                                        movies[index].poster)),
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        style: TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        movies[index].character,
                        maxLines: 2,
                        style: TextStyle(
                            height: 1.4,
                            color: Colors.yellowAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Text("Biography:",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0)),
        SizedBox(height: 8.0),
        Text(cast.biography,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12.0))
      ],
    );
  }
}
