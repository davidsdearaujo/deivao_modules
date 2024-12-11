import 'package:example/features/core/core_module.dart';
import 'package:flutter/material.dart';
import 'package:modular_di/modular_di.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late HttpClient httpClient;

  Future<String>? messageFuture;

  @override
  void didChangeDependencies() {
    httpClient = Module.get<HttpClient>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message')),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            tooltip: 'Dispose $CoreModule',
            heroTag: 'dispose-core-module',
            onPressed: () => ModulesManager.instance.disposeModule<CoreModule>(),
            child: const Icon(Icons.delete_forever),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            tooltip: 'Profile',
            heroTag: 'profile',
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
            child: const Icon(Icons.person_outlined),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            tooltip: 'Load Message',
            onPressed: _loadMessage,
            child: const Icon(Icons.email_outlined),
          ),
        ],
      ),
      body: FutureBuilder(
          future: messageFuture,
          builder: (context, snapshot) {
            return switch (snapshot.connectionState) {
              ConnectionState.waiting => const Center(child: CircularProgressIndicator()),
              ConnectionState.done when snapshot.hasData => Center(child: Text(snapshot.data!)),
              ConnectionState.done when snapshot.hasError => Center(child: Text('${snapshot.error}')),
              _ => const Center(child: Text('Tap on the button to see the message...')),
            };
          }),
    );
  }

  void _loadMessage() {
    setState(() {
      messageFuture = httpClient.get('https://api.example.com/message');
    });
  }
}