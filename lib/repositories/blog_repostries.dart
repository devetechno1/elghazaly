
import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/category_blog_response.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/api-request.dart';

import '../data_model/blog_list_post_response.dart';

class BlogRepository {
  Future<BlogCategoryResponse> getBlogCategories({page = 1, paginate}) async {
    final String url = "${AppConfig.BASE_URL}/blog-categories";

    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
        "Authorization": "Bearer ${access_token.$}",
        "System-Key": AppConfig.system_key,
      },
    );
     print("blog category body ${{response.body}}");
    return blogCategoryResponseFromJson(response.body);
  }

     Future<BlogListResponse> getBlogForCategories({
    int page = 1,
    dynamic paginate,
    int? categoryId,
    String? keyword,
  }) async {
    final String url =
        "${AppConfig.BASE_URL}/new-blog-list"
        "?category_id=${categoryId ?? ''}"
        "&paginate=${paginate ?? ''}"
        "&page=$page"
        "&search=${keyword ?? ''}";

    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
        "Authorization": "Bearer ${access_token.$}",
        "System-Key": AppConfig.system_key,
      },
    );

    print("blog list body ${response.body}");
    return blogListResponseFromJson(response.body);
  }
}