class Customer {
  String cId;
  String firstName;
  String lastName;
  bool status;

  Customer({
    required this.cId,
    required this.firstName,
    required this.lastName,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      cId: json['c_id'],
      firstName: json['c_fname'],
      lastName: json['c_lname'],
      status: json['c_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "c_id": cId,
      "c_fname": firstName,
      "c_lname": lastName,
      "c_status": status,
    };
  }

  static List<Customer> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Customer.fromJson(item)).toList();
  }
}
