import 'package:aurora/common/context.dart';
import 'package:aurora/views/config/general.dart';
import 'package:aurora/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ConfigView extends StatelessWidget {
  const ConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: context.appLocalizations.basicConfig,
      body: generateListView(generalItems),
    );
  }
}
