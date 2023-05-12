class UserModel {
  String? id, email, username, type, profilePic, bio;
  UserModel( {this.id,this.username,this.email,this.type,this.profilePic,this.bio});
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
      email: map["email"],
      username: map["username"],
      type: map["type"],
      profilePic: map["profilePic"],
      bio: map["bio"]); }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "username": username,
      "type": type,
      "profilePic": profilePic,
      "bio": bio};}}
