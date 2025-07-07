
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

 final _firestore = FirebaseFirestore.instance;
 var loggedInUser;

class ChatScreen extends StatefulWidget {

  static String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController() ;
  final _auth = FirebaseAuth.instance;
 
  String ?messageText;


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

void getCurrentUser() async{
  try{
  final user = await _auth.currentUser;
  if (user != null){
loggedInUser = user;
print(loggedInUser);
  }}
  catch(e){
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send', 
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('timestamp').snapshots(), 
            builder: (context, snapshot) {
              if (!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator (backgroundColor: Colors.lightBlueAccent,),
                  );
              } 
                final messages = snapshot.data!.docs.reversed;
                List<MessageBubble> messageBubbles = [];

                for(var message in messages){
                  final messageText = message.data() as Map <String, dynamic>;
                  final text = messageText['text'];
                  final sender = messageText['sender'];

                  final currentUser = loggedInUser.email;

                  final messageBubble = MessageBubble(sender: sender, text: text, isMe: currentUser == sender,);
                  
                  messageBubbles.add(messageBubble);
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                     children: messageBubbles,
                    ),
                );
            },
            );
  }
}

class MessageBubble extends StatelessWidget {
   MessageBubble({this.sender, this.text, this.isMe});
   final sender;
   final text;
   final bool ?isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(crossAxisAlignment: isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start, 
        children: [
          Text(sender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),),
          Material(
            elevation: 5.0,
            borderRadius: isMe! ? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)) : BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: isMe! ?Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text('$text',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: isMe! ? Colors.white: Colors.black54,
                            ),),
            ),
          ),
        ],
      ),
    );;
  }
}