import 'dart:convert';

BlogCategoryResponse blogCategoryResponseFromJson(String str) =>
    BlogCategoryResponse.fromJson(json.decode(str));

String blogCategoryResponseToJson(BlogCategoryResponse data) =>
    json.encode(data.toJson());

class BlogCategoryResponse {
  final bool? result;
  final List<BlogCategory>? blogCategories;

  BlogCategoryResponse({
    this.result,
    this.blogCategories,
  });

  factory BlogCategoryResponse.fromJson(Map<String, dynamic> json) {
    return BlogCategoryResponse(
      result: json["result"],
      blogCategories: json["blog_categories"] == null
          ? []
          : List<BlogCategory>.from(
              json["blog_categories"].map((x) => BlogCategory.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "result": result,
        "blog_categories": blogCategories == null
            ? []
            : List<dynamic>.from(blogCategories!.map((x) => x.toJson())),
      };
}

class BlogCategory {
  final int? id;
  final String? categoryName;
  final String? slug;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  BlogCategory({
    this.id,
    this.categoryName,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BlogCategory.fromJson(Map<String, dynamic> json) {
    return BlogCategory(
      id: json["id"],
      categoryName: json["category_name"],
      slug: json["slug"],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      deletedAt: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "slug": slug,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}