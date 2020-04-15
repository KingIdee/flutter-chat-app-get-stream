import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterchatapp/users_list_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userIDController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _client = Client('STREAM_API_KEY', logLevel: Level.INFO);

  @override
  void dispose() {
    _userIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Login',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text('Enter your unique user id',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400))),
              Container(
                  margin: EdgeInsets.only(top: 5),
                  child: TextFormField(
                      controller: _userIDController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFCBD2D9), width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFCBD2D9),
                                  width: 1,
                                  style: BorderStyle.solid))))),
              Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                      onPressed: () {
                        _loginUser();
                      },
                      child: Text('Continue')))
            ],
          ),
        ),
      ),
    );
  }

  _loginUser() async {
    final userID = _userIDController.text.trim();

    if (userID.isEmpty) {
      SnackBar snackBar = SnackBar(content: Text('User id is empty'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    var url = "https://YOUR_NGROK_URL/token";
    Map<String, String> headers = new Map();
    headers['Content-Type'] = 'application/json';
    var body = json.encode({
      "userId": userID,
    });

    var tokenResponse = await http.post(url, body: body, headers: headers);

    var userToken = jsonDecode(tokenResponse.body)['token'];

    await _client.setUser(User(id: userID), userToken).then((response) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StreamChat(
                  client: _client,
                  child: UsersListPage(),
                )),
      );
    }).catchError((error) {
      print(error);
      SnackBar snackBar = SnackBar(content: Text('Could not login user'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }
}
