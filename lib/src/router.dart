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

import 'definitions.dart';
import 'filter.dart';
import 'handlers.dart';
import 'observers.dart';
import 'tree.dart';

///
class Router {
  /// Creates a new [Router] instance
  Router({this.noMatchHandler, List<Filter> filters}) : _filters = filters;

  final RouteTree _tree = RouteTree();
  final List<LifecycleObserver> _lifecycleObservers = <LifecycleObserver>[];

  /// The [HandlerFunc] that will be executed when a passed path cannot be
  /// matched to any defined routes.
  final HandlerFunc noMatchHandler;

  final List<Filter> _filters;

  /// Defines a new [RouteDefinition] via a [HandlerFunc]
  @optionalTypeArgs
  RouteDefinition defineFunc<RT>(String path, HandlerFunc<RT> handlerFunc) {
    final definition = RouteDefinition<RT>(path, callback: handlerFunc);
    addRoute(definition);
    return definition;
  }

  /// Adds a [RouteDefinition] for matching.
  void addRoute(RouteDefinition definition) => _tree.addRoute(definition);

  /// Adds a [Filter] to the router. Filters are executed prior to the route
  /// being matched.
  void addFilter(Filter filter) => _filters.add(filter);

  /// Execute the route matcher and then call its defined [HandlerFunc] if path
  /// matches a defined [RouteDefinition]. If you pass a context value then it
  /// will be passed along to the handler and any global context value will be
  /// ignored.
  MatchResult handle(String path, {Context context, List<Filter> filters}) {
    final filterResult = _executeFilters(filters, context);
    return _tree.matchRouteAndHandle(
      path,
      context: filterResult.context,
      noMatchHandler: noMatchHandler,
    );
  }

  /// Call the route matcher directly. This is useful if you're building your
  /// own custom routing logic otherwise you probably won't use it.
  MatchResult match(String path, {Context context, List<Filter> filters}) {
    final filterResult = _executeFilters(filters, context);
    return _tree.matchRoute(
      path,
      context: filterResult.context,
    );
  }

  FilterResult _executeFilters(List<Filter> filters, Context context,
      {bool skipGlobalFilters = false}) {
    List<Filter> filtersToRun;
    if (skipGlobalFilters) {
      filtersToRun = filters;
    } else {
      filtersToRun = _filters ?? <Filter>[];
      filtersToRun.addAll(filters);
    }
    FilterResult filterResult;
    var filterContext = context;
    for (final filter in filtersToRun) {
      filterResult = filter.execute(filterContext);
      if (filterResult != FilterStatus.ok) {
        return filterResult;
      }
    }
    return filterResult;
  }

  /// Registers a lifecycle observer
  void addLifecycleObserver(LifecycleObserver observer) =>
      _lifecycleObservers.add(observer);

  /// Unregisters a lifecycle observer
  void removeLifecycleObserver(LifecycleObserver observer) =>
      _lifecycleObservers.remove(observer);

  /// Prints debugging information about the [RouteTree]
  void printTree() => _tree.printTree();
}
