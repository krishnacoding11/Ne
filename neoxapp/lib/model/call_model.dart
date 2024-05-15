import 'package:sip_ua/sip_ua.dart';

class Caller {
  String name;
  int age;
  Call callObj;

  Caller({required this.name, required this.age, required this.callObj});

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'callObj': callObj,
      };

  factory Caller.fromJson(Map<dynamic, dynamic> json) => Caller(name: json['name'], age: json['age'], callObj: json['callObj']);
}
