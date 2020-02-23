// Replace the code in main.dart with the following.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

const String _name = "DevopsZEN";

void main() {
  runApp(new FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
  );

  final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.purple,
    accentColor: Colors.orangeAccent[400],
  );
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
        ? kIOSTheme
        : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {                     //modified
  @override                                                        //new
  State createState() => new ChatScreenState();                    //new
}

// Add the ChatScreenState class definition in main.dart.

class ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin{
  final TextEditingController _textController =
    TextEditingController();//new
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;

  @override
  dispose() {
    for(ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).accentColor
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  hintText: "Send a message"
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null,
              ),
            )
          ],
        ),
      ),
    );
  }


  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = ChatMessage(
        text: text,
        animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override                                                        //new
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendlychat")),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final AnimationController animationController;
  ChatMessage({this.text, this.animationController});
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController, curve: Curves.easeOut
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: Theme.of(context).textTheme.subhead,),
                  Container(
                    margin: EdgeInsets.only(top:0.5),
                    child: Text(text),
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