import 'dart:convert';

BlogListResponse blogListResponseFromJson(String str) =>
    BlogListResponse.fromJson(json.decode(str));

String blogListResponseToJson(BlogListResponse data) =>
    json.encode(data.toJson());

class BlogListResponse {
  final List<BlogModel>? data;
  final BlogLinks? links;
  final BlogMeta? meta;
  final bool? success;
  final int? status;
  final bool? result;
  final String? categoryId;
  final dynamic search;
  final List<RecentBlog>? recentBlogs;

  BlogListResponse({
    this.data,
    this.links,
    this.meta,
    this.success,
    this.status,
    this.result,
    this.categoryId,
    this.search,
    this.recentBlogs,
  });

  factory BlogListResponse.fromJson(Map<String, dynamic> json) {
    return BlogListResponse(
      data: json["data"] == null
          ? []
          : List<BlogModel>.from(
              json["data"].map((x) => BlogModel.fromJson(x)),
            ),
      links: json["links"] == null ? null : BlogLinks.fromJson(json["links"]),
      meta: json["meta"] == null ? null : BlogMeta.fromJson(json["meta"]),
      success: json["success"],
      status: json["status"],
      result: json["result"],
      categoryId: json["category_id"]?.toString(),
      search: json["search"],
      recentBlogs: json["recent_blogs"] == null
          ? []
          : List<RecentBlog>.from(
              json["recent_blogs"].map((x) => RecentBlog.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
        "success": success,
        "status": status,
        "result": result,
        "category_id": categoryId,
        "search": search,
        "recent_blogs": recentBlogs == null
            ? []
            : List<dynamic>.from(recentBlogs!.map((x) => x.toJson())),
      };
}

class BlogLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  BlogLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory BlogLinks.fromJson(Map<String, dynamic> json) {
    return BlogLinks(
      first: json["first"]?.toString(),
      last: json["last"]?.toString(),
      prev: json["prev"]?.toString(),
      next: json["next"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class BlogMeta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<MetaLink>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  BlogMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory BlogMeta.fromJson(Map<String, dynamic> json) {
    return BlogMeta(
      currentPage: json["current_page"],
      from: json["from"],
      lastPage: json["last_page"],
      links: json["links"] == null
          ? []
          : List<MetaLink>.from(
              json["links"].map((x) => MetaLink.fromJson(x)),
            ),
      path: json["path"]?.toString(),
      perPage: json["per_page"],
      to: json["to"],
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class MetaLink {
  final String? url;
  final String? label;
  final bool? active;

  MetaLink({
    this.url,
    this.label,
    this.active,
  });

  factory MetaLink.fromJson(Map<String, dynamic> json) {
    return MetaLink(
      url: json["url"]?.toString(),
      label: json["label"]?.toString(),
      active: json["active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class BlogModel {
  final int? id;
  final String? title;
  final String? slug;
  final String? shortDescription;
  final String? description;
  final String? banner;
  final String? metaTitle;
  final String? metaDescription;
  final int? status;
  final String? category;
  final int? categoryId;

  BlogModel({
    this.id,
    this.title,
    this.slug,
    this.shortDescription,
    this.description,
    this.banner,
    this.metaTitle,
    this.metaDescription,
    this.status,
    this.category,
    this.categoryId,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json["id"],
      title: json["title"]?.toString(),
      slug: json["slug"]?.toString(),
      shortDescription: json["short_description"]?.toString(),
      description: json["description"]?.toString(),
      banner: json["banner"]?.toString(),
      metaTitle: json["meta_title"]?.toString(),
      metaDescription: json["meta_description"]?.toString(),
      status: json["status"],
      category: json["category"]?.toString(),
      categoryId: json["category_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "short_description": shortDescription,
        "description": description,
        "banner": banner,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "status": status,
        "category": category,
        "category_id": categoryId,
      };
}

class RecentBlog {
  final int? id;
  final int? categoryId;
  final String? title;
  final String? slug;
  final String? shortDescription;
  final String? description;
  final dynamic banner;
  final String? metaTitle;
  final dynamic metaImg;
  final String? metaDescription;
  final dynamic metaKeywords;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  RecentBlog({
    this.id,
    this.categoryId,
    this.title,
    this.slug,
    this.shortDescription,
    this.description,
    this.banner,
    this.metaTitle,
    this.metaImg,
    this.metaDescription,
    this.metaKeywords,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory RecentBlog.fromJson(Map<String, dynamic> json) {
    return RecentBlog(
      id: json["id"],
      categoryId: json["category_id"],
      title: json["title"]?.toString(),
      slug: json["slug"]?.toString(),
      shortDescription: json["short_description"]?.toString(),
      description: json["description"]?.toString(),
      banner: json["banner"],
      metaTitle: json["meta_title"]?.toString(),
      metaImg: json["meta_img"],
      metaDescription: json["meta_description"]?.toString(),
      metaKeywords: json["meta_keywords"],
      status: json["status"],
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
        "category_id": categoryId,
        "title": title,
        "slug": slug,
        "short_description": shortDescription,
        "description": description,
        "banner": banner,
        "meta_title": metaTitle,
        "meta_img": metaImg,
        "meta_description": metaDescription,
        "meta_keywords": metaKeywords,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}