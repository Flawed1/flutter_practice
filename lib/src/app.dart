import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import "package:dart_date/dart_date.dart";


class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.chatList});

  final List<ChatInfo> chatList;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme)
    {
      return MaterialApp(
        title: 'Messenger App',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 185, 142, 241)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 185, 142, 241), brightness: Brightness.dark),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: MyHomePage(title: 'Messenger Main Page', chatList: chatList),
      );
    }
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.chatList});

  final String title;
  final List<ChatInfo> chatList;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        )],
      ),
      body: ListView.builder(itemCount: chatList.length, itemBuilder: (BuildContext context, int index) {
        return ChatTile(info: chatList[index]);
      })
    );
  }
}

class ChatTile extends StatelessWidget {
  final ChatInfo info;

  static String _getTimeString(DateTime? time, BuildContext context) {
    if (time == null) return "";
    DateTime currentTime = DateTime.now().toLocalTime;
    if (currentTime.isSameDay(time)) return time.format("Hms");
    if (currentTime.year == time.year) {
      if (currentTime.getWeek == time.getWeek) return time.format("EEEE");
      return time.format("d MMM");
    }
    return time.format("d MMM y");
  }

  const ChatTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).disabledColor,
        foregroundImage: info.image == null ? null : AssetImage(info.image!),
        child: Text(info.name[0]),
      ),
      title: Text(info.name),
      subtitle: Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(info.lastMessage = info.lastMessage ?? "", overflow: TextOverflow.ellipsis),
          Text(_getTimeString(info.date, context))
        ]
      )
    );
  }
}

class ChatInfo {
  String? image;
  String name;
  String? lastMessage;
  DateTime? date;
  int unreadMessagesCount;

  ChatInfo({required this.name, this.image, this.lastMessage, this.date, required this.unreadMessagesCount});

  factory ChatInfo.fromJSON(Map<String, dynamic> map) {
    return ChatInfo(
      name: map["userName"] ?? "Name Undefined",
      image: map["userAvatar"] == null ? null : "assets/data/avatars/${map["userAvatar"]}",
      lastMessage: map["lastMessage"],
      date: map["date"] == null ? null : DateTime.fromMillisecondsSinceEpoch(map["date"]),
      unreadMessagesCount: map["countUnreadMessages"]
    );
  }
}