import 'package:graphql/client.dart';
import 'package:gql/language.dart';

class Client {  
  late GraphQLClient client;  

  Client(String url) {
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
      document: parseString('''mutation(\$input: people_insert_input!) {
          people_insert(input: \$input) {
              $fields
          } 
      }'''),
      variables: variables
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      return { 'errors': [result.exception.toString()] };
    }

    return (result.data as Map)['people_insert'];
  }

  Future<Map> find(String fields, Map<String, dynamic> variables) async {
    final QueryOptions options = QueryOptions(
      document: parseString('''query(\$filter: people_find_filter!) {
          people_find(filter: \$filter) {
              $fields
          } 
      }'''),
      variables: variables,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
       return { 'errors': [result.exception.toString()] };
    }

    return ((result.data as Map)['people_find']);
  }

  Future<Map> remove(String fields, Map<String, dynamic> variables) async {
    final QueryOptions options = QueryOptions(
      document: parseString('''mutation(\$input: people_remove_input) {
          people_remove(input: \$input) {
              $fields
          } 
      }'''),
      variables: variables
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      return { 'errors': [result.exception.toString()] };
    }

    return (result.data as Map)['people_remove'];  
  }
}