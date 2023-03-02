import 'package:parking_app/screens/authenticate/authenticate.dart';
import 'package:parking_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserParam?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
