import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf_io.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:objectid/objectid.dart' as objectid;

import 'Models/person.dart';

// Configure routes.
final _router = Router().plus
  ..get('/', _root)
  ..get('/status', _status)
  ..get('/api/find', _find)
  ..post('/api/insert', _insert)
  ..delete('/api/remove', _remove);

Response _root(Request req) => Response.ok('Hello World!\n');

_status(Request request) => {"start": DateTime.now().millisecondsSinceEpoch};

_insert(Request request) async {
  final doc = await request.body.asPerson;

  if (doc.name == null || doc.name!.isEmpty) {
    return {'success': false, 'message': 'name is required'};
  }

  if (doc.age == null) {
    return {'success': false, 'message': 'age is required'};
  }

  final result = await db.insertOne(doc.toJson());

  return {
        'success': result.success,
        'message': '${result.nInserted} record(s) inserted.'
      };
}

_find(Request request) async {
  final filter = <String, dynamic>{};

  if (request.params.containsKey('id')) {
    final String id = request.params['id'].toString();

    final int? parsed = int.tryParse(id);
    if (parsed == null) {
      return {'success': false, 'message': 'invalid id'};
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
      return {'success': false, 'message': 'invalid age.'};
    }

    filter['age'] = parsed;
  }

  final docs = await db.find(filter).toList() ?? {};

  final mapped = docs.map((element) => {
            'id': element['_id'],
            'name': element['name'],
            'age': element['age']
          })
      .toList();

  return {'success': true, 'docs': mapped};
}

_remove(Request request) async {
  final input = <String, dynamic>{};
  List<ObjectId> ids = [];

  if (request.url.hasQuery) {
    final params = jsonDecode(request.url.queryParameters['id'] as String);

    if (params != null) {
      var i = 0;
      while (i < params.length) {
        var id = params[i].toString();
        if (!objectid.ObjectId.isValid(id)) {
          return {'success': false, 'message': 'invalid id'};
        }

        ids.add(ObjectId.fromHexString(id));
        i++;
      }
    }

    // change to '_id' for mongodb
    input['_id'] = {'\$in': ids};
  }

  final result = await db.deleteMany(input);

  return {'success': result.success, 'message': '${result.nRemoved} record(s) removed.'};
}

final url = Platform.environment['MONGO_URL'] ?? "";
// ignore: prefer_typing_uninitialized_variables
var db;

void main(List<String> args) async {
  final database = Db(url);
  await database.open();
  db = database.collection('people');

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
