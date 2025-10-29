import 'package:flutter/material.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus.dart';

void main() {
  runApp(const ClickstreamDemoApp());
}

class ClickstreamDemoApp extends StatefulWidget {
  const ClickstreamDemoApp({super.key});

  @override
  State<ClickstreamDemoApp> createState() => _ClickstreamDemoAppState();
}

class _ClickstreamDemoAppState extends State<ClickstreamDemoApp>
    with WidgetsBindingObserver {
  final _clickstream = ClickstreamAnalyticsPlus();
  int _selectedIndex = 0;
  bool _initialized = false;
  String _status = 'SDK not initialized';
  String? _sdkVersion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Lifecycle handling for session management
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_initialized) return;
    if (state == AppLifecycleState.paused) {
      _clickstream.pauseSession();
    } else if (state == AppLifecycleState.resumed) {
      _clickstream.resumeSession();
    }
  }

  // Initialization
  Future<void> _initializeSDK() async {
    final ok = await _clickstream.initialize(
      appId: 'TestAppDev',
      endpoint: 'https://events.drowl.com/collect',
      logEvents: true,
      compressEvents: true,
      sessionTimeoutMs: 1800000,
      sendEventIntervalMs: 10000,
      initialGlobalAttributes: {'platform': 'flutter', 'build': 'demo'},
    );

    if (ok) {
      await _clickstream.setUserId('demo_user_123');
      await _clickstream.setUserAttributes({
        'plan': 'Pro',
        'region': 'US',
        'subscribed': true,
      });
      final sdkVer = await _clickstream.getSdkVersion();
      setState(() {
        _initialized = true;
        _status = '✅ Initialized successfully';
        _sdkVersion = sdkVer;
      });
    } else {
      setState(() => _status = '❌ Initialization failed');
    }
  }

  // Record event
  Future<void> _recordEvent(String eventName) async {
    await _clickstream.recordEvent(
      eventName,
      attributes: {
        'timestamp': DateTime.now().toIso8601String(),
        'screen': 'events_tab',
        'action': eventName,
      },
    );
    setState(() => _status = 'Recorded event: $eventName');
  }

  // Flush
  Future<void> _flush() async {
    await _clickstream.flushEvents();
    setState(() => _status = 'Flushed events');
  }

  Widget _buildHomeTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (!_initialized)
              ElevatedButton(
                onPressed: _initializeSDK,
                child: const Text('Initialize SDK'),
              )
            else
              Column(
                children: [
                  Text('SDK Version: $_sdkVersion'),
                  const SizedBox(height: 8),
                  const Text('App is initialized'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_initialized)
              const Text('Initialize the SDK first')
            else ...[
              ElevatedButton(
                onPressed: () => _recordEvent('button_click'),
                child: const Text('Record button_click'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _recordEvent('screen_view'),
                child: const Text('Record screen_view'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _flush,
                child: const Text('Flush Events'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_initialized)
              const Text('Initialize the SDK first')
            else ...[
              ElevatedButton(
                onPressed: () async {
                  await _clickstream.setUserId(
                    'new_user_${DateTime.now().millisecondsSinceEpoch}',
                  );
                  setState(() => _status = 'User ID updated');
                },
                child: const Text('Set New User ID'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await _clickstream.setUserAttributes({
                    'tier': 'Gold',
                    'updated': DateTime.now().toIso8601String(),
                  });
                  setState(() => _status = 'User attributes updated');
                },
                child: const Text('Update User Attributes'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await _clickstream.setGlobalAttributes({
                    'last_screen': 'user_tab',
                    'last_update': DateTime.now().toIso8601String(),
                  });
                  setState(() => _status = 'Global attributes updated');
                },
                child: const Text('Update Global Attributes'),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [_buildHomeTab(), _buildEventsTab(), _buildUserTab()];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Clickstream Analytics+ Demo'),
          centerTitle: true,
        ),
        body: tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Events',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
          ],
        ),
      ),
    );
  }
}
