class Shift {
  final DateTime date;
  final double amount;

  Shift({required this.date, required this.amount});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'amount': amount,
  };

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
