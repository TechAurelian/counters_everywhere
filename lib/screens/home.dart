// Copyright 2020-2022 TechAurelian. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

import '../common/app_strings.dart';
import '../common/settings_provider.dart';
import '../model/counter.dart';
import '../utils/utils.dart';
import '../widgets/accept_cancel_dialog.dart';
import '../widgets/counter_display.dart';

/// Overflow menu items enumeration.
enum MenuAction { reset, share, rate, help }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// The counter.
  final Counter _counter = Counter();

  Color _color = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadPersistentData();
  }

  /// Loads counter and color from persistent storage.
  Future<void> _loadPersistentData() async {
    await _counter.load();
    _color = await SettingsProvider.loadColor();
    setState(() {});
  }

  /// Performs the tasks of the popup menu items (reset, share, rate, and help).
  void popupMenuSelection(MenuAction item) {
    switch (item) {
      case MenuAction.reset:
        // Reset the counter after asking for confirmation.
        showAcceptCancelDialog(
          context,
          AppStrings.resetConfirm,
          AppStrings.resetConfirmReset,
          AppStrings.resetConfirmCancel,
          () => setState(() => _counter.reset()),
        );
        break;
      case MenuAction.share:
        // Share the current counter value using the platform's share sheet.
        final String value = toDecimalString(context, _counter.value);
        Share.share(AppStrings.shareText(value), subject: AppStrings.shareName);
        break;
      case MenuAction.rate:
        // Launch the Google Play Store page to allow the user to rate the app
        launchUrlExternal(AppStrings.rateAppURL);
        break;
      case MenuAction.help:
        // Launch the app online help url
        launchUrlExternal(AppStrings.helpURL);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).size.height >= 500;

    return Scaffold(
      appBar: _buildAppBar(),
//      drawer: _buildDrawer(),
      body: CounterDisplay(
        value: _counter.value,
        color: _color,
        isPortrait: isPortrait,
      ),
      floatingActionButton: _buildFABs(isPortrait),
    );
  }

  /// Builds the app bar with the popup menu items.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(AppStrings.appName),
      actions: <Widget>[
        PopupMenuButton<MenuAction>(
          onSelected: popupMenuSelection,
          itemBuilder: _buildMenuItems,
        ),
      ],
    );
  }

  /// Builds the popup menu items for the app bar.
  List<PopupMenuItem<MenuAction>> _buildMenuItems(BuildContext context) {
    return MenuAction.values
        .map(
          (item) => PopupMenuItem<MenuAction>(
            value: item,
            enabled: !(item == MenuAction.reset && _counter.value == 0),
            child: Text(AppStrings.menuActions[item]!),
          ),
        )
        .toList();
  }

  /// Builds the two main floating action buttons for increment and decrement.
  Widget _buildFABs(bool isPortrait) {
    return Flex(
      direction: isPortrait ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          onPressed: () => setState(() => _counter.decrement()),
          tooltip: AppStrings.decrementTooltip,
          child: const Icon(Icons.remove),
        ),
        isPortrait ? const SizedBox(height: 16.0) : const SizedBox(width: 16.0),
        FloatingActionButton(
          onPressed: () => setState(() => _counter.increment()),
          tooltip: AppStrings.incrementTooltip,
          child: const Icon(Icons.add),
        )
      ],
    );
  }
}
