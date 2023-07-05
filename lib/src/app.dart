import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/src/chat_search.dart';
import 'package:flutter_practice/src/chat_tile.dart';
import 'package:flutter_practice/src/chat_info.dart';

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
        home: const MyHomePage(),
      );
    }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FocusNode _tileFocusNode = FocusNode();

  @override
  void dispose() {
    _tileFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Messenger Main Page"),
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
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.redAccent,
              child: const Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.delete, size: 30)
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete, size: 30)
                  ),
                ],
              )
            ),
            onDismissed:(direction) {
              setState(() {
                chatList.removeAt(index);
              });
            },
            child: MenuAnchor(
              childFocusNode: _tileFocusNode,
              anchorTapClosesMenu: true,
              builder: (context, controller, child) {
                return ChatTile(
                  info: chatList[index],
                  number: index,
                  focusNode: _tileFocusNode,
                  onLongPress: () {
                    if (controller.isOpen) {
                      controller.close();
                    }
                    else {
                      controller.open();
                    }
                  }
                );
              },
              menuChildren: <Widget>[
                MenuItemButton(
                  leadingIcon: const Icon(Icons.chat_bubble_rounded),
                  onPressed: chatList[index].unreadMessagesCount == 0 ?
                  null :
                  () {
                    setState(() {
                      chatList[index].unreadMessagesCount = 0;
                    });
                  },
                  child: const Text("Mark as read")
                )
              ],
            )
          );
        }
      )
    );
  }
}
