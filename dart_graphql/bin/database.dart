import 'package:mongo_dart/mongo_dart.dart';

class Database {
  String _url = "";
  late DbCollection customers;

  Database(String url) {
    _url = url;
  }

  Future connectToDatabase() async {
    if (_url.isEmpty) {
      throw ArgumentError('url is required');
    }

    final database = Db(_url);
    await database.open();
  
    customers = database.collection('customers');
    await customers.createIndex(keys: { 'name': 'text' });
  }
}