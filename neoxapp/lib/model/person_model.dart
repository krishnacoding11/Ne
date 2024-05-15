import 'package:json_annotation/json_annotation.dart';
import 'package:neoxapp/model/sipua_converer.dart';
import 'package:sip_ua/sip_ua.dart';

// part 'person_model.g_ca.dart';
part 'person_model.g.dart';

@JsonSerializable()
@SIPUAHelperConverter()
class PersonModel {
  // @SIPUAHelperConverter(helper)

  SIPUAHelper helper;

  // Map<Type, List<dynamic>> listernerList;
  String name;

  PersonModel({required this.helper, required this.name});

  factory PersonModel.fromJson(Map<String, dynamic> json) => _$PersonModelFromJson(json);
//
  Map<String, dynamic> toJson() => _$PersonModelToJson(this);

  // factory PersonModel.fromJson(Map<String, dynamic> json) =>
  //     PersonModel(helper: json['helper'], name: json['name']);
  //
  // Map<String, dynamic> toJson() => {"helper": helper, "name": name};
}
