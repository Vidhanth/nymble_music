class User {
  final String id;
  final List<int> favorites;

  User({required this.id, required this.favorites});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        favorites: List<int>.from(json["favorites"].map((x) => x)),
      );
}
