import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp46/screens/Log%20in.dart';

import 'sign up.dart';

class v extends StatefulWidget {
  @override
  _vState createState() => _vState();
}

class _vState extends State<v> {
  @override
  Widget build(BuildContext context) {
    final double x = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.teal,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/.jpg"), fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Log()));
                  },
                  child: Container(
                    width: x - 50,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Text(
                      "Log In",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Sign()));
                    },
                    child: Container(
                      width: x - 50,
                      height: 50,
                      decoration:new BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
