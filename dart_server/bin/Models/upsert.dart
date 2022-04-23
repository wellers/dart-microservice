import 'package:shelf_plus/shelf_plus.dart';

class Upsert {
  final String? id;
  final String? name;
  final int? age;

  const Upsert({
    required this.id,
    required this.name,
    required this.age
  });

  Map<String, dynamic> toJson() => { 
    'id': id,
    'name': name,
    'age': age
  };

  factory Upsert.fromJson(Map<String, dynamic> json) {
    return Upsert(
      id: json['id'], 
      name: json['name'], 
      age: json['age']
    );
  }
}

extension UpsertAccessor on RequestBodyAccessor {
  Future<Upsert> get asUpsert async => Upsert.fromJson(await asJson);
}