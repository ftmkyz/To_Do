import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/Models/todo_model.dart';
import 'package:to_do_app/widgets/listview.dart';
import 'dart:convert' show json;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<Todo> _data = [];
  Color backgroundColor = const Color.fromARGB(255, 228, 213, 183);
  Color themeColor = const Color.fromARGB(255, 135, 174, 115);
  Color textColor = const Color.fromARGB(155, 0, 33, 71);
  Color buttonbackground = const Color.fromARGB(255, 177, 86, 36);

  @override
  void initState() {
    super.initState();
    _loadJsonData();
    _loadFromSharedPreferences();
  }
   Future<void> _loadFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonValue = prefs.getString('todoList');
    if (jsonValue != null) {
      List<dynamic> jsonData = json.decode(jsonValue);
      setState(() {
        _data = jsonData.map((item) => Todo.fromJson(item)).toList();
      });
    }
  }

  Future<void> _loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _data = jsonData.map((item) => Todo.fromJson(item)).toList();
    });
  }

  void _addTodo(String content) {
    final newTodo = Todo(content: content, iscomplete: false);
    setState(() {
      _data.add(newTodo);
      _saveToJson();
      _controller.clear();
    });
  }

  void _saveToJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonData =
        _data.map((todo) => todo.toJson()).toList();
    String jsonString = json.encode(jsonData);
    prefs.setString('todoList', jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 90,
          title: Column(
            children: [
              // SizedBox(height: 8.0),
              Text(
                'To-Do App',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          backgroundColor: themeColor),
      body: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 190,
            backgroundColor: themeColor,
            title: Container(
              margin: const EdgeInsets.only(left: 6, right: 6),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                controller: _controller,
                decoration: InputDecoration(
                  fillColor: backgroundColor,
                  labelStyle: TextStyle(color: textColor),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: textColor, width: 0.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelText: 'Add new task',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _addTodo(_controller.text);
                    },
                    icon: const Icon(Icons.add),
                    color: textColor,
                  ),
                ),
              ),
            ),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Text("All Task"),
                ),
                Tab(
                  icon: Text("Pending Task"),
                ),
                Tab(
                  icon: Text("Completed"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListViewWidget(
                todos: _data,
              ),
              ListViewWidget(
                todos: _data,
                type:false,
              ),
              ListViewWidget(
                todos: _data,
                type:true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
