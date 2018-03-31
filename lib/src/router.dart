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

  /// Call the route matcher manually. If [path] matches a defined [RouteDefinition] then
  /// it's [Handler] will respond. This is useful for use-case where there is no central
  /// responder, or to allow you to build a centralized routing mechanism yourself.
  MatchResult handle(String path, {Parameters parameters}) => _tree.matchRouteAndHandle(
        path,
        parameters: parameters,
        noMatchHandler: noMatchHandler,
      );
}
