class ExpenseResponse {
  final String status;
  final String actionCode;
  final ExpenseData data;

  ExpenseResponse({
    required this.status,
    required this.actionCode,
    required this.data,
  });

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      status: json['status'],
      actionCode: json['action_code'],
      data: ExpenseData.fromJson(json['data']),
    );
  }
}

class ExpenseData {
  final int count;
  final String? next;
  final String? previous;
  final List<ExpenseItem> results;

  ExpenseData({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: List<ExpenseItem>.from(
        json['results'].map((item) => ExpenseItem.fromJson(item)),
      ),
    );
  }
}

class ExpenseItem {
  final int id;
  final String uuid;
  final String category;
  final String subcategory;
  final int? subledgerType;
  final String paymentMethod;
  final String amount;
  final String? description;
  final int? driver;
  final int? staff;
  final DateTime createdAt;

  ExpenseItem({
    required this.id,
    required this.uuid,
    required this.category,
    required this.subcategory,
    required this.subledgerType,
    required this.paymentMethod,
    required this.amount,
    required this.description,
    required this.driver,
    required this.staff,
    required this.createdAt,
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      id: json['id'],
      uuid: json['uuid'],
      category: json['category'],
      subcategory: json['subcategory'],
      subledgerType: json['subledger_type'],
      paymentMethod: json['payment_method'],
      amount: json['amount'],
      description: json['description'],
      driver: json['driver'],
      staff: json['staff'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
