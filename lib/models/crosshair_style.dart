enum CrosshairStyle { dot, cross, circle, plus, tShape }

extension CrosshairStyleLabel on CrosshairStyle {
  String get label {
    switch (this) {
      case CrosshairStyle.dot:
        return 'Dot';
      case CrosshairStyle.cross:
        return 'Cross';
      case CrosshairStyle.circle:
        return 'Circle';
      case CrosshairStyle.plus:
        return 'Plus';
      case CrosshairStyle.tShape:
        return 'T-Shape';
    }
  }
}
