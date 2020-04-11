import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/users_list_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userIDController = TextEditingController();

  loginUser() async {
    final userID = userIDController.text.trim();

    var url = "https://0a83ad73.ngrok.io/token";
    Map<String, String> headers = new Map();
    headers['Content-Type'] = 'application/json';
    var body = json.encode({"userId": userID,});
    var tokenResponse = await http.post(url, body: body, headers: headers);
    print(body);
    print(tokenResponse.body);
    var userToken = jsonDecode(tokenResponse.body)['token'];

    final client = Client(
      'djpmq3fg8jnc',
      logLevel: Level.INFO,
    );

    print(userToken);
    print(userID);
    await client.setUser(
      User(id: userID),
      userToken,
    ).then((response){
      print("Has set user");
      print(response.message);
      print(response.user.id);
      print(response.user.createdAt);
    }).catchError((error){
      print(error);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StreamChat(
                client: client,
                child: UsersListPage(),
              )),
    );

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    'UserID',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  )),
              TextFormField(
                  controller: userIDController,
                  decoration: InputDecoration(
                    labelText: "Enter your unique user id",
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                  onPressed: () {
                    loginUser();
                    print("called login user");
                  } ,
                  child: Text('Continue'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
