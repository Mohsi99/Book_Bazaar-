class UserModel {
  final String? docId;
  final String? name;
  final String? phone;
  final String? address;
  final String? email;
  final String? profileImageUrl;
  final int? createdAt;

  UserModel({
    this.docId,
    this.name,
    this.phone,
    this.address,
    this.email,
    this.profileImageUrl, // NEW FIELD
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    docId: json["docID"],
    name: json["name"],
    phone: json["phone"],
    address: json["address"],
    email: json["email"],
    profileImageUrl: json["profileImageUrl"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson(String userID) => {
    "docID": userID,
    "name": name,
    "phone": phone,
    "address": address,
    "email": email,
    "profileImageUrl": profileImageUrl,
    "createdAt": createdAt,
  };
}