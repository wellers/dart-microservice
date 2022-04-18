import 'package:leto_schema/leto_schema.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:objectid/objectid.dart' as objectid;

final scalarObjectIdGraphQLType = GraphQLScalarTypeValue<ObjectId, String>(
  name: 'ScalarObjectId',
  description: 'Returns an scalar which converts a hex string to an object and back.',
  deserialize: (_, serialized) => ObjectId.parse(serialized),
  serialize: (value) => value.$oid,
  validate: (key, input) {
    if (!objectid.ObjectId.isValid(input as String)) {
      return ValidationResult.failure(['Expected $key to be a valid ObjectId']);
    }
    return ValidationResult.ok(input);
  },
  specifiedByURL: null
);