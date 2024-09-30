import 'package:flutter/material.dart';
import 'package:inventaris/screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        // primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ), //TextStyle
        ),
        scaffoldBackgroundColor: Colors.grey.shade200,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent).copyWith(
          inversePrimary: Color.fromRGBO(129, 193, 231, 95),

          onBackground: Colors.white,
          // inverseSurface: Colors.black54,
          // Text input
          onSurface: Colors.black87,
          primary: Colors.black87,
          // hint input
          onSurfaceVariant: Colors.lightBlueAccent,
          // linhas
          outline: Colors.indigo.shade900,
          // AppBar
          surface: Colors.white,
          tertiary: Colors.black12,

          secondary: Colors.blue,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black, fontStyle: FontStyle.italic, fontSize: 20),
          bodyMedium: TextStyle(
              color: Color.fromARGB(250, 26, 35, 126),
              fontWeight: FontWeight.bold,
              fontSize: 40),
          displayLarge: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 34,
          ),
          displayMedium: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 43,
          ),
          displaySmall: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 58,
          ),

          titleLarge: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 36,
          ),
          titleMedium: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 50,
          ),
          titleSmall: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 60,
          ),

          labelLarge: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 70,
          ),
          labelMedium: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 75,
          ),
          labelSmall: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 85,
              color: Colors.black54),
          // bodyMedium: GoogleFonts.merriweather(),
        ),
      ),
      home: const DashoardTab(),
    );
  }
}
