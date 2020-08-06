import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/movie_response.dart';
import 'package:movie_app/screens/detail_screen.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/bloc/search_movies_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchedMoviesBloc = SearchedMoviesBloc();
  final PublishSubject<String> _searchText = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    _searchText.stream
        .distinct()
        .debounceTime(Duration(milliseconds: 500))
        .listen((query) {
      if (query.length > 2) {
        _searchedMoviesBloc.searchMovies(query);
      }
    });
  }

  @override
  void dispose() {
    _searchedMoviesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.Colors.mainColor,
        appBar: AppBar(
            backgroundColor: Style.Colors.mainColor,
            centerTitle: true,
            title: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search your movies...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white30),
                ),
                style: TextStyle(color: Colors.white, fontSize: 16.0),
                onChanged: (query) => _searchText.add(query))),
        body: StreamBuilder<Tuple2<MovieResponse, bool>>(
          stream: _searchedMoviesBloc.subject.stream,
          builder:
              (context, AsyncSnapshot<Tuple2<MovieResponse, bool>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.item2) {
                return _buildLoadingWidget();
              }
              if (snapshot.data.item1.error != null &&
                  snapshot.data.item1.error.length > 0) {
                return _buildErrorWidget(snapshot.data.item1.error);
              }
              return _buildHomeWidget(snapshot.data.item1);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return SizedBox.shrink();
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

  Widget _buildHomeWidget(MovieResponse data) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 10) / 3;
    final itemHeight = itemWidth * 1.5 + 100;
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Movies",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: itemWidth / itemHeight,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: movies.map((movie) {
              return Container(
                width: itemWidth,
                height: itemWidth * 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: movie.id,
                        child: Container(
                            height: itemWidth * 1.5,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w200/" +
                                          movie.poster)),
                            )),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: Text(
                          movie.title,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            movie.rating.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          RatingBar(
                            itemSize: 8.0,
                            initialRating: movie.rating / 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              EvaIcons.star,
                              color: Style.Colors.secondColor,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList()),
      );
  }
}
