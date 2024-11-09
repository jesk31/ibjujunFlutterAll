class MessageInfo {
MessageInfo({
    this.roomId = '',
    this.roomNm = '',
    this.author = '',
    this.id = '',
    this.repliedMessage = '',
    this.status = '',
    this.type = '',
    this.createdAt = '',
  });

  String roomId;
  String roomNm;
  String author;
  String id;
  String repliedMessage;
  String status;
  String type;
  String createdAt;


  List<MessageInfo>? parseMessageList(List<dynamic> messageList) {
    return messageList.map((messageInfo) {
      return MessageInfo(
        roomId: messageInfo['roomId'] ?? '',
        roomNm: messageInfo['roomNm'] ?? '',
        author: messageInfo['author'] ?? '',
        id: messageInfo['id'] ?? '',
        repliedMessage: messageInfo['repliedMessage'] ?? '',
        status: messageInfo['status'] ?? '',
        type: messageInfo['type'] ?? '',
        createdAt: messageInfo['createdAt'] ?? ''
      );
    }).toList();
  }

}
