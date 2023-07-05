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
