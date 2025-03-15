import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          backgroundColor: Colors.teal,
        ),
        body: Stack(children: <Widget>[

          Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.teal[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(_messages[_messages.length - 1 - index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendMessage,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 0,
            child: Container(
                height: 80,
                width: 30,
                color: Colors.teal[200],
            )
          )
        ]));
  }
}
