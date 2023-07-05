import 'dart:math';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import "package:dart_date/dart_date.dart";
import 'package:flutter_practice/src/chat_search.dart';

late final List<ChatInfo> chatList;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme)
    {
      return MaterialApp(
        title: 'Messenger App',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 127, 104, 231)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 127, 104, 231), brightness: Brightness.dark),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const MyHomePage(title: 'Messenger Main Page'),
      );
    }
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  
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
        actions: [
          Tooltip(
            message: "Search",
            waitDuration: const Duration(seconds: 1),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.push(context, PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 200),
                reverseTransitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, animation, secondaryAnimation) => const ChatSearchWidget(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child
                  );
                },
              )
              ),
            )
          )
        ],
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (BuildContext context, int index) {
          return ChatTile(info: chatList[index], number: index);
        }
      )
    );
  }
}

mixin ColorGenerator on Widget {
  Color _generateColor({int? seed}) {
    Random random = Random(seed);
    return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256)
      );
  }

  List<Color> _generateColors(int number, {int? seed}) {
    Random random = Random(seed);
    List<Color> colors = <Color>[];
    for (int i = 0; i < number; i++) {
      colors.add(Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256)
      ));
    }
    return colors;
  }
}

class ChatTile extends StatelessWidget with ColorGenerator {
  final ChatInfo info;
  final int number;

  const ChatTile({super.key, required this.info, required this.number});
  
  String _getTimeString(DateTime? time, BuildContext context) {
    if (time == null) return "";
    DateTime currentTime = DateTime.now().toLocalTime;
    if (currentTime.isSameDay(time)) return time.format("Hms");
    if (currentTime.year == time.year) {
      if (currentTime.getWeek == time.getWeek) return time.format("EEEE");
      return time.format("d MMM");
    }
    return time.format("d MMM y");
  }
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      onTap: () {},
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [_generateColor(seed: number), Theme.of(context).canvasColor],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter
          )
        ),
        child: CircleAvatar(
          maxRadius: 25,
          backgroundImage: info.image == null ? null : AssetImage(info.image!),
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: info.image == null ? Text(info.name[0]) : null
              ),
              Align(
                alignment: Alignment.topRight,
                child: info.unreadMessagesCount == 0 ? null : CircleAvatar(
                  maxRadius: 10,
                  backgroundColor: const Color.fromARGB(255, 216, 20, 20),
                  child: Text(
                    info.unreadMessagesCount.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white
                    )
                  ),
                ),
              )
            ]
          )
        )
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
      unreadMessagesCount: map["countUnreadMessages"] != null && map["countUnreadMessages"] >= 0 ? map["countUnreadMessages"] : 0
    );
  }
}