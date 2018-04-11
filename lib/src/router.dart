/*
 * Dazza
 * Created by Yakka
 * http://theyakka.com
 *
 * Copyright (c) 2018 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */
part of dazza;

class Router {
  static final String rootPath = "/";
  final RouteTree _tree = new RouteTree();

  /// The [Handler] that will be executed when a passed path cannot be matched to
  /// any defined routes.
  final Handler noMatchHandler;

  Router({this.noMatchHandler});

  /// Adds a [RouteDefinition] for matching.
  void addRoute(RouteDefinition definition) => _tree.addRoute(definition);

  /// Call the route matcher. If [path] matches a defined [RouteDefinition] then
  /// it's [Handler] will respond. If you pass a [context] value then it will be
  /// passed along to the handler and any global [Handler.context] value will be
  /// ignored.
  MatchResult handle(String path, {Parameters parameters, dynamic context}) =>
      _tree.matchRouteAndHandle(
        path,
        parameters: parameters,
        noMatchHandler: noMatchHandler,
        context: context,
      );
}
