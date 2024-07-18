import 'rent_payment_class.dart';

class Tenant {
  int? id;
  String name;
  String address;
  int contractDuration; // Sözleşme süresi yıl olarak
  String phoneNumber;
  double rentAmount;
  DateTime startDate; // Kira başlangıç tarihi
  List<RentPayment> rentPayments;

  Tenant({
    this.id,
    required this.name,
    required this.address,
    required this.contractDuration,
    required this.phoneNumber,
    required this.rentAmount,
    required this.startDate,
    this.rentPayments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contractDuration': contractDuration,
      'phoneNumber': phoneNumber,
      'rentAmount': rentAmount,
      'startDate': startDate.toIso8601String(),
    };
  }

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      contractDuration: map['contractDuration'],
      phoneNumber: map['phoneNumber'],
      rentAmount: map['rentAmount'],
      startDate: DateTime.parse(map['startDate']),
    );
  }
}
