import 'dart:convert';

class PendingAction {
  final List<int> favorites;
  final DateTime timestamp;

  PendingAction({
    required this.favorites,
    required this.timestamp,
  });

  factory PendingAction.fromRawJson(String str) {
    return PendingAction.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory PendingAction.fromJson(Map<dynamic, dynamic> json) => PendingAction(
        favorites: List<int>.from(json["favorites"].map((x) => x)),
        timestamp: DateTime.parse(json["timestamp"]).toUtc(),
      );

  Map<String, dynamic> toJson() => {
        "favorites": List<dynamic>.from(favorites.map((x) => x)),
        "timestamp": timestamp.toUtc().toString(),
      };
}
