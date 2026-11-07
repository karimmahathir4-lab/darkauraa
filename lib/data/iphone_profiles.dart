class IPhoneProfile {
  const IPhoneProfile(this.model, this.year, this.screenInches, this.refreshHz);

  final String model;
  final int year;
  final double screenInches;
  final int refreshHz;

  // Demo heuristic only: screen class, display refresh capability, and generation.
  // It is not a game-specific or Apple-recommended sensitivity value.
  int get sampleBase {
    final screenAdjustment = ((screenInches - 6.1) * 4).round();
    final refreshAdjustment = refreshHz >= 120 ? 2 : 0;
    final generationAdjustment = ((year - 2021) / 3).floor().clamp(-2, 2);
    return (82 + screenAdjustment + refreshAdjustment + generationAdjustment)
        .clamp(72, 92)
        .toInt();
  }

  String get displaySummary =>
      '${screenInches.toStringAsFixed(1)} in · $refreshHz Hz';
}

// Models capable of running this app's iOS 13+ build, through Apple's listed
// 2026 devices. Users select their model manually; this app does not identify it.
const List<IPhoneProfile> iPhoneProfiles = <IPhoneProfile>[
  IPhoneProfile('iPhone 18 Pro Max', 2026, 6.9, 120),
  IPhoneProfile('iPhone 18 Pro', 2026, 6.3, 120),
  IPhoneProfile('iPhone 17 Pro Max', 2025, 6.9, 120),
  IPhoneProfile('iPhone 17 Pro', 2025, 6.3, 120),
  IPhoneProfile('iPhone 17', 2025, 6.3, 120),
  IPhoneProfile('iPhone Air', 2025, 6.5, 120),
  IPhoneProfile('iPhone 17e', 2026, 6.1, 60),
  IPhoneProfile('iPhone 16 Pro Max', 2024, 6.9, 120),
  IPhoneProfile('iPhone 16 Pro', 2024, 6.3, 120),
  IPhoneProfile('iPhone 16 Plus', 2024, 6.7, 60),
  IPhoneProfile('iPhone 16', 2024, 6.1, 60),
  IPhoneProfile('iPhone 16e', 2025, 6.1, 60),
  IPhoneProfile('iPhone 15 Pro Max', 2023, 6.7, 120),
  IPhoneProfile('iPhone 15 Pro', 2023, 6.1, 120),
  IPhoneProfile('iPhone 15 Plus', 2023, 6.7, 60),
  IPhoneProfile('iPhone 15', 2023, 6.1, 60),
  IPhoneProfile('iPhone 14 Pro Max', 2022, 6.7, 120),
  IPhoneProfile('iPhone 14 Pro', 2022, 6.1, 120),
  IPhoneProfile('iPhone 14 Plus', 2022, 6.7, 60),
  IPhoneProfile('iPhone 14', 2022, 6.1, 60),
  IPhoneProfile('iPhone SE (3rd generation)', 2022, 4.7, 60),
  IPhoneProfile('iPhone 13 Pro Max', 2021, 6.7, 120),
  IPhoneProfile('iPhone 13 Pro', 2021, 6.1, 120),
  IPhoneProfile('iPhone 13', 2021, 6.1, 60),
  IPhoneProfile('iPhone 13 mini', 2021, 5.4, 60),
  IPhoneProfile('iPhone 12 Pro Max', 2020, 6.7, 60),
  IPhoneProfile('iPhone 12 Pro', 2020, 6.1, 60),
  IPhoneProfile('iPhone 12', 2020, 6.1, 60),
  IPhoneProfile('iPhone 12 mini', 2020, 5.4, 60),
  IPhoneProfile('iPhone SE (2nd generation)', 2020, 4.7, 60),
  IPhoneProfile('iPhone 11 Pro Max', 2019, 6.5, 60),
  IPhoneProfile('iPhone 11 Pro', 2019, 5.8, 60),
  IPhoneProfile('iPhone 11', 2019, 6.1, 60),
  IPhoneProfile('iPhone XS Max', 2018, 6.5, 60),
  IPhoneProfile('iPhone XS', 2018, 5.8, 60),
  IPhoneProfile('iPhone XR', 2018, 6.1, 60),
  IPhoneProfile('iPhone X', 2017, 5.8, 60),
  IPhoneProfile('iPhone 8 Plus', 2017, 5.5, 60),
  IPhoneProfile('iPhone 8', 2017, 4.7, 60),
  IPhoneProfile('iPhone 7 Plus', 2016, 5.5, 60),
  IPhoneProfile('iPhone 7', 2016, 4.7, 60),
  IPhoneProfile('iPhone 6s Plus', 2015, 5.5, 60),
  IPhoneProfile('iPhone 6s', 2015, 4.7, 60),
];
