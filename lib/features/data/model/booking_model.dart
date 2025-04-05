class Booking {
  final String source;
  final String destination;
  final String distance;
  final bool isCompleted;
  final DateTime date;

  Booking({
    required this.date,
    required this.source,
    required this.destination,
    required this.distance,
    required this.isCompleted,
  });
}
