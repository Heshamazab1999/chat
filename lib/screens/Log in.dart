import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp46/screens/chat.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  final _auth = FirebaseAuth.instance;
  String username;
  String password;
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  bool _saving = false;

  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    final double x = MediaQuery.of(context).size.width;

    return Scaffold(
backgroundColor: Colors.white,
      body: ModalProgressHUD(inAsyncCall: _saving,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(controller: _usernameController,keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  username = value;
                },
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.teal,
                        )),
                    labelText: "Username",hintText: "username@email.com",

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.teal,
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(controller: _passwordController,obscureText: true,keyboardType: TextInputType.number,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.teal,
                      )),
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _saving=true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: username, password: password);
                  if(newUser!=null){
                  }
                  _passwordController.clear();
                  _usernameController.clear();
                  setState(() {
                    _saving=false;
                  });
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                width: x - 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.teal, borderRadius: BorderRadius.circular(30)),
                child: Center(
                    child: Text(
                  "Log In",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
