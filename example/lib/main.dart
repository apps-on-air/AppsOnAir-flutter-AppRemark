import 'package:appsonair_flutter_appremark/app_remark_service.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: const DemoApp(),
      ),
    );
  }
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  ShakeSensitivity _selectedSensitivity = ShakeSensitivity.high;

  @override
  void initState() {
    super.initState();
    _initializeAppRemark(_selectedSensitivity);
  }

  Future<void> _initializeAppRemark(ShakeSensitivity sensitivity) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    await AppRemarkService.initialize(
      context,
      shakeSensitivity: sensitivity,
      options: {
        "pageBackgroundColor": "#70d20f",
        "appBarBackgroundColor": "#70d20f",
        "descriptionLabelText": "Add description here.",
        "appBarTitleColor": "#FFFFFF",
        "remarkTypeLabelText": "Add Remark.",
        "descriptionHintText": "Add description.",
        "descriptionMaxLength": 120,
        "buttonText": "Submit Remark",
        "buttonTextColor": "#000000",
        "labelColor": "#FFFFFF",
        "buttonBackgroundColor": "#FFFFFF",
        "inputTextColor": "#000000",
        "hintColor": "#000000",
        "appBarTitleText": "AppRemark",
      },
      onRemarkResponse: (result) {
        // Handle your app remark status here..
      },
    );
    await AppRemarkService.setAdditionalMetaData(
      extraPayload: {
        "userName": "USER_NAME",
        "userId": "USER_ID",
        "openUsingShake": "true",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Shake Sensitivity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            DropdownButton<ShakeSensitivity>(
              value: _selectedSensitivity,
              items: ShakeSensitivity.values
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(_sensitivityLabel(s)),
                    ),
                  )
                  .toList(),
              onChanged: (sensitivity) {
                if (sensitivity == null) return;
                setState(() => _selectedSensitivity = sensitivity);
                _initializeAppRemark(sensitivity);
              },
            ),
            const SizedBox(height: 8),
            Text(
              _sensitivityDescription(_selectedSensitivity),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await AppRemarkService.setAdditionalMetaData(
                  extraPayload: {
                    "userName": "USER_NAME",
                    "userId": "USER_ID",
                    "openUsingShake": "false",
                  },
                );
                if (!context.mounted) return;
                await AppRemarkService.addRemark(context);
              },
              child: const Text('Add Remark'),
            ),
          ],
        ),
      ),
    );
  }

  String _sensitivityLabel(ShakeSensitivity sensitivity) {
    switch (sensitivity) {
      case ShakeSensitivity.veryLow:
        return 'Very Low';
      case ShakeSensitivity.low:
        return 'Low';
      case ShakeSensitivity.medium:
        return 'Medium';
      case ShakeSensitivity.high:
        return 'High';
      case ShakeSensitivity.veryHigh:
        return 'Very High';
    }
  }

  String _sensitivityDescription(ShakeSensitivity sensitivity) {
    switch (sensitivity) {
      case ShakeSensitivity.veryLow:
        return 'Very hard, deliberate shake required';
      case ShakeSensitivity.low:
        return 'Firm shake required';
      case ShakeSensitivity.medium:
        return 'Normal shake (default)';
      case ShakeSensitivity.high:
        return 'Light shake triggers feedback';
      case ShakeSensitivity.veryHigh:
        return 'Any motion triggers feedback';
    }
  }
}
