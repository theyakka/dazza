/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/src/filter.dart';

import 'definitions.dart';
import 'router.dart';

/// Sub-class this class to listen to [Router] events.
abstract class LifecycleObserver {
  void willMatch(String path) {}
  void didMatch(String path, MatchStatus status) {}
  void didFilter(String path, FilterResult result) {}
}
