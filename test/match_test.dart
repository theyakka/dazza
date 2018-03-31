import 'package:dazza/dazza.dart';
import 'package:test/test.dart';

main() {

  Router router;

  setUp(() {
    router = new Router(
      noMatchHandler: new Handler(callback: noMatchCallback),
    );
    router.addRoute(new RouteDefinition.withCallback("/users", callback: genericMatchCallback));
    router.addRoute(new RouteDefinition.withCallback("/users/profile", callback: profileMatchCallback));
    router.addRoute(new RouteDefinition.withCallback("/users/:id", callback: userMatchCallback));
    router.addRoute(new RouteDefinition.withCallback("/users/list", callback: genericMatchCallback));
  });

  test("Match non-wildcard route", () {
    final expectedResult = 200;
    expect(router.handle("/users", parameters: new Parameters.fromMap({
      "expectedResult" : [ expectedResult ],
    })).result, equals(expectedResult));
  });

  test("Match wildcard route", () {
    final userId = "55";
    expect(router.handle("/users/$userId").result, equals(userId));
  });

  test("Prioritize non-wildcard route over later defined wildcard one", () {
    expect(router.handle("/users/profile").result, equals("myProfile"));
  });

  test("Prioritize wildcard route over later defined non-wildcard one", () {
    final expectedResult = "testList";
    expect(router.handle("/users/list", parameters: new Parameters.fromMap({
      "expectedResult" : [ expectedResult ],
    })).result, isNot("testList"));
  });

  test("Match querystring parameter", () {
    final expectedResult = "750";
    expect(router.handle("/users?expectedResult=$expectedResult").result, equals(expectedResult));
  });

}

dynamic genericMatchCallback(Parameters parameters, dynamic context) {
  return parameters.first("expectedResult");
}

dynamic userMatchCallback(Parameters parameters, dynamic context) {
  return parameters.firstString("id");
}

dynamic profileMatchCallback(Parameters parameters, dynamic context) {
  return "myProfile";
}

dynamic noMatchCallback(Parameters parameters, dynamic context) {
  return -1;
}
