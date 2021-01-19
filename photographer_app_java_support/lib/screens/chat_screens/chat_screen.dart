import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photographer_app_java_support/functions/glowRemoveScrollBehaviour.dart';
import 'package:photographer_app_java_support/services/chat_service.dart';
import 'package:photographer_app_java_support/widgets/chat_screen/flat_action_btn.dart';
import 'package:photographer_app_java_support/widgets/chat_screen/flat_chat_message.dart';
import 'package:photographer_app_java_support/widgets/chat_screen/flat_page_header.dart';
import 'package:photographer_app_java_support/widgets/chat_screen/flat_profile_image.dart';

class ChatPage extends StatefulWidget {
  static final String id = "ChatPage";
  final String chatRoomId;
  final String avatar;
  final String myName;
  const ChatPage({this.chatRoomId, this.avatar, @required this.myName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(
                  top: 122.0,
                  bottom: 80.0,
                ),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return FlatChatMessage(
                    message: snapshot.data.documents[index].data()["message"],
                    messageType: widget.myName ==
                            snapshot.data.documents[index].data()["sendBy"]
                        ? MessageType.sent
                        : MessageType.received,
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      ChatMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    ChatMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //body
          Positioned(
            child: ScrollConfiguration(
              behavior: GlowRemoveScrollBehaviour(),
              child: chatMessages(),
            ),
          ),

          // header
          Positioned(
            child: FlatPageHeader(
              prefixWidget: FlatActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: widget.chatRoomId
                  .toString()
                  .replaceAll("_", "")
                  .replaceAll(widget.myName, ""),
              suffixWidget: FlatProfileImage(
                size: 35.0,
                onlineIndicator: true,
                imageUrl: widget.avatar ??
                    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                onPressed: () {
                  print("Clicked Profile Image");
                },
              ),
            ),
          ),

          //footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffFCF9F5),
                  borderRadius: BorderRadius.circular(60.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 20,
                      blurRadius: 20,
                      offset: Offset(0, -5), // changes position of shadow
                    )
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff262833).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          decoration: InputDecoration(
                            hintText: "Nhập tin nhắn...",
                            hintStyle: TextStyle(
                              color: Color(0xff262833).withOpacity(0.6),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(
                              16.0,
                            ),
                          ),
                          style: TextStyle(color: Color(0xff262833)),
                        ),
                      ),
                      FlatActionButton(
                        onPressed: () {
                          addMessage();
                        },
                        icon: Icon(
                          Icons.send,
                          size: 24.0,
                          color: Color(0xff262833),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
