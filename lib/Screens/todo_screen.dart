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
      appBar: AppBar(
        title: const Text('To-Do App'),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 18.0),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  labelText: 'Add new task',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _saveTodo(_controller.text);
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 28.0),
              for (var i = 0; i < todos.length; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          todos[i],
                          style: const TextStyle(fontSize: 24.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                // Button action
                              },
                              icon: const Icon(Icons.delete, size: 22),
                            ),
                            IconButton(
                              onPressed: () {
                                // Button action
                              },
                              icon: const Icon(Icons.check, size: 22),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ]),
      ),
    );
  }

  Future<void> _saveTodo(String todo) async {
    setState(() {
      todos.add(todo);
      // print(todos);
    });
    await _prefs.setStringList('todos', todos);
  }
}
