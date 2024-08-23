class RentPayment {
  final int? id;
  final int tenantId;
  final String month;
  final double amount;
  final bool isPaid;
  final DateTime? paymentDate;
  final double? paidAmount;

  RentPayment({
    this.id,
    required this.tenantId,
    required this.month,
    required this.amount,
    this.isPaid = false,
    this.paymentDate,
    this.paidAmount,
  });

  RentPayment copyWith({
    int? id,
    int? tenantId,
    String? month,
    double? amount,
    bool? isPaid,
    DateTime? paymentDate,
    double? paidAmount,
  }) {
    return RentPayment(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      month: month ?? this.month,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      paymentDate: paymentDate ?? this.paymentDate,
      paidAmount: paidAmount ?? this.paidAmount,
    );
  }

  factory RentPayment.fromMap(Map<String, dynamic> map) {
    return RentPayment(
      id: map['id'],
      tenantId: map['tenantId'],
      month: map['month'],
      amount: map['amount'],
      isPaid: map['isPaid'] == 1,
      paymentDate: map['paymentDate'] != null ? DateTime.parse(map['paymentDate']) : null,
      paidAmount: map['paidAmount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenantId': tenantId,
      'month': month,
      'amount': amount,
      'isPaid': isPaid ? 1 : 0,
      'paymentDate': paymentDate?.toIso8601String(),
      'paidAmount': paidAmount,
    };
  }
}
