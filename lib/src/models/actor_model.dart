class Cast {
  List<Actor> actors = [];

  Cast.fromJsonList(List<dynamic> list) {
    if (list == null) return;

    list.forEach((item) {
      final actor = Actor.fromJsonMap(item);

      actors.add(actor);
    });
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
  }

  getPhoto() {
    if (profilePath == null) {
      return 'https://d3om0haemn8azm.cloudfront.net/s/static/images/no-avatar-20170720.png';
    }

    return 'https://image.tmdb.org/t/p/w500/$profilePath';
  }
}
