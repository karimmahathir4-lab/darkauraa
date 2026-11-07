import 'package:flutter/material.dart';

import '../theme.dart';

/// Opens a screen as a normal page with a back button.
void openSubPage(BuildContext context, Widget body) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor: kBg,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SafeArea(child: body),
      ),
    ),
  );
}
