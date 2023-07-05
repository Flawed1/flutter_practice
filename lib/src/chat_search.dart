import 'package:flutter/material.dart';
import "package:flutter_practice/src/app.dart";

class ChatSearchWidget extends StatefulWidget {

  const ChatSearchWidget({super.key});

  @override
  State<ChatSearchWidget> createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearchWidget> {
  List<ChatInfo> _matchingChats = <ChatInfo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back)
        ),
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300
            )
          ),
          onChanged: (String? searchQuery) {
            setState(() {
              _matchingChats = _getChatsByQuery(searchQuery);
            });
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _matchingChats.length,
        itemBuilder: (BuildContext context, int index) {
          return ChatTile(info: _matchingChats[index], number: index);
        }
      ),
    );
  }

  List<ChatInfo> _getChatsByQuery(String? query) {
    String? processedQuery = query?.trim().toLowerCase();
    if (processedQuery == null || processedQuery == "") return List.empty();
    return chatList.where((element) => 
      element.name.toLowerCase().contains(processedQuery) ||
      element.lastMessage != null &&
      element.lastMessage!.toLowerCase().contains(processedQuery)
    ).toList();
  }
}