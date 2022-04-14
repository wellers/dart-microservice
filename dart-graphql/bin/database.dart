import 'package:mongo_dart/mongo_dart.dart';

class Database {
  String _url = "";
  late DbCollection people;

  Database(String url) {
    _url = url;
  }

  Future connectToDatabase() async {
    if (_url.isEmpty) {
      throw ArgumentError('url is required');
    }

    final database = Db(_url);
    await database.open();
  
    people = database.collection('people');     
  }
}