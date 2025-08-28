import 'dart:math';

class BrickResult {
  final int totalBricks;
  final double wallVolumeM3;
  final double mortarDryM3;
  final double cementBags; // 50kg bags
  final double sandTons;

  BrickResult({
    required this.totalBricks,
    required this.wallVolumeM3,
    required this.mortarDryM3,
    required this.cementBags,
    required this.sandTons,
  });
}

class CalcBrickUseCase {
  static const double jointM = 0.01; // 10 mm joint thickness
  static const double wasteFactor = 1.15; // +15% wastage
  static const double dryFactor = 1.25; // wet->dry +25%
  static const double bagVolumeM3 = 0.035; // cement bag volume (50kg)
  static const double sandDensityKgPerM3 = 1500.0; // kg/m³

  BrickResult execute({
    required double wallLengthM,
    required double wallHeightM,
    required double wallThicknessM,
    required double brickLcm,
    required double brickWcm,
    required double brickHcm,
    required int mortarRatioX,
  }) {
    // 1) Convert brick sizes from cm to meters
    final bL = brickLcm / 100.0;
    final bW = brickWcm / 100.0;
    final bH = brickHcm / 100.0;

    // 2) Wall volume in m³
    final wallVolM3 = max(0.0, wallLengthM * wallHeightM * wallThicknessM);

    // 3) Brick volume with mortar (joint thickness)
    final brickVolWithMortar = max(
      1e-9,
      (bL + jointM) * (bW + jointM) * (bH + jointM),
    );
    final brickVolWithoutMortar = max(1e-9, bL * bW * bH);

    // 4) Total bricks (round up)
    final bricks = (wallVolM3 / brickVolWithMortar).ceil();

    // 5) Mortar wet volume (wall - bricks without mortar)
    final mortarWetM3 = max(0.0, wallVolM3 - (bricks * brickVolWithoutMortar));

    // 6) Convert wet mortar to dry & add wastage
    final mortarDryM3 = mortarWetM3 * dryFactor * wasteFactor;

    // 7) Volume split for cement & sand (1:X mix)
    final totalParts = 1 + mortarRatioX;
    final cementVolM3 = mortarDryM3 * (1 / totalParts);
    final sandVolM3 = mortarDryM3 * (mortarRatioX / totalParts);

    // 8) Cement bags
    final cementBags = cementVolM3 / bagVolumeM3;

    // 9) Sand in tons
    final sandTons = (sandVolM3 * sandDensityKgPerM3) / 1000.0;

    return BrickResult(
      totalBricks: bricks,
      wallVolumeM3: wallVolM3,
      mortarDryM3: mortarDryM3,
      cementBags: cementBags,
      sandTons: sandTons,
    );
  }
}
