import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()

class CategoryModel{
  final String name;
  final String description;
  final String icon;

  CategoryModel({
    required this.name,
    required this.description,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  Map<String,dynamic> toJson() => _$CategoryModelToJson(this);
}