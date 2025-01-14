class User {
  String? userId;
  String? fullName;
  String? phone;
  String? email;
  String? password;
  String? membershipId;
  String? memberType;
  String? registerDate;

  User({
    this.userId,
    this.fullName,
    this.phone,
    this.email,
    this.password,
    this.membershipId,
    this.memberType,
    this.registerDate,
  });

  User.fromJson(Map<String, dynamic> json) {
    // Safely converting any integer fields to String
    userId = (json['userid'] ?? '').toString();
    fullName = json['fullname']?.toString() ?? '';
    phone = json['phone']?.toString() ?? '';
    email = json['email']?.toString() ?? '';
    password = json['password']?.toString() ?? '';
    membershipId = (json['membership_id'] ?? '').toString();
    memberType = json['member_type']?.toString() ?? '';
    registerDate = json['registerdate']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'fullname': fullName,
      'phone': phone,
      'email': email,
      'password': password,
      'membership_id': membershipId,
      'member_type': memberType,
      'registerdate': registerDate,
    };
  }
}
