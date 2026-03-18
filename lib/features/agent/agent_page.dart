import 'package:flutter/material.dart';

class AgentPage extends StatelessWidget {
  const AgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // #26: Chat page handles keyboard inset manually
      // so MiniPlayer stays visible above keyboard
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Agent'),
      ),
      body: const Center(
        child: Text('Agent — Coming Soon'),
      ),
    );
  }
}
