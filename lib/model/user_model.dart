class UserModel{
  String? name;
  String? uid;
  String? email;
  String? profilePic;

  UserModel({this.name, this.uid, this.email, this.profilePic});

  UserModel.fromMap(Map<String,dynamic>map){
    name=map['name'];
    uid=map['uid'];
    email=map['email'];
    profilePic=map['profilePic'];
  }
  Map<String,dynamic>toMap(){
    return {
      'name':name,
      'uid':uid,
      'email':email,
      'profilePic':profilePic
    };
  }

}