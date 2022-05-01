import 'dart:io';

import 'package:leto/leto.dart';
import 'package:leto_schema/leto_schema.dart';
import 'package:leto_shelf/leto_shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'database.dart';
import 'scalar_types.dart';

Future<GraphQLSchema> makeGraphQLSchema(Database db) async {  
  // insert  
  final customerInsertInput = inputObjectType(
    "customer_input", 
    fields: [
      inputField("name", graphQLString.nonNull()),
      inputField("age", graphQLInt.nonNull())
    ]
  );  

  final customersInsertInput = inputObjectType(
    "customers_insert_input", 
    fields: [
      inputField("customers", listOf(customerInsertInput.nonNull()))
    ]
  );

  final customersInsertResult = objectType(
    "customers_insert_result", 
    fields: [
      field("success", graphQLBoolean.nonNull()),
      field("message", graphQLString.nonNull())
    ]
  ); 

  // find
  final customerResultType = objectType(
    "customer", 
    fields: [
      field(
        "id", 
        scalarObjectIdGraphQLType.nonNull(), 
        resolve: (parent, ctx) => (parent as Map)['_id']
      ),
      field("name", graphQLString.nonNull()),
      field("age", graphQLInt.nonNull())
    ]
  );  

  final customersFindFilter = inputObjectType(
    "customers_find_filter", 
    fields: [
      inputField("id", scalarObjectIdGraphQLType),
      inputField("name", graphQLString),
      inputField("age", graphQLInt)
    ]
  );

  final customersFindResult = objectType(
    "customers_find_result", 
    fields: [
      field("success", graphQLBoolean.nonNull()),
      field("message", graphQLString.nonNull()),
      field("docs", listOf(customerResultType.nonNull()).nonNull())
    ]
  );

   // upsert
   final customersUpsertFilter = inputObjectType(
     "customers_upsert_filter", 
     fields: [
      inputField("id", scalarObjectIdGraphQLType),
      inputField("name", graphQLString),
      inputField("age", graphQLInt)
    ]
  );

  final customersUpsertUpdate = inputObjectType(
    "customers_upsert_update", 
    fields: [
      inputField("name", graphQLString),
      inputField("age", graphQLInt)
    ]
  );

  final customersUpsertInput = inputObjectType(
    "customers_upsert_input", 
    fields: [
      inputField("filter", customersUpsertFilter.nonNull()),
      inputField("update", customersUpsertUpdate.nonNull())
    ]
  );

  final customersUpsertResult = objectType(
    "customers_upsert_result", 
    fields: [
      field("success", graphQLBoolean.nonNull()),
      field("message", graphQLString.nonNull())
    ]
  );

  // remove
  final customersRemoveInput = inputObjectType(
    "customers_remove_input", 
    fields: [
      inputField("id", listOf(scalarObjectIdGraphQLType))
    ]
  );

  final customersRemoveResult = objectType(
    "customers_remove_result", 
    fields: [
      field("success", graphQLBoolean.nonNull()),
      field("message", graphQLString.nonNull())
    ]
  );

  var queryType = objectType("Query", 
        fields: [          
          field(
            "customers_find", 
            customersFindResult,    
            inputs: [
              GraphQLFieldInput("filter", customersFindFilter)
            ],      
            resolve: (obj, ctx) async {        
              Map<String, dynamic> filter = (ctx.args['filter'] as Map<String, dynamic>);

              if (filter.isEmpty) {
                filter = {};
              }

              if (filter.containsKey('id')) {
                filter['_id'] = filter['id'];
                filter.remove('id');
              }

              if (filter.containsKey('name')) {
                filter['\$text'] = { 
                  '\$search': filter['name'], 
                  '\$caseSensitive': false 
                };
                filter.remove('name');
              }
              
              final docs = await db.customers.find(filter).toList();
              
              return {
                'success': true, 
                'message': 'Records matching filter.', 
                'docs': docs
              };
            })
        ]);
  
  var mutationType = objectType("Mutation",
    fields:[      
      field(
        "customers_insert",
        customersInsertResult,
        inputs: [
          GraphQLFieldInput("input", customersInsertInput.nonNull())          
        ],
        resolve: (obj, ctx) async {
          final input = ctx.args['input'] as Map<String, dynamic>;
          final customers = (input['customers'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();

          final result = await db.customers.insertMany(customers);          

          return { 
            'success': result.success, 
            'message': '${result.nInserted} record(s) inserted.'
          };
        }
      ),
      field(
        "customers_upsert",
        customersUpsertResult,
        inputs: [
          GraphQLFieldInput("input", customersUpsertInput)
        ],
        resolve: (obj, ctx) async {
          Map<String, dynamic> input = ctx.args['input'] as Map<String, dynamic>;
          Map<String, dynamic> filter = input['filter'] as Map<String, dynamic>;

          if (filter.isEmpty) {
            filter = {};
          }

          if (filter.containsKey('id')) {
            filter['_id'] = filter['id'];
            filter.remove('id');
          }

          if (filter.containsKey('name')) {
            filter['\$text'] = { 
              '\$search': filter['name'], 
              '\$caseSensitive': false 
            };
            filter.remove('name');
          }

          final update = { 
            '\$set': input['update']          
          };

          final result = await db.customers.updateOne(filter, update, upsert: true);
          
          return { 
            'success': result.success, 
            'message': '${result.nModified} record(s) modified. ${result.nUpserted} record(s) upserted.'
          };
        }
      ),
      field(
        "customers_remove",
        customersRemoveResult,
        inputs: [
          GraphQLFieldInput("input", customersRemoveInput)
        ],
        resolve: (obj, ctx) async {          
          Map<String, dynamic> input = ctx.args['input'] as Map<String, dynamic>;                    
          if (input.containsKey('id')) {
            List ids = input['id'];
            input = { '_id': { "\$in" : ids } };
          }

          final result = await db.customers.deleteMany(input);

          return { 
            'success': result.success, 
            'message': '${result.nRemoved} record(s) removed.'
          };
        }
      )
    ]);

  final schema = GraphQLSchema(
    queryType: queryType,
    mutationType: mutationType
  );
  
  return schema;
}

Future<HttpServer> runServer({ScopedMap? globals}) async {  
  final ScopedMap scopedMap = globals ?? ScopedMap.empty();
  
  final db = Database(Platform.environment['MONGO_URL'] ?? "");
  await db.connectToDatabase();
  
  final schema = await makeGraphQLSchema(db);
  
  final letoGraphQL = GraphQL(
    schema,
    extensions: [],
    introspect: true,
    globalVariables: scopedMap,
  );
  
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;   
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final graphqlPath = Platform.environment['GRAPH_PATH'] ?? 'graphql';
  final host = Platform.environment['HOST'] ?? 'localhost';
  final endpoint = 'http://$host:$port/$graphqlPath';

  // Setup server endpoints
  final app = Router().plus;
  
  app.get('/status', (Request request) => {"start": DateTime.now().millisecondsSinceEpoch});

  // GraphQL HTTP handler
  app.all(
    '/$graphqlPath',
    graphQLHttp(letoGraphQL),
  );

  // GraphQL schema and endpoint explorer web UI.
  app.get(
    '/playground',
    playgroundHandler(
      config: PlaygroundConfig(
        endpoint: endpoint        
      ),
    ),
  );

  // Simple endpoint to download the GraphQLSchema as a SDL file.
  const schemaFilename = 'schema.graphql';
  app.get('/graphql-schema', (Request request) {
    return Response.ok(
      schema.schemaStr,
      headers: {
        'content-type': 'text/plain',
        'content-disposition': 'attachment; filename="$schemaFilename"'
      },
    );
  });  

  // Start the server
  final server = await serve(
    const Pipeline()
        // Configure middlewares
        .addMiddleware(customLog(log: (msg) {
          if (!msg.contains('IntrospectionQuery')) {
            print(msg);
          }
        }))
        .addMiddleware(cors())
        .addMiddleware(etag())
        .addMiddleware(jsonParse())        
        .addHandler(app),
    ip,
    port,
  );

  print(
    'GraphQL Endpoint available at $endpoint\n'    
    'GraphQL Playground UI enabled at http://$host:$port/playground',
  );

  return server;
}

void main(List<String> args) async {  
  final server = await runServer();
  print('Server listening on port ${server.port}');
}