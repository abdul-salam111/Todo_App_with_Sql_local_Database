class NotesModal {
  int? id;
  String? title;
  String? description;
  DateTime? time;
  NotesModal({this.id, this.title, this.description, this.time});
  factory NotesModal.fromMap(Map<String, dynamic> json) {
    return NotesModal(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        time: DateTime.parse(json['time']));
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time.toString(),
    };
  }
}
