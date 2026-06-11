class RedeemedReward {

  final int id;
  final String rewardName;
  final String qrCode;
  final String redeemedAt;
  final bool used;

  RedeemedReward({
    required this.id,
    required this.rewardName,
    required this.qrCode,
    required this.redeemedAt,
    required this.used,
  });

  factory RedeemedReward.fromJson(
    Map<String, dynamic> json,
  ) {

    return RedeemedReward(
      id: json['id'],
      rewardName: json['reward']['name'],
      qrCode: json['qrCode'],
      redeemedAt: json['redeemedAt'],
      used: json['used'],
    );
  }
}