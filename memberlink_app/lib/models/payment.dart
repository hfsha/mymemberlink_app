class Payment {
  String? paymentId;
  String? membershipId;
  String? userId;
  double? amountPaid;
  String? paymentStatus;
  String? purchaseDate;
  String? paymentBillplzId;

  Payment({
    this.paymentId,
    this.membershipId,
    this.userId,
    this.amountPaid,
    this.paymentStatus,
    this.purchaseDate,
    this.paymentBillplzId,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id']?.toString();
    membershipId = json['membership_id']?.toString();
    userId = json['userid']?.toString();
    amountPaid = json['amount_paid'] != null
        ? double.tryParse(json['amount_paid'].toString())
        : null;
    paymentStatus = json['payment_status'];
    purchaseDate = json['purchase_date'];
    paymentBillplzId = json['payment_billplz_id'];
  }

  // Add this getter method
  String get membershipName {
    switch (membershipId) {
      case '1':
        return 'Couch Potato Club';
      case '2':
        return 'Social Butterfly Pass';
      case '3':
        return 'Mastermind Elite';
      default:
        return 'Unknown Membership';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_id'] = paymentId;
    data['membership_id'] = membershipId;
    data['userid'] = userId;
    data['amount_paid'] = amountPaid;
    data['payment_status'] = paymentStatus;
    data['purchase_date'] = purchaseDate;
    data['payment_billplz_id'] = paymentBillplzId;
    return data;
  }
}
