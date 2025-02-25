import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  // Configures window size on desktop
  setupWindow();
  
  runApp(
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}


class Counter with ChangeNotifier {
  int value = 0;
  void increment() {
    // Only increment if value is less than 99.
    if (value < 99) {
      value += 1;
      notifyListeners();
    }
  }
  void decrement() {
    // Only decrement if value is more than 0.
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }
  void setAge(int newAge) {
    value = newAge.clamp(0,99).toInt();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
      ),
    home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Color getBackgroundColor(int age) {
    if (age <= 12) {
      return Colors.lightBlue;
    } else if (age <= 19) {
      return Colors.lightGreen;
    } else if (age <= 30) {
      return Colors.yellow.shade200;
    } else if (age <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey.shade300;
    }
  }

  String getMessage(int age) {
    if (age <= 12) {
      return "You're a child!";
    } else if (age <= 19) {
      return "Teen!";
    } else if (age <= 30) {
      return "Young adult!";
    } else if (age <= 50) {
      return "Regular adult!";
    } else {
      return "Golden years!";
    }  
  }

  Color getProgressColor(int age) {
    if (age <= 33) {
      return Colors.green;
    } else if (age <= 67) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        int age = counter.value;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Age Counter'),
            ),
          
          // Set bg color
          body: Container(
            color: getBackgroundColor(age),
            child: Center(
              child: Column(
  
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I am ${counter.value} years old!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    getMessage(age),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  // Button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        // Increase age
                        ElevatedButton.icon(
                          onPressed: () {
                            var counter = context.read<Counter>();
                            counter.increment();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Increase age.'),
                        ),
                        const SizedBox(width: 20),
                        // Decrease age
                        ElevatedButton.icon(
                          onPressed: () {
                            var counter = context.read<Counter>();
                            counter.decrement();
                          },
                          icon: const Icon(Icons.remove),
                          label: const Text('Reduce age.'),
                        ),
                      ],
                    ),
                    // Slider
                    const SizedBox(height: 20),
                    Slider(
                      value: age.toDouble(),
                      min: 0,
                      max: 99,
                      divisions: 99,
                      label: age.toString(),
                      onChanged: (double newValue){
                        counter.setAge(newValue.toInt());
                      },
                    ),
                    const SizedBox(height: 20),
                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: LinearProgressIndicator(
                        value: age / 99,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation(getProgressColor(age)),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
            ),
          ),
        );
      },
    );
  }
}
