import 'package:flutter/material.dart';

class MellivoraApp extends StatelessWidget {
  const MellivoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mellivora English',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Mellivora English — Coming Soon 🎵'),
        ),
      ),
    );
  }
}
