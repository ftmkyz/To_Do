import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences _prefs;
  final TextEditingController _controller = TextEditingController();
  List<String> todos = [];
  Color backgroundColor = const Color.fromARGB(255, 228,213,183);
  Color themeColor = const Color.fromARGB(255, 135,174,115);
  Color textColor = const Color.fromARGB(155, 0,33,71);
  Color buttonbackground = const Color.fromARGB(255, 177,86,36);
  final bool _visible = true;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      todos = _prefs.getStringList('todos') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 18.0),
            Container(
              margin: const EdgeInsets.only(left: 6, right: 6),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
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
                      _saveTodo(_controller.text);
                    },
                    icon: const Icon(Icons.add),
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonbackground,
                        foregroundColor: textColor),
                    child: const Text("All Task"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonbackground,
                        foregroundColor: textColor),
                    child: const Text("Pending Task"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonbackground,
                        foregroundColor: textColor),
                    child: const Text("Completed"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todos.length,
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            todos[index],
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
                                  // Button action
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
          ],
        ),
      ),
    );
  }

  Future<void> _saveTodo(String todo) async {
    setState(() {
      todos.add(todo);
      _controller.clear();
      // print(todos);
    });
    await _prefs.setStringList('todos', todos);
  }

  Future<void> _deleteTodo(int id) async {
    setState(() {
      todos.removeAt(id);
      // print(todos);
    });
    await _prefs.setStringList('todos', todos);
  }
}
