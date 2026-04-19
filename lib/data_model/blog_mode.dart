class BlogModel {
  int id;
  String title;
  String slug;
  String shortDescription;
  String description;
  String banner;
  String? metaTitle;
  String? metaDescription;
  int status;
  String category;

  BlogModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.shortDescription,
    required this.description,
    required this.banner,
    required this.metaTitle,
    required this.metaDescription,
    required this.status,
    required this.category,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? 0}') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      shortDescription: json['short_description']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      banner: json['banner']?.toString() ?? '',
      metaTitle: json['meta_title']?.toString(),
      metaDescription: json['meta_description']?.toString(),
      status: json['status'] is int
          ? json['status']
          : int.tryParse('${json['status'] ?? 0}') ?? 0,
      category: json['category']?.toString() ?? '',
    );
  }

  String? get imageUrl => banner.isEmpty ? null : banner;
}

class BlogsData {
  bool result;
  List<BlogModel> blogs;
  List<dynamic> selectedCategories;
  dynamic search;
  List<BlogModel> recentBlogs;

  BlogsData({
    required this.result,
    required this.blogs,
    required this.selectedCategories,
    required this.search,
    required this.recentBlogs,
  });

  factory BlogsData.fromJson(Map<String, dynamic> json) {
    return BlogsData(
      result: json['result'] == true,
      blogs: json['blogs'] != null && json['blogs']['data'] is List
          ? List<BlogModel>.from(
              json['blogs']['data'].map((x) => BlogModel.fromJson(x)),
            )
          : [],
      selectedCategories: json['selected_categories'] is List
          ? List<dynamic>.from(json['selected_categories'])
          : [],
      search: json['search'],
      recentBlogs: json['recent_blogs'] is List
          ? List<BlogModel>.from(
              json['recent_blogs'].map((x) => BlogModel.fromJson(x)),
            )
          : [],
    );
  }
}