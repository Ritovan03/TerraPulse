import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leaf_lens/controllers/gemini_controller.dart';
import 'package:leaf_lens/pages/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final dotenv = DotEnv();
  await dotenv.load(fileName: ".env");
  String APIKEY = dotenv.get('GEMINI-APIKEY');
  if (APIKEY.isEmpty) {
    throw Exception("API key not found or empty in .env file");
  }
  Gemini.init(apiKey: APIKEY);
  Get.put(GeminiChatController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, child) => GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(), // Navigate to the Login Screen first
      ),
    );
  }
}

