class RulerEntity {
  final double leftLineY;
  final double rightLineY;

  const RulerEntity({required this.leftLineY, required this.rightLineY});

  RulerEntity copyWith({double? leftLineY, double? rightLineY}) {
    return RulerEntity(
      leftLineY: leftLineY ?? this.leftLineY,
      rightLineY: rightLineY ?? this.rightLineY,
    );
  }
}
