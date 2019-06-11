/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:meta/meta.dart';

import 'context.dart';
import 'filter.dart';
import 'handlers.dart';
import 'parameters.dart';
import 'router.dart';

/// The default value for the root path.
final String defaultRootPath = '/';

/// The character that denotes the start of a query string.
final String queryPrefix = '?';

/// The character that separates the components of a path string.
final String pathSeparator = '/';

/// Define a route for matching. The [path] value defines how your route will
/// be matched.
///
/// The route path format can take on one of the following formats:
///
/// **Normal**: The path must match the format exactly. e.g.: '/users/list'.
///
/// **Named parameters**: Part of the route format will be extracted as a named
/// parameter. e.g.: If requesting '/users/55' against the format
/// '/users/:userid', the final [Parameters] object will contain a parameter
/// 'userid' with the value '55'.
///
/// **Wildcard parameters**: Part of the path can accept any value.
/// e.g.: /images/*.
///
/// The callback function will be called if the route is matched by the
/// [Router].
///
/// If you wish, you can pass additional context values. Any context values
/// defined at the route level will have the lowest priority. If a [Filter] or a
/// routing operation overwrites a context value then they will take priority
/// (in that order).
class RouteDefinition<T> {
  /// Create a new Route definition.
  RouteDefinition(this.path, {@required this.callback, this.context});

  /// The route path format you want to match against.
  String path;

  /// The handler function  that will respond if a url matches the path format.
  HandlerFunc<T> callback;

  /// Global context values attached to the route. These values will be passed
  /// to the callback every time the route is executed.
  Context context;
}

///
class MatchResult {
  ///
  MatchResult({
    @required this.route,
    this.matchStatus = MatchStatus.matched,
    this.statusMessage,
    Context context,
    this.result,
  }) : context = context ?? Context.empty();

  /// Convenience function to return a matched result.
  MatchResult.matched({
    Context context,
    @required this.route,
    this.result,
  })  : matchStatus = MatchStatus.matched,
        statusMessage = null,
        context = context ?? Context.empty();

  /// Convenience function to return a non-matched result.
  MatchResult.noMatch({
    Context context,
    this.result,
  })  : matchStatus = MatchStatus.notMatched,
        statusMessage = 'Unable to match route.',
        route = null,
        context = context ?? Context.empty();

  /// The status of the match. Was the route matched, not matched or was there
  /// an exception of some kind.
  final MatchStatus matchStatus;

  /// Any additional status message. This could be empty.
  final String statusMessage;

  /// The [RouteDefinition] that was matched by the matcher.
  final RouteDefinition route;

  /// Any context values. By default the matcher will populate the context with
  /// the path requested ([contextKeyPath]) and the parameters
  /// ([contextKeyParameters]).
  final Context context;

  /// TODO - ??
  dynamic result;

  /// Helper to check if the match status indicates that the route was matched.
  bool get wasMatched => matchStatus == MatchStatus.matched;

  /// Helper to check if the match status indicates that the route was not
  /// matched.
  bool get wasNotMatched => matchStatus != MatchStatus.matched;

  /// Helper to check if the match status indicates that the matcher was halted.
  bool get wasHalted => matchStatus == MatchStatus.halted;
}

/// Whether the matching operation found a match or not. This is not a simple
/// [bool] because we may want to extend the matcher in the future to deal with
/// other match types.
enum MatchStatus {
  /// There was a match
  matched,

  /// There was no match
  notMatched,

  /// The matcher stopped because a [Filter] stopped the operation or returned
  /// an error
  halted,
}

/// The type of node in the route tree
enum RouteTreeNodeType {
  /// The node is a path component
  component,

  /// The node is a named parameter
  parameter,

  /// The node is a wildcard component
  wildcard,
}
