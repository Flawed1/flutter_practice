import 'package:flutter/material.dart';
import "package:dart_date/dart_date.dart";


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 185, 142, 241)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Messenger Main Page'),
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
        actions: [IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        )],
      ),
      body: ListView(
        children: [
          ChatTile(
            info: ChatTileInfo(name: "Apple Appovich", lastMessage: "Test message", date: DateTime(2023, 6, 29, 10).toLocalTime)
          ),
          ChatTile(
            info: ChatTileInfo(name: "Test Name", lastMessage: "Bubble Tea", date: DateTime(2021, 6, 29, 10).toLocalTime)
          ),
          ChatTile(
            info: ChatTileInfo(name: "NoName Inc.")
          )
        ]
      )
    );
  }
}

class ChatTile extends StatelessWidget {
  final ChatTileInfo info;

  static String _getTimeString(DateTime? time, BuildContext context) {
    if (time == null) return "";
    DateTime currentTime = DateTime.now().toLocalTime;
    if (currentTime.isSameDay(time)) return time.format("Hms");
    if (currentTime.year == time.year) {
      if (currentTime.getWeek == time.getWeek) return time.format("d MMM");
      return time.format("EEEE");
    }
    return time.format("d MMM y", Localizations.localeOf(context).languageCode);
  }

  const ChatTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      leading: CircleAvatar(backgroundColor: Theme.of(context).disabledColor, foregroundImage: info.image),
      title: Text(info.name),
      subtitle: Column(key: key, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(info.lastMessage = info.lastMessage ?? "", overflow: TextOverflow.ellipsis), Text(_getTimeString(info.date, context))])
    );
  }
}

class ChatTileInfo {
  ImageProvider<Object>? image;
  String name;
  String? lastMessage;
  DateTime? date;

  ChatTileInfo({required this.name, this.image, this.lastMessage, this.date});
}