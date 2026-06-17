import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;

  CategoryModel({
    required this.name,
    required this.image,
    this.parentId = "",
    required this.isFeatured,
    required this.id,
  });

  static CategoryModel empty() => CategoryModel(
    name: "",
    image: "",
    parentId: "",
    isFeatured: false,
    id: "",
  );

  // convert to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "parentId": parentId,
    "isFeatured": isFeatured,
  };

  // convert from json
  factory CategoryModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;

      // Map JSON Record to the Model
      return CategoryModel(
        id: document.id,
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        parentId: data['parentId'] ?? '',
        isFeatured: data['isFeatured'] ?? false,
      );
    } else {
      return CategoryModel.empty();
    }
  }
}
