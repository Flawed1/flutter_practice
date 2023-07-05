import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/src/chat_info.dart';
import 'package:flutter_practice/src/color_generator.dart';

class ChatTile extends StatelessWidget {
  final ChatInfo info;
  final int number;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const ChatTile({super.key, required this.info, required this.number, this.focusNode, this.onTap, this.onLongPress});
  
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
      onTap: onTap ?? () {},
      focusNode: focusNode,
      onLongPress: onLongPress,
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [ColorGenerator.generateColor(seed: number), Theme.of(context).canvasColor],
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