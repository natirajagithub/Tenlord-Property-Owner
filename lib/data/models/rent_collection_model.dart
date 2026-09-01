class RentCollectionModel {
  final int id;
  final String receiptNo;
  final String tenantName;
  final String roomNo;
  final String billingMonth;
  final num amount;
  final String paymentDate;
  final String paymentMode; // Cash, UPI, Bank Transfer, Cheque
  final String status; // Paid, Pending, Overdue

  RentCollectionModel({
    required this.id,
    required this.receiptNo,
    required this.tenantName,
    required this.roomNo,
    required this.billingMonth,
    required this.amount,
    required this.paymentDate,
    required this.paymentMode,
    required this.status,
  });

  factory RentCollectionModel.fromJson(Map<String, dynamic> json) {
    return RentCollectionModel(
      id: json['id'] as int? ?? 1,
      receiptNo: json['receipt_no'] as String? ?? 'REC-001',
      tenantName: json['tenant_name'] as String? ?? '',
      roomNo: json['room_no'] as String? ?? '101',
      billingMonth: json['billing_month'] as String? ?? 'August 2026',
      amount: json['amount'] as num? ?? 8500,
      paymentDate: json['payment_date'] as String? ?? '',
      paymentMode: json['payment_mode'] as String? ?? 'UPI',
      status: json['status'] as String? ?? 'Paid',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receipt_no': receiptNo,
      'tenant_name': tenantName,
      'room_no': roomNo,
      'billing_month': billingMonth,
      'amount': amount,
      'payment_date': paymentDate,
      'payment_mode': paymentMode,
      'status': status,
    };
  }
}
