import 'package:chat_app/base.dart';
import 'package:chat_app/models/room.dart';
import 'package:chat_app/modules/chat/chat_viewmodel.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/message.dart';
import 'message_widget.dart';

class chatScreen extends StatefulWidget {
  static const String routeName = "chatScreen";

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends BaseView<chatScreen, ChatViewModel>
    implements ChatNavigator {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
  }

  var contentMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var room = ModalRoute.of(context)?.settings.arguments as Room;
    var provider = Provider.of<UserProvider>(context);
    viewModel.room = room;
    viewModel.myUser = provider.myUser!;
    viewModel.readMessages();
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/main_bg.png',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(room.roomName),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 55),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                      child: StreamBuilder<QuerySnapshot<Message>>(
                    stream: viewModel.readMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("something went Wrong");
                      }
                      var messages =
                          snapshot.data?.docs.map((doc) => doc.data()).toList();
                      return ListView.builder(
                        itemCount: messages?.length ?? 0,
                        itemBuilder: (context, index) {
                          return MessageWidget(messages![index]);
                        },
                      );
                    },
                  )),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: contentMessageController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "Type a message",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12))),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          viewModel.SendMessage(contentMessageController.text);
                          print(provider.myUser!.id);
                        },
                        child: Row(
                          children: [
                            Text("Send"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.send)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ChatViewModel initViewModel() => ChatViewModel();

  @override
  void clearContent() {
    contentMessageController.clear();
    setState(() {});
  }
}
