class ChatRoomModel {
  String? chatRoomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  ChatRoomModel({this.chatRoomid, this.participants, this.lastMessage});
  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomid = map["chatRoomid"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];}
  Map<String, dynamic> toMap() {
    return {
      "chatRoomid": chatRoomid,
      "participants": participants,
      "lastMessage": lastMessage}; }}
