import 'package:parking_app/services/auth.dart';
import 'package:parking_app/shared/constants.dart';
import 'package:parking_app/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final toggleView;
  SignIn({this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign In to Brew App'),
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  onPressed: () {
                    widget.toggleView();
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter your email',
                          icon: Icon(Icons.email),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Enter your password',
                          icon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (val) =>
                            val!.length < 6 ? 'Invalid password' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        child: Text('Sign In'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink[400],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = 'Invalid email or password';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  )),
            ),
          );
  }
}
