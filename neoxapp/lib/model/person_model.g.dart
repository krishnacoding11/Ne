// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonModel _$PersonModelFromJson(Map<String, dynamic> json) => PersonModel(
      helper: const SIPUAHelperConverter().fromJson(json['helper'] as String),
      name: json['name'] as String,
    );

Map<String, dynamic> _$PersonModelToJson(PersonModel instance) => <String, dynamic>{
      'helper': const SIPUAHelperConverter().toJson(instance.helper),
      'name': instance.name,
    };
