library redis_client_tests;

import 'dart:async';
import 'dart:utf';

import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';

import 'package:unittest/mock.dart';

import '../lib/redis_client.dart';






main() {

  Logger.root.onRecord.listen((LogRecord record) {
    print(record.message);
  });

  group("RedisClient", () {

    RedisClient client;

    setUp(() => RedisClient.connect("127.0.0.1:6379").then((c) => client = c));

    tearDown(() => client.close());

    group("select", () {
      test("should correctly switch databases", () {
        client.set("testkey", "database0") // Setting testskey in database 0
            .then((_) => client.select(1)) // Switching to databse 1
            .then((_) => client.set("testkey", "database1"))

            .then((_) => client.select(0)) // Switching back to database 0
            .then((_) => client.get("testkey"))
            .then((value) => expect(value, equals("database0")))

            .then((_) => client.select(1)) // Switching back to database 1
            .then((_) => client.get("testkey"))
            .then((value) => expect(value, equals("database1")))

            .then(expectAsync1((_) { })); // Making sure that all tests pass asynchronously
      });
    });

    group('Basic hack tests', () {
      test("random stuff", () {
        client.set("testkey", "testvalue")
            .then((_) => client.get("testkey"))
            .then((String value) => expect(value, equals("testvalue")))
            .then(expectAsync1((_) { })); // Making sure that all tests pass asynchronously
      });
    });

  });

}