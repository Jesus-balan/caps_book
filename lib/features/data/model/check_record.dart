class CheckRecord {
  final String checkDate;
  final String? checkIn;
  final String? checkOut;

  CheckRecord({required this.checkDate, this.checkIn, this.checkOut});

  factory CheckRecord.fromJson(Map<String, dynamic> json) {
    return CheckRecord(
      checkDate: json['check_dae'] ?? '',
      checkIn: json['check_in'],
      checkOut: json['check_out'],
    );
  }
}
