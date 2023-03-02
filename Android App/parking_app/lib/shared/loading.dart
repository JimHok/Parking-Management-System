import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff7AA5C5),
      child: Center(
        child: SpinKitChasingDots(
          color: Color(0xff4B667A),
          size: 50.0,
        ),
      ),
    );
  }
}
