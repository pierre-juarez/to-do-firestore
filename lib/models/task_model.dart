import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String description;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;

  Task({this.id, required this.description, required this.isDone, required this.createdOn, required this.updatedOn});

  factory Task.fromJSON(Map<String, Object?> json) {
    return Task(
      id: json["id"] as String?,
      description: json["description"]! as String,
      isDone: json["isDone"]! as bool,
      createdOn: json["createdOn"]! as Timestamp,
      updatedOn: json["updatedOn"]! as Timestamp,
    );
  }

  Task copyWith({String? id, String? description, bool? isDone, Timestamp? createdOn, Timestamp? updatedOn}) {
    return Task(
      id: id ?? this.id,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  Map<String, Object?> toJSON() {
    return {
      if (id != null) "id": id,
      "description": description,
      "isDone": isDone,
      "createdOn": createdOn,
      "updatedOn": updatedOn,
    };
  }
}
