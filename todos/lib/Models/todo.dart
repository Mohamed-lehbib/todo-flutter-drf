class Todo {
  int id;
  String title;
  String desc;
  bool isDone;
  String date;
  Todo(
      {required this.id,
      required this.title,
      required this.desc,
      required this.isDone,
      required this.date});

  // Convert a Todo instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'status': isDone,
      'date': date,
    };
  }
}
