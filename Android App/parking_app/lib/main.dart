import 'package:firebase_auth/firebase_auth.dart';
import 'package:parking_app/screens/wrapper.dart';
import 'package:parking_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserParam?>.value(
      catchError: (_, __) => null,
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData().copyWith(
          colorScheme:
              ThemeData().colorScheme.copyWith(primary: Color(0xffB62D2D)),
        ),
        home: Wrapper(),
      ),
    );
  }
}
