import 'package:flutter/material.dart';

/// A new page for the "Waving" mini‑game.
///
/// This page is intentionally lightweight – it only provides the UI shell.
/// The actual wave‑detection logic (clean‑architecture layers) can be
/// wired up later without touching any existing code.
class WaveGamePage extends StatelessWidget {
  const WaveGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👋 Wave Game')),
      body: const Center(
        child: Text(
          'Wave detection will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
