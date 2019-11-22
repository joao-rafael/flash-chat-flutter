import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static String pageRoute = "/chat";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();

  String messageText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser();
      if( user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }catch (e){
      print(e);
    }
  }

  void getMessages() async{
    final messages = await _firestore.collection('messages').getDocuments();
    for (var message in messages.documents){
      print(message.data);
    }
  }

  void messagesStream() async{
    await for( var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.documents){
        print(message.data);
      }
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
                messagesStream();//Implement logout functionality
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
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                      'sender' : loggedInUser.email});
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

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      //flutter async snapshots
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBox> messageWidgets = [];
        for(var message in messages){
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final currentUser = loggedInUser.email;

          if(currentUser == messageSender){

          }
          final messageWidget = MessageBox(sender: messageSender, text: messageText, isUser: currentUser == messageSender);
          messageWidgets.add(messageWidget);

        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets
            ,
          ),
        );
      },
    );
  }
}



class MessageBox extends StatelessWidget {

  MessageBox({@required this.text, @required this.sender,@required this.isUser});
  final String text;
  final String sender;
  final bool isUser;


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: !isUser ? BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0), topRight: Radius.circular(10.0)) : BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)) ,
            color: isUser ? Colors.lightBlueAccent : Colors.white,
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('$text', style: TextStyle(color: isUser ? Colors.white : Colors.black45, fontSize: 20.0),),
              ),
          ),
          Text("$sender", style: TextStyle(color: Colors.grey, fontSize: 12.0)),
        ],
      ),
    );
  }
}

