import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_practice/src/app.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<ChatInfo> chatList = await _loadChatList();
  runApp(MyApp(chatList: chatList));
}

Future<List<ChatInfo>> _loadChatList() async {
  const String fileName = "assets/data/bootcamp.json";
  final Map<String, dynamic> jsonData = jsonDecode(await rootBundle.loadString(fileName));
  final chatList = List<ChatInfo>.empty(growable: true);
  for (final Map<String, dynamic> item in jsonData["data"]) {
    chatList.add(ChatInfo.fromJSON(item));
  }
  return chatList;
}
