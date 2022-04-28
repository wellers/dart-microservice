library dart_graphql_client;

import 'package:graphql/client.dart';
import 'package:gql/language.dart';

class DartGraphQLClient {  
  late GraphQLClient client;  

  DartGraphQLClient(String url) {
    if (url.isEmpty) {
      throw ArgumentError('GRAPH_URL is required.');
    }    

    final policies = Policies(
        fetch: FetchPolicy.noCache,
    );
  
    client = GraphQLClient(      
      cache: GraphQLCache(dataIdFromObject: (data) => null),
      link: HttpLink(url),
      defaultPolicies: DefaultPolicies(
        watchQuery: policies,
        query: policies,
        mutate: policies
      )
    );
  }

  Future<Map> insert(String fields, Map<String, dynamic> variables) async {
    final QueryOptions options = QueryOptions(
      document: parseString('''mutation(\$input: customers_insert_input!) {
          customers_insert(input: \$input) {
              $fields
          } 
      }'''),
      variables: variables
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      return { 'errors': [result.exception.toString()] };
    }

    return (result.data as Map)['customers_insert'];
  }

  Future<Map> upsert(String fields, Map<String, dynamic> variables) async {
    final QueryOptions options = QueryOptions(
      document: parseString('''mutation(\$input: customers_upsert_input!) {
          customers_upsert(input: \$input) {
              $fields
          } 
      }'''),
      variables: variables
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      return { 'errors': [result.exception.toString()] };
    }

    return (result.data as Map)['customers_upsert'];
  }

  Future<Map> find(String fields, Map<String, dynamic> variables) async {
    final QueryOptions options = QueryOptions(
      document: parseString('''query(\$filter: customers_find_filter!) {
          customers_find(filter: \$filter) {
              $fields
          } 
      }'''),
      variables: variables,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
       return { 'errors': [result.exception.toString()] };
    }

    return ((result.data as Map)['customers_find']);
  }

  Future<Map> remove(String fields, Map<String, dynamic> variables) async {
    final QueryOptions options = QueryOptions(
      document: parseString('''mutation(\$input: customers_remove_input) {
          customers_remove(input: \$input) {
              $fields
          } 
      }'''),
      variables: variables
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      return { 'errors': [result.exception.toString()] };
    }

    return (result.data as Map)['customers_remove'];  
  }
}