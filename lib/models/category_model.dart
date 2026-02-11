import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';


@JsonSerializable()
class CategoryType {
  final String name;
  final String imageUrl;

  CategoryType({required this.name, required this.imageUrl});

  factory CategoryType.fromJson(Map<String, dynamic> json) => _$CategoryTypeFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryTypeToJson(this);
}

@JsonSerializable()
class CategoryModel {
  final String name;
  final String imageUrl;
  final List<CategoryType> types;

  CategoryModel({
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
