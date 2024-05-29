class Todo {
  String content;
  bool iscomplete;

  Todo({required this.content, required this.iscomplete});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      content: json['content'],
      iscomplete: json['iscomplete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'iscomplete': iscomplete,
    };
  }
}