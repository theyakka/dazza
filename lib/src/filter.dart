/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/dazza.dart';
import 'package:meta/meta.dart';

/// A [Filter] allows you to execute custom code
abstract class Filter<T> {
  /// Execute the Filter. This is where you provide your custom logic.
  FilterResult<T> execute(Context context);

  /// Emit a result so that the [Router] can determine the current Filter chain
  /// status.
  FilterResult next(FilterStatus status, T result, Context context) {
    return FilterResult<T>(status: status, context: context, value: result);
  }

  /// The Filter executed normally and the process should continue.
  FilterResult ok(T result, Context context) =>
      next(FilterStatus.ok, result, context);

  /// The Filter executed normally but we want the process to stop.
  FilterResult stop(T result, Context context) =>
      next(FilterStatus.stop, result, context);

  /// The Filter encountered an erro and the process should stop.
  FilterResult error(T result, Context context) =>
      next(FilterStatus.error, result, context);
}

class FilterResult<T> {
  FilterResult({@required this.status, @required this.context, this.value});
  FilterStatus status;
  T value;
  Context context;
}

enum FilterStatus {
  ok,
  stop,
  error,
}
