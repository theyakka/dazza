/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/dazza.dart';
import 'package:test/test.dart';

void main() {
  test('Check that a query string with single values can be parsed', () {
    final query = '?hello=55&testing=absd-cddjd&color=red&vegetable=turnip';
    final parameters = QueryParser().parse(query);
    expect(parameters.values.length, equals(4));
  });

  test('Check that a query string within a path can be parsed', () {
    final query = '/path/to/somewhere?hello=55&color=red&vegetable=turnip';
    final parameters = QueryParser().parse(query);
    expect(parameters.values.length, equals(3));
  });

  test('Check multi-value queries are parsed correctly', () {
    final query = '?color=red&color=blue&color=green';
    final parameters = QueryParser().parse(query);
    expect(parameters.value('color').length, equals(3));
  });

  test('Check value types are parsed correctly', () {
    final query = '?int=55&bool=true&string=hello';
    final parameters = QueryParser().parse(query);
    expect(parameters.firstInt('int'), equals(55));
    expect(parameters.firstBool('bool'), isTrue);
    expect(parameters.firstString('string'), equals('hello'));
  });
}
