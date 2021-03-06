import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pilgrimage_app/components/constants.dart';
import 'package:pilgrimage_app/screen/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pilgrimage_app/components/utils.dart';
import 'package:pilgrimage_app/screen/Startpage/ForgotPassword.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/tologinpage';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showspinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 200.0,
                  child: Image.asset('assets/images/newlogo.jpg'),
                ),
                SizedBox(
                  height: 44.0,
                ),
                TextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextfielddec.copyWith(hintText: 'Enter your email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                      kTextfielddec.copyWith(hintText: 'Enter your password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter min. 6 charecters'
                      : null,
                ),
                SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Material(
                    color: Colors.pink,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showspinner = true;
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.pushNamed(
                                context, HomeScreen.homescreen_id);
                          }
                          setState(() {
                            showspinner = false;
                          });
                        } on FirebaseAuthException catch (e) {
                          Utils.showSnackBar(e.message);
                          setState(() {
                            showspinner = false;
                          });
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 15,
                      ),
                    ),
                    onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPassword(),)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
