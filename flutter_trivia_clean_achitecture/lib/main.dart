import 'package:flutter/material.dart';
import 'package:flutter_trivia_clean_achitecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  //? We may not necessary to await for necessary di is called
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Number Trivia',
      theme: theme.copyWith(
        primaryColor: Colors.green.shade800,
        colorScheme:
            theme.colorScheme.copyWith(secondary: Colors.green.shade600),
      ),
      home: NumberTriviaPage(),
    );
  }
}
