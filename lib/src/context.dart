/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:collection';

import 'conversions.dart';
import 'parameters.dart';
import 'value_store.dart';

/// Retrieve the original path from the [Context]
const String contextKeyPath = '_dazza.__path';

/// Retrieve the route [Parameters] from the [Context]
const String contextKeyParameters = '_dazza.__routeParameters';

/// Context is an immutable key/value store that is used to store artbitrary
/// values to be passed to routes (or any other purpose, I guess).
class Context {
  /// Create an empty [Context].
  Context.empty();

  /// Create a [Context] object and populate it with one initial value
  Context.initial(String key, dynamic value)
      : assert(key != null),
        assert(value != null) {
    _valueStore[key] = value;
  }

  /// Create a [Context] object and populate it with some initial values
  Context.initialValues(Map<String, dynamic> values) : assert(values != null) {
    _valueStore.values.addAll(values);
  }

  /// Create a new [Context] from an existing [Context] and append a value to
  /// the existing values
  Context.withValue(Context parent, String key, dynamic value)
      : assert(parent != null),
        assert(key != null),
        assert(value != null) {
    _valueStore.setAll(parent._valueStore);
    _valueStore[key] = value;
  }

  /// Create a new [Context] from an existing [Context] and append multiple
  /// values to the existing values
  Context.withValues(Context parent, Map<String, dynamic> values)
      : assert(parent != null),
        assert(values != null) {
    _valueStore.setAll(parent._valueStore);
    _valueStore.values.addAll(values);
  }

  /// Merge two [Context] objects. The parent context will be overridden
  /// if there is a conflict.
  Context.withContext(Context parent, Context merge)
      : assert(parent != null),
        assert(merge != null) {
    _valueStore.setAll(parent._valueStore);
    _valueStore.values.addAll(merge.values);
  }

  /// Create a new [Context] from an existing [Context] but omit the value
  /// stored for [key]
  Context.withoutValue(Context parent, String key)
      : assert(parent != null),
        assert(key != null) {
    _valueStore.setAll(parent._valueStore);
    _valueStore.remove(key);
  }

  final ValueStore<String, dynamic> _valueStore = ValueStore<String, dynamic>();

  /// Get all of the values currently stored in the [Context] object (no keys)
  Map<String, dynamic> get values => _valueStore.values;

  /// Get the raw context value for the provided [key]
  dynamic value(String key) => _valueStore[key];

  /// Get the context value for the provided [key] and convert it to a [String]
  String stringValue(String key) => Conversion.stringValue(_valueStore[key]);

  /// Get the context value for the provided [key] and convert it to a [bool]
  bool boolValue(String key) => Conversion.boolValue(_valueStore[key]);

  /// Get the context value for the provided [key] and convert it to an [int]
  int intValue(String key) => Conversion.intValue(_valueStore[key]);

  /// Convenience method for creating a new context using the current [Context]
  /// as the parent. See [Context.withValue].
  Context withValue(String key, dynamic value) =>
      Context.withValue(this, key, value);

  /// Convenience method for creating a new context using the current [Context]
  /// as the parent. See [Context.withValues].
  Context withValues(Map<String, dynamic> valuePairs) =>
      Context.withValues(this, values);

  /// Convenience getter for the parameters value
  Parameters get parameters =>
      _valueStore[contextKeyParameters] ?? Parameters();

  /// Add a set of parameters to the existing (if any) set of parameters
  /// defined within this context.
  Parameters addParameters(Parameters parametersToAdd) {
    var currentParameters = parameters;
    if (currentParameters != null) {
      currentParameters.addParameters(parametersToAdd);
    } else {
      currentParameters = parametersToAdd;
    }
    _valueStore[contextKeyParameters] = currentParameters;
    return currentParameters;
  }

  /// Resets the context values.
  void reset() => _valueStore.clear();

  /// Check to see if a parameter is defined.
  bool has(String key) => _valueStore.has(key);
}
