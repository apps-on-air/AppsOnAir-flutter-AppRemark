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
      if (!mounted) return;
      await AppRemarkService.initialize(context, options: {
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
        "appBarTitleText": "AppRemark"
      });
      await AppRemarkService.setAdditionalMetaData(extraPayload: {
        "userName": "USER_NAME",
        "userId": "USER_ID",
        "openUsingShake": "true",
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
            // to open "Add Remark" screen manually
            await AppRemarkService.setAdditionalMetaData(extraPayload: {
              "userName": "USER_NAME",
              "userId": "USER_ID",
              "openUsingShake": "false",
            });
            if (!context.mounted) return;
            await AppRemarkService.addRemark(context);
          },
          child: const Text('Add Remark'),
        ),
      ),
    );
  }
}
