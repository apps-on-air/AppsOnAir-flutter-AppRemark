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
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
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
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () async {
      await AppRemarkService.initialize(context, options: {
        'pageBackgroundColor': '#FFC0CB',
        'descriptionMaxLength': 25,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AppRemarkService.addRemark(context);
          },
          child: const Text('Add Remark'),
        ),
      ),
    );
  }
}
