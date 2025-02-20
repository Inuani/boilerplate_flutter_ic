import 'package:agent_dart/agent/auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/counter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  int _counter = 0;
  bool _loading = false;
  // setup state class variable;
  Counter? counter;

  @override
  void initState() {
    initCounter();
    super.initState();
  }

  Future<void> initCounter({Identity? identity}) async {
    // initialize counter, change canister id here
    counter = Counter(
        canisterId: 'be2us-64aaa-aaaaa-qaabq-cai',
        url: 'http://localhost:8000');
    // set agent when other paramater comes in like new Identity
    await counter?.setAgent(newIdentity: identity);
    await getValue();
  }

  // get value from canister
  Future<void> getValue() async {
    var counterValue = await counter?.getValue();
    setState(() {
      _counter = counterValue ?? _counter;
      _loading = false;
    });
  }

  // increment counter
  Future<void> _incrementCounter() async {
    setState(() {
      _loading = true;
    });
    await counter?.increment();
    await getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
