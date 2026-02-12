// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryType _$CategoryTypeFromJson(Map<String, dynamic> json) => CategoryType(
  id: json['id'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$CategoryTypeToJson(CategoryType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
    };

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      types: CategoryModel._typesFromJson(json['types'] as List?),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'types': instance.types,
    };
