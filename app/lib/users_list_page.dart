import 'package:flutter/material.dart';
import 'package:flutterchatapp/channel_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  List<User> _usersList = [];
  bool _loadingData = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _loadingData
              ? Container(child: Center(child: CircularProgressIndicator()))
              : _usersList.length == 0
                  ? Container(
                      child: Center(child: Text('Could not fetch users')))
                  : ListView.separated(
                      padding: EdgeInsets.all(16.0),
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(_usersList[index].name),
                          onTap: () {
                            _navigateToChannel(index);
                          },
                        );
                      },
                      itemCount: _usersList.length)),
    );
  }

  _fetchUsers() async {
    setState(() {
      _loadingData = true;
    });

    StreamChat.of(context)
        .client
        .queryUsers({}, [SortOption('last_message_at')], null).then((value) {
      setState(() {
        if (value.users.length > 0) {
          _usersList = value.users.where((element) {
            return element.id != StreamChat.of(context).user.id;
          }).toList();
        }
        _loadingData = false;
      });
    }).catchError((error) {
      setState(() {
        _loadingData = false;
      });
      print(error);
      // Could not fetch users
    });
  }

  void _navigateToChannel(int index) async {
    var client = StreamChat.of(context).client;
    var currentUser = StreamChat.of(context).user;

    Channel channel;

    await client
        .channel("messaging", extraData: {
          "members": [currentUser.id, _usersList[index].id]
        })
        .create()
        .then((response) {
          channel = Channel.fromState(client, response);
          channel.watch();
        })
        .catchError((error) {
          print(error);
        });

    if (channel != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return StreamChannel(
              child: ChannelPage(),
              channel: channel,
            );
          },
        ),
      );
    } else {
      // Could not find a channel;
    }
  }
}
