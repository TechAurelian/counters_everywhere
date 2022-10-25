// Copyright 2020-2022 TechAurelian. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import '../screens/home.dart';

/// Application wide UI and URL string constants.
class AppStrings {
  static const String appName = 'Counters Everywhere';

//#region Menu items and functionality

  static const Map<MenuAction, String> menuActions = {
    MenuAction.reset: 'Reset counter',
    MenuAction.share: 'Share...',
    MenuAction.rate: 'Rate app',
    MenuAction.help: 'Help',
  };

  static const String resetConfirm = 'Reset counter to zero?';
  static const String resetConfirmReset = 'Reset';
  static const String resetConfirmCancel = 'Cancel';

  static const String shareName = 'The counter for this device';

  static String shareText(String value) => '$shareName is $value';

  static const String rateAppURL =
      'https://play.google.com/store/apps/details?id=world.helloing.counterseverywhere';

  static const String helpURL = 'https://helloing.world/counterseverywhere/';

//#endregion

  //#region Main functionality

  static const String incrementTooltip = 'Increment';
  static const String decrementTooltip = 'Decrement';

//#endregion

}
