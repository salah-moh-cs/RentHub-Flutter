// ignore_for_file: file_names

enum ChatMessageType { text, audio, image, video }

// ignore: constant_identifier_names
enum MessageStatus { not_sent, not_view, viewed }

MessageStatus stringToMessageStatus(String value) {
  switch (value) {
    case 'not_sent':
      return MessageStatus.not_sent;
    case 'not_view':
      return MessageStatus.not_view;
    case 'viewed':
      return MessageStatus.viewed;
    default:
      throw ArgumentError('Invalid message status value: $value');
  }
}

String messageStatusToString(MessageStatus status) {
  switch (status) {
    case MessageStatus.not_sent:
      return 'not_sent';
    case MessageStatus.not_view:
      return 'not_view';
    case MessageStatus.viewed:
      return 'viewed';
    default:
      throw ArgumentError('Invalid message status value: $status');
  }
}

ChatMessageType stringToChatMessageType(String value) {
  switch (value) {
    case 'text':
      return ChatMessageType.text;
    case 'audio':
      return ChatMessageType.audio;
    case 'image':
      return ChatMessageType.image;
    case 'video':
      return ChatMessageType.video;
    default:
      throw ArgumentError('Invalid chat message type value: $value');
  }
}

String chatMessageTypeToString(ChatMessageType type) {
  switch (type) {
    case ChatMessageType.text:
      return 'text';
    case ChatMessageType.audio:
      return 'audio';
    case ChatMessageType.image:
      return 'image';
    case ChatMessageType.video:
      return 'video';
    default:
      throw ArgumentError('Invalid chat message type value: $type');
  }
}

class ChatMessage {
  final String sender;
  final String msg;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final DateTime sendTime;

  ChatMessage({
    this.msg = '',
    this.messageType = ChatMessageType.text,
    this.messageStatus = MessageStatus.not_sent,
    required this.sender,
    required this.sendTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'msg': msg,
      'messageType': chatMessageTypeToString(messageType),
      'messageStatus': messageStatusToString(messageStatus),
      'sendTime': sendTime.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
        sender: map['sender'] as String,
        msg: map['msg'] as String,
        messageType: stringToChatMessageType(map['messageType']),
        messageStatus: stringToMessageStatus(map['messageStatus']),
        sendTime: DateTime.parse(map['sendTime']));
  }
}
