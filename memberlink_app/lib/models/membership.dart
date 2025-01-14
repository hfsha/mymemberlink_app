class Membership {
  String? membershipId;
  String? name;
  String? description;
  double? price;
  String? benefits;
  int? duration;
  String? terms;

  Membership({
    this.membershipId,
    this.name,
    this.description,
    this.price,
    this.benefits,
    this.duration,
    this.terms,
  });

  Membership.fromJson(Map<String, dynamic> json) {
    membershipId = json['membership_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'] != null ? double.parse(json['price'].toString()) : null;
    benefits = json['benefits'];
    duration = json['duration'];
    terms = json['terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['membership_id'] = membershipId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['benefits'] = benefits;
    data['duration'] = duration;
    data['terms'] = terms;
    return data;
  }
}
