import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import './services/authProvider.dart';
import 'AuthScreen.dart';

import 'main_screen.dart';
import 'home_screen.dart';
// import './navigationScreen.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                home: auth.isAuth ? HomeScreen(cameras) : AuthScreen(),

                // home: Navigate(),
                routes: {
                  AuthScreen.routeName: (context) => AuthScreen(),
                  MainScreen.id: (context) => MainScreen(cameras),
                  //DemoScreen.id: (context) => DemoScreen(),
                },
              )),
    );
  }
}
