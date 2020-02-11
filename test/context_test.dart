/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2020 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/dazza.dart';
import 'package:test/test.dart';

void main() {
  test('Check that context is being created', () {
    final context = Context.initial('hello', 'world');
    final context2 = Context.withValue(context, 'testing', 'this thing');
    print(context.values.length);
    print(context2.values.length);
  });

  test('Check context value exclusion works', () {
    var context = Context.initialValues(<String, dynamic>{
      "testing": "hello",
      "color": 55,
      "base": "this thing",
      "blah": "blahblahblah",
    });
    final excludedContext = Context.withoutValue(context, 'blah');
    expect(excludedContext.has('blah'), isFalse);
  });

  test('Check typed accessors', () {
    var context = Context.initialValues(<String, dynamic>{
      'testing': 'hello',
      'color': 55,
      'isreal': true,
      'numstring': 60,
      'boolstring': 'true',
    });
    expect(context.boolValue('isreal'), isTrue);
    expect(context.intValue('color'), 55);
    expect(context.stringValue('numstring'), '60');
    expect(context.stringValue('testing'), 'hello');
    expect(context.boolValue('boolstring'), isTrue);
  });
}
