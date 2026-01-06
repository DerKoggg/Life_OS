class PlannedShift {
  final DateTime date;
  final double expectedAmount;

  PlannedShift({required this.date, required this.expectedAmount});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'expectedAmount': expectedAmount,
  };

  factory PlannedShift.fromJson(Map<String, dynamic> json) {
    return PlannedShift(
      date: DateTime.parse(json['date'] as String),
      expectedAmount: (json['expectedAmount'] as num).toDouble(),
    );
  }
}
