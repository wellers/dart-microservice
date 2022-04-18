import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:objectid/objectid.dart' as objectid;

import 'Models/insert.dart';
import 'client.dart';

RouterPlus setupServer(String graphqlUrl) {  
  final graphqlClient = Client(graphqlUrl);  

  Response _root(Request req) => Response.ok('Hello World!\n');

  status(Request request) => {"start": DateTime.now().millisecondsSinceEpoch};

  insert(Request request) async {
    final Insert input = await request.body.asInsert;
    
    if (input.people.isEmpty) {
      return {
        'success': false, 
        'message': 'people collection is required'
      };
    }

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
      
    return await graphqlClient.insert('success, message', <String, dynamic>{ 'input': input });
  }

  find(Request request) async {
    final filter = <String, dynamic>{};

    if (request.url.hasQuery) {
      if (request.url.queryParameters.containsKey('id')) {
        final String id = request.url.queryParameters['id']!;

        if (!objectid.ObjectId.isValid(id.toString())) {
          return {
            'success': false, 
            'message': 'invalid id'
          };
        }
      
        filter['id'] = id;
      }

      if (request.url.queryParameters.containsKey('name')) {
        filter['name'] = request.url.queryParameters['name']!;
      }

      if (request.url.queryParameters.containsKey('age')) {
        final age = request.url.queryParameters['age']!;
        final parsed = int.tryParse(age);

        if (parsed == null) {
          return {
            'success': false, 
            'message': 'invalid age.'
          };
        }

        filter['age'] = parsed;
      }
    }  
      
    return await graphqlClient.find('docs { id, name, age }', <String, dynamic>{ 'filter': filter });  
  }

  remove(Request request) async {
    final input = <String, dynamic>{};
    List ids = [];

    if (request.url.hasQuery) {
      final params = jsonDecode(request.url.queryParameters['id']!);

      if (params != null) {      
        ids = (params is String) ? [params] : params;

        if (ids.any((id) => !objectid.ObjectId.isValid(id.toString()))) {
            return {
              'success': false,
              'message': 'invalid id'
            };
        }
      }
      
      input['id'] = ids;
    }
      
    return await graphqlClient.remove('success, message', <String, dynamic>{ 'input': input });
  }

  // Configure routes.
  final app = Router().plus;
  app.use(corsHeaders());
  
  return app
    ..get('/', _root)
    ..get('/status', status)
    ..get('/api/find', find)
    ..post('/api/insert', insert)
    ..delete('/api/remove', remove);
}

void main(List<String> args) async {  
  final graphqlUrl = Platform.environment['GRAPH_URL'] ?? "";

  final router = setupServer(graphqlUrl);  
  
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);  
  print('Server listening on port ${server.port}');
}