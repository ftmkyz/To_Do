import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/Models/todo_model.dart';
import 'dart:convert' show json;

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({Key? key, required this.todos, this.type})
      : super(key: key);

  final List<Todo> todos;
  final bool? type;

  @override
  State<ListViewWidget> createState() => _ListViewState();
}

class _ListViewState extends State<ListViewWidget> {
  List<Todo> filterTodo = [];
  Color backgroundColor = const Color.fromARGB(255, 228, 213, 183);
  Color themeColor = const Color.fromARGB(255, 135, 174, 115);
  Color textColor = const Color.fromARGB(155, 0, 33, 71);
  Color buttonbackground = const Color.fromARGB(255, 177, 86, 36);
  final bool _visible = true;
  List<int> filteredIndices=[];
  late int indexInItems ;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonValue = prefs.getString('todoList');
    if (jsonValue != null) {
      List<dynamic> decodedData = json.decode(jsonValue);
      List<Todo> jsonData =
          decodedData.map((dynamic item) => Todo.fromJson(item)).toList();
      setState(() {
        if (widget.type == null) {
          filterTodo = jsonData;
          filteredIndices = filterTodo.map((item) => decodedData.indexOf(item)).toList();
        } else {
          filterTodo =
              jsonData.where((todo) => todo.iscomplete == widget.type).toList();
          filteredIndices = filterTodo.map((item) => jsonData.indexOf(item)).toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filterTodo.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                margin: const EdgeInsets.only(left: 3, right: 3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: buttonbackground,
                    width: 0.0,
                  ),
                  // borderRadius: BorderRadius.circular(30.0),
                  color: backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: buttonbackground.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      filterTodo[index].content,
                      style: TextStyle(fontSize: 24.0, color: textColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            _deleteTodo(index);
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 22,
                            color: buttonbackground,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _completeTodo(index);
                          },
                          icon: Icon(
                            Icons.check,
                            size: 22,
                            color: buttonbackground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveToJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonData =
        widget.todos.map((todo) => todo.toJson()).toList();
    String jsonString = json.encode(jsonData);
    prefs.setString('todoList', jsonString);
    _initializePrefs();
  }

  Future<void> _deleteTodo(int id) async {
    setState(() {
      //sorun var
      if(widget.type==null){
        indexInItems = id;
      }
      else{
        indexInItems = filteredIndices[id];
      }
      
      widget.todos.removeAt(indexInItems);
      _saveToJson();
    });
    // await _prefs.setStringList('todos', widget.todos);
  }

  Future<void> _completeTodo(int id) async {
    setState(() {
      //sorun var
      if(widget.type==null){
        indexInItems = id;
      }
      else{
        indexInItems = filteredIndices[id];
      }
      widget.todos[indexInItems].iscomplete = true;
      _saveToJson();
    });
  }
}
