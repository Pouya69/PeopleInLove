class LoginObject {
  final String token;
  final String email;
  final String dateOfBirth;
  final String gender;
  final String username;
  final String about;
  final String datingWith;
  final String feeling;
  final List<String> interests;
  final int premiumDaysLeft;
  final bool private;
  final String fullName;
  final String createDate;

  LoginObject({required this.token, required this.email, required this.dateOfBirth, required this.gender, required this.username, required this.about, required this.datingWith, required this.feeling, required this.interests, required this.premiumDaysLeft, required this.private, required this.fullName, required this.createDate});
  // LoginObject({required this.token});
  factory LoginObject.fromJSON(String token, Map<String, dynamic> userDetails) {
    return LoginObject(
      token: token,
      email: userDetails["email"],
      dateOfBirth: userDetails["date_of_birth"],
      username: userDetails["username"],
      about: userDetails["about"],
      datingWith: userDetails["dating_with"] != null ? userDetails["dating_with"] : "",
      fullName: userDetails["full_name"],
      gender: userDetails["gender"],
      feeling: userDetails["feeling"],
      interests: userDetails["interests"].length == 0 ? <String>[] : userDetails["interests"],
      private: userDetails["private"],
      createDate: userDetails["create_date"],
      premiumDaysLeft: userDetails["premium_days_left"],
    );
  }
}


class GroupItemObject {
  final int groupId;
  final String groupName;
  String pictureUrl;
  String creator;
  int unreadMessages;
  int lastMessageId;

  GroupItemObject({required this.groupName, required this.pictureUrl, required this.groupId, required this.creator, required this.lastMessageId, required this.unreadMessages});

  factory GroupItemObject.fromJSON(Map<String, dynamic> map, int unreadMessages) {
    return GroupItemObject(
        groupId: map['group_id'],
        groupName: map['group_name'],
        creator: map['creator'],
        lastMessageId: map['id'],
        pictureUrl: map['pic_url'],
        unreadMessages: unreadMessages
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'group_name': groupName,
      'picture_url': pictureUrl,
      'unread_messages': unreadMessages,
      'last_message_id': lastMessageId,
      'last_message_creator': creator,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'GroupItemObject{group_id: $groupId, group_name: $groupName, picture_url: $pictureUrl, unread_messages: $unreadMessages, last_message_id: $lastMessageId, last_message_creator: $creator}';
  }
}