class CastMovie {
  final int id;
  final String title;
  final String poster;
  final String character;

  CastMovie(this.id, this.title, this.poster, this.character);

  CastMovie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        poster = json["poster_path"] ?? "",
        character = json["character"];
}
