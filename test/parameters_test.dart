import 'package:dazza/dazza.dart';
import 'package:test/test.dart';

main() {
  Parameters params;

  setUp(() {
    params = new Parameters.fromMap({
      "name": "Hello",
      "colors": ["red", "green", "blue"],
      "someBool": true,
      "someInt": 100,
      "someFloat": 1.5,
      "someStringBool": "true",
      "someStringInt": "400",
    });
  });

  test("Retrieve String parameter as bool", () {
    final key = "someStringBool";
    if (params.has(key)) {
      expect(params.firstBool(key), isTrue);
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve int parameter", () {
    final key = "someInt";
    if (params.has(key)) {
      expect(params.firstInt(key), equals(100));
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve String parameter as int", () {
    final key = "someStringInt";
    if (params.has(key)) {
      expect(params.firstInt(key), equals(400));
    } else {
      fail("Parameters object is not set up correctly");
    }
  });

  test("Retrieve String parameter as String", () {
    final key = "name";
    if (params.has(key)) {
      expect(params.firstString(key), equals("Hello"));
    } else {
      fail("Parameters object is not set up correctly");
    }
  });
}
