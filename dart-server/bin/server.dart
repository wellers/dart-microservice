import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf_io.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:objectid/objectid.dart' as objectid;

import 'Models/people.dart';
import 'client.dart';

final url = Platform.environment['GRAPH_URL'] ?? "";

final graphqlClient = Client(url);

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
  final People input = await request.body.asPeople;
  
  int counter = 0;
  while(counter < input.people.length){
    final person = input.people.elementAt(counter);
    if (person.name == null || person.name!.isEmpty) {
      return {
        'success': false, 
        'message': 'name is required'
      };
    }

    if (person.age == null) {
      return {
        'success': false, 
        'message': 'age is required'
      };
    }

    counter++;
  }  
  
  final result = await graphqlClient.insert('success, message', <String, dynamic>{ 'input': input });
  return result;
}

_find(Request request) async {
  final filter = <String, dynamic>{};

  if (request.params.containsKey('id')) {
    final String id = request.params['id'].toString();

    if (!objectid.ObjectId.isValid(id.toString())) {
      return {
        'success': false, 
        'message': 'invalid id'
      };
    }
    
    filter['id'] = id;
  }

  if (request.params.containsKey('name')) {
    filter['name'] = request.params['name'].toString();
  }

  if (request.params.containsKey('age')) {
    final age = request.params['age'];
    final parsed = int.tryParse(age!);

    if (parsed == null) {
      return {
        'success': false, 
        'message': 'invalid age.'
      };
    }

    filter['age'] = parsed;
  }
  
  final result = await graphqlClient.find('docs { id, name, age }', <String, dynamic>{ 'filter': filter });  
  return result;
}

_remove(Request request) async {
  final input = <String, dynamic>{};
  List ids = [];

  if (request.url.hasQuery) {
    final params = jsonDecode(request.url.queryParameters['id'] as String);

    if (params != null) {      
      ids = (params is String) ? [params] : params;

      if (ids.any((element) => !objectid.ObjectId.isValid(element.toString()))) {
          return {
            'success': false,
            'message': 'invalid id'
          };
      }
    }
    
    input['id'] = ids;
  }
  
  final result = await graphqlClient.remove('success, message', <String, dynamic>{ 'input': input });  
  return result;
}

void main(List<String> args) async {  

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);  
  print('Server listening on port ${server.port}');
}