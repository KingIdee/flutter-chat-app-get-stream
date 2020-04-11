import 'package:flutter/material.dart';
import 'package:flutterchatapp/channel_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  List<User> usersList = [];
  bool loadingData = true;

//  var usersStream;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    setState(() {
      loadingData = true;
    });



    var currentUser = StreamChat.of(context);

    StreamChat.of(context).channelsStream;
    print(StreamChat.of(context).user.id);
    StreamChat.of(context).client.queryUsers({
//      'members': {
//        '\$in': [StreamChat.of(context).user.id],
//      }
    }, [
      SortOption('last_message_at')
    ], null).then((value) {
      print(value.users.toString());
      setState(() {
        usersList = value.users;
        loadingData = false;
      });
    }).catchError((error) {
      setState(() {
        loadingData = false;
      });
      print(error);
      // Could not fetch users
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadingData
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : usersList.length == 0
              ? Container(
                  child: Center(child: Text('Could not fetch users')),
                )
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(usersList[index].name),
                      onTap: () {
                        navigateToChannel(index);
                      },
                    );
                  },
                  itemCount: usersList.length,
                ),
//      body: StreamBuilder<List<User>>(
//          stream: usersStream,
//          builder: (context, snapshot) {
//            if (!snapshot.hasData) {
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            } else if (snapshot.hasError) {
//              return Center(
//                child: Container(
//                  child: Text('An error occurred in fetching users'),
//                ),
//              );
//            } else {
//              return ListView.builder(
//                itemBuilder: (BuildContext context, int index) {
//                  return ListTile(
//                    title: Text(snapshot.data[index].name),
//                  );
//                },
//                itemCount: snapshot.data.length,
//              );
//            }
//          }),

//      body: ChannelListView(
//        filter: {
//          'members': {
//            '\$in': [StreamChat.of(context).user.id],
//          }
//        },
//        sort: [SortOption('last_message_at')],
//        pagination: PaginationParams(
//          limit: 20,
//        ),
//        channelWidget: ChannelPage(),
//      ),
    );
  }

  void navigateToChannel(int index) async {
    var client = StreamChat.of(context).client;
    var currentUser = StreamChat.of(context).user;

    var channel;


    await client
        .channel("messaging", extraData: {
          "members": [currentUser.id, usersList[index].id]
        })
        .create()
        .then((response) {
          channel = Channel.fromState(client, response);
        })
        .catchError((error) {
          print(error);
        });

    // TODO: check that

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
  }
}
