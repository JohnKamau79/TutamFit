import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryType {
  final String? id;
  final String name;
  final String? imageUrl;

  CategoryType({this.id ,required this.name, required this.imageUrl});

  factory CategoryType.fromJson(Map<String, dynamic> json) =>
      _$CategoryTypeFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryTypeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CategoryModel {
  final String? id;
  final String name;
  final String? imageUrl;
  // @JsonKey(fromJson: _typesFromJson)
  final List<CategoryType>? types;

  CategoryModel({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  // static List<CategoryType> _typesFromJson(List<dynamic>? json) {
  //   if (json == null) return [];
  //   return json
  //       .map((e) => CategoryType.fromJson(e as Map<String, dynamic>))
  //       .toList();
  // }
}
