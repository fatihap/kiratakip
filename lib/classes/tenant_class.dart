class Tenant {
  final int id;
  final String name;
  final String surname;
  final String phone;
  final String address;
  final int contract_duration;
  final int rent_amount;
  final String start_date;
  final String description;
  final int type;

  Tenant({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.address,
    required this.contract_duration,
    required this.rent_amount,
    required this.start_date,
    required this.description,
    required this.type,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      contract_duration: json['contractDuration'] ?? 0,
      rent_amount: json['rentAmount'] ?? 0,
      start_date: json['startDate'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'phone': phone,
      'address': address,
      'contract_duration': contract_duration,
      'rent_amount': rent_amount,
      'start_date': start_date,
      'description': description,
      'type': type,
    };
  }
}
