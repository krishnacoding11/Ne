class ArgumentChatDetailModel {
  String? id;
  String? name;
  String? shortName;
  String? time;
  String? firstUserPhoneNumber;
  String? secondUserPhoneNumber;
  String? firstId;
  String? secondId;
  String tag;
  // List<Message>? messages;

  ArgumentChatDetailModel(
      {this.id,
      this.name,
      this.time,
      this.shortName,
      // this.messages,
      this.firstUserPhoneNumber,
      this.secondUserPhoneNumber,
      this.firstId,
      this.secondId,
      required this.tag});
}
