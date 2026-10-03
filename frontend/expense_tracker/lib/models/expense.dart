class Expense {
  final int? id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}