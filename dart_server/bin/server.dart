import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:objectid/objectid.dart' as objectid;

import 'Models/insert.dart';
import 'Models/upsert.dart';
import 'client.dart';

RouterPlus setupServer(String graphqlUrl) {  
  final graphqlClient = Client(graphqlUrl);  

  Response _root(Request req) => Response.ok('Hello World!\n');

  status(Request request) => {"start": DateTime.now().millisecondsSinceEpoch};

  insert(Request request) async {
    final Insert input = await request.body.asInsert;
    
    if (input.customers.isEmpty) {
      return {
        'success': false, 
        'message': 'customers collection is required'
      };
    }

    int counter = 0;
    while(counter < input.customers.length){
      final customer = input.customers.elementAt(counter);
      if (customer.name == null || customer.name!.isEmpty) {
        return {
          'success': false, 
          'message': 'name is required'
        };
      }

      if (customer.age == null) {
        return {
          'success': false, 
          'message': 'age is required'
        };
      }

      counter++;
    }  
      
    return await graphqlClient.insert('success, message', <String, dynamic>{ 'input': input });
  }

  upsert(Request request) async {
    final Upsert input = await request.body.asUpsert;
    
    if (input.id == null) {
      return {
        'success': false, 
        'message': 'id is required'
      };
    }
    
    Map<String, dynamic> update = {};
    if (input.name != null && input.name!.isNotEmpty) {      
      update['name'] = input.name;
    }

    if (input.age != null && !input.age!.isNaN) {
      update['age'] = input.age;
    }  

    final variables = {
      'input': {
        'filter': { 'id': input.id },
        'update': update
      }
    };

    return await graphqlClient.upsert('success, message', variables);
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
    ..post('/api/upsert', upsert)
    ..get('/api/remove', remove);
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