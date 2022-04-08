import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:objectid/objectid.dart' as objectid;

import 'Models/person.dart';

// Configure routes.
final _router = Router()
  ..get('/', _root)
  ..get('/status', _status)
  ..get('/api/find', _find)
  ..post('/api/insert', _insert)
  ..delete('/api/remove', _remove);

Response _root(Request req) => Response.ok('Hello World!\n');

Response _status(Request request) {
  final date = DateTime.now().millisecondsSinceEpoch;

  return Response.ok(jsonEncode({"start": date}),
      headers: {'Content-type': 'application/json'});
}

Future<Response> _insert(Request request) async {
  final doc = Person.fromJson(jsonDecode(await request.readAsString()));

  if (doc.name == null || doc.name!.isEmpty) {
    return Response.ok(
        jsonEncode({'success': false, 'message': 'name is required'}),
        headers: {'Content-type': 'application/json'});
  }

  if (doc.age == null) {
    return Response.ok(
        jsonEncode({'success': false, 'message': 'age is required'}),
        headers: {'Content-type': 'application/json'});
  }

  final result = await collection.insertOne(doc.toJson());

  return Response.ok(
      jsonEncode({
        'success': result.success,
        'message': '${result.nInserted} record(s) inserted.'
      }),
      headers: {'Content-type': 'application/json'});
}

Future<Response> _find(Request request) async {
  final filter = <String, dynamic>{};

  if (request.params.containsKey('id')) {
    final String id = request.params['id'].toString();

    final int? parsed = int.tryParse(id);
    if (parsed == null) {
      return Response.ok(
          jsonEncode({'success': false, 'message': 'invalid id'}),
          headers: {'Content-type': 'application/json'});
    }

    // change to '_id' for mongodb
    filter['_id'] = parsed;
  }

  if (request.params.containsKey('name')) {
    filter['name'] = request.params['name'].toString();
  }

  if (request.params.containsKey('age')) {
    final age = request.params['age'].toString();
    final parsed = int.tryParse(age);

    if (parsed == null) {
      return Response.ok(
          jsonEncode({'success': false, 'message': 'invalid age.'}),
          headers: {'Content-type': 'application/json'});
    }

    filter['age'] = parsed;
  }

  final result = await collection.find(filter).toList() ?? {};

  final docs = result
      .map((element) => {
            'id': element['_id'],
            'name': element['name'],
            'age': element['age']
          })
      .toList();

  return Response.ok(jsonEncode({'success': true, 'docs': docs}),
      headers: {'Content-type': 'application/json'});
}

Future<Response> _remove(Request request) async {
  final input = <String, dynamic>{};
  List<ObjectId> ids = [];

  if (request.url.hasQuery) {
    final params = jsonDecode(request.url.queryParameters['id'] as String);

    if (params != null) {
      var i = 0;
      while (i < params.length) {
        var id = params[i].toString();
        if (!objectid.ObjectId.isValid(id)) {
          return Response.ok(
              jsonEncode({'success': false, 'message': 'invalid id'}),
              headers: {'Content-type': 'application/json'});
        }

        ids.add(ObjectId.fromHexString(id));
        i++;
      }
    }

    // change to '_id' for mongodb
    input['_id'] = {'\$in': ids};
  }

  final result = await collection.deleteMany(input);

  return Response.ok(
      jsonEncode({
        'success': result.success,
        'message': '${result.nRemoved} record(s) removed.'
      }),
      headers: {'Content-type': 'application/json'});
}

final url = 'mongodb://192.168.50.101:27017/my_database';
// ignore: prefer_typing_uninitialized_variables
var collection;

void main(List<String> args) async {
  final db = Db(url);
  await db.open();
  collection = db.collection('people');

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
