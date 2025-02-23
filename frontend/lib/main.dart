
// import 'package:flutter/material.dart';
// import 'package:agent_dart/agent_dart.dart';
// import 'counter.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ICP Counter',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const MyHomePage(title: 'ICP Counter'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   bool _loading = false;
//   Counter? counter;

//   @override
//   void initState() {
//     super.initState();
//     initCounter();
//   }

//   Future<void> initCounter({Identity? identity}) async {
//     setState(() => _loading = true);
//     counter = Counter(
//       canisterId: 'be2us-64aaa-aaaaa-qaabq-cai',
//       url: 'http://127.0.0.1:4943',
//     );
//     await counter?.setAgent(newIdentity: identity);
//     await getValue(); // Ensure initial value is fetched
//   }

//   Future<void> getValue() async {
//     if (counter == null) return; // Safety check
//     try {
//       final counterValue = await counter!.getValue();
//       setState(() {
//         _counter = counterValue;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _loading = false;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error fetching value: $e')),
//         );
//       });
//     }
//   }

//   Future<void> _incrementCounter() async {
//     if (counter == null) return; // Safety check
//     setState(() => _loading = true);
//     try {
//       await counter!.increment();
//       await getValue(); // Fetch the updated value after increment
//     } catch (e) {
//       setState(() {
//         _loading = false;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error incrementing: $e')),
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('The canister counter is now:'),
//             Text(
//               _loading ? 'loading...' : '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:agent_dart/agent_dart.dart';
import 'counter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICP Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'ICP Counter'),
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
  Counter? counter;

  @override
  void initState() {
    super.initState();
    initCounter();
  }

  Future<void> initCounter({Identity? identity}) async {
    setState(() => _loading = true);
    try {
      counter = Counter(
        canisterId: 'be2us-64aaa-aaaaa-qaabq-cai',
        url: 'http://127.0.0.1:4943',
      );
      await counter?.setAgent(newIdentity: identity);
      await getValue();
    } catch (e) {
      print('Error initializing counter: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing counter: $e')),
        );
      }
      setState(() => _loading = false);
    }
  }

  Future<void> getValue() async {
    try {
      final counterValue = await counter?.getValue();
      setState(() {
        _counter = counterValue ?? _counter;
        _loading = false;
      });
    } catch (e) {
      print('Error getting value: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting value: $e')),
        );
      }
      setState(() => _loading = false);
    }
  }

  Future<void> _incrementCounter() async {
    setState(() => _loading = true);
    try {
      await counter?.increment();
    } catch (e) {
      // print('Error incrementing: $e');
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Error incrementing: $e')),
      //   );
      // }
    }
    await getValue();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('The canister counter is now:'),
            Text(
              _loading ? 'loading...' : '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loading ? null : _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}