import 'package:flutter/material.dart';

class WordsPage extends StatelessWidget {
  const WordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Words'),
      ),
      body: const Center(
        child: Text('Words — Coming Soon'),
      ),
    );
  }
}
