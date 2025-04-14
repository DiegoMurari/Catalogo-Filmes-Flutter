import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/movie_model.dart';
import 'pages/home_page.dart';
import 'pages/detail_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key); // Usando o super

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Filmes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(
              toggleTheme: toggleTheme,
              isDark: isDark,
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final movie = settings.arguments as Movie;
          return MaterialPageRoute(
            builder: (context) => DetailsPage(movie: movie),
          );
        }
        return null;
      },
    );
  }
}
