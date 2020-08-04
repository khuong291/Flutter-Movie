class Person {
  final int id;
  final double popularity;
  final String name;
  final String profileImg;
  final String known;
  final String biography;
  final String birthday;

  Person(this.id, this.popularity, this.name, this.profileImg, this.known,
      this.biography, this.birthday);

  Person.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        popularity = json["popularity"],
        name = json["name"],
        profileImg = json["profile_path"],
        known = json["known_for_department"],
        biography = json["biography"] ?? "",
        birthday = json["birthday"] ?? "";
}
