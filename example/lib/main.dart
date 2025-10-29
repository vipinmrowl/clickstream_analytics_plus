import 'package:flutter/material.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _clickstream = ClickstreamAnalyticsPlus();
  bool _initialized = false;
  String _status = 'Not initialized yet';

  @override
  void initState() {
    super.initState();
    _initializeClickstream();
  }

  Future<void> _initializeClickstream() async {
    final ok = await _clickstream.initialize(
      appId: 'TestAppDev',
      endpoint: 'https://events.drowl.com/collect',
    );
    if (ok) {
      await _clickstream.setUserId('demo_user_123');
      setState(() {
        _initialized = true;
        _status = 'Clickstream initialized successfully';
      });
    } else {
      setState(() => _status = 'Initialization failed');
    }
  }

  Future<void> _recordTestEvent(String eventName) async {
    try {
      await _clickstream.recordEvent(
        eventName,
        attributes: {
          'timestamp': DateTime.now().toIso8601String(),
          'screen': 'home',
        },
      );
      setState(() => _status = 'Recorded event: $eventName');
    } catch (e) {
      setState(() => _status = 'Error recording event: $e');
    }
  }

  Future<void> _flush() async {
    try {
      await _clickstream.flushEvents();
      setState(() => _status = 'Flushed pending events');
    } catch (e) {
      setState(() => _status = 'Error flushing events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Clickstream Analytics Demo')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              if (_initialized) ...[
                ElevatedButton(
                  onPressed: () => _recordTestEvent('button_click'),
                  child: const Text('Record Event: button_click'),
                ),
                ElevatedButton(
                  onPressed: _flush,
                  child: const Text('Flush Events'),
                ),
              ] else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
