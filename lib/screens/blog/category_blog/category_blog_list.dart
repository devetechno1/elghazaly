import 'package:active_ecommerce_cms_demo_app/data_model/category_blog_response.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../custom/paged_view/models/page_result.dart';
import '../../../custom/paged_view/paged_view.dart';
import '../../../repositories/blog_repostries.dart';
import '../../Blog_posts_screen.dart';
import '../../blog_posts_search_screen.dart';

class BlogCategoryList extends StatefulWidget {
  const BlogCategoryList({
    Key? key,
  }) : super(key: key);

  @override
  State<BlogCategoryList> createState() => _BlogCategoryListState();
}

class _BlogCategoryListState extends State<BlogCategoryList> {
  final PagedViewController<BlogCategory> _blogCategoryController =
      PagedViewController<BlogCategory>();

  static const int _paginate = 20;

  @override
  void initState() {
    super.initState();
    _blogCategoryController.refresh();
  }

  Future<PageResult<BlogCategory>> _fetchBlogCategories(int page) async {
    try {
      final BlogCategoryResponse res = await BlogRepository().getBlogCategories(
        page: page,
        paginate: _paginate,
      );

      final List<BlogCategory> list = res.blogCategories ?? [];
      final bool hasMore = list.length >= _paginate;

      return PageResult<BlogCategory>(
        data: list,
        hasMore: hasMore,
      );
    } catch (_) {
      return const PageResult<BlogCategory>(
        data: [],
        hasMore: false,
      );
    }
  }

  void _openSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogCategorySearchScreen(
          categoryId: null,
          title: "blog_categories_ucf".tr(context: context),
          keyword: "",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF1F5),
      appBar: AppBar(
        backgroundColor: MyTheme.mainColor,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: _buildAppBarTitle(context),
      ),
      body: Container(
        color: const Color(0xffECF1F5),
        child: PagedView<BlogCategory>(
          controller: _blogCategoryController,
          fetchPage: _fetchBlogCategories,
          layout: PagedLayout.list,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          emptyBuilder: (_) => Center(
            child: Text(
              'no_category_is_available'.tr(context: context),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          itemBuilder: (context, blogCategory, index) {
            final String title =
                blogCategory.categoryName?.trim().isNotEmpty == true
                    ? blogCategory.categoryName!.trim()
                    : "Unnamed";

            final String slug = blogCategory.slug?.trim().isNotEmpty == true
                ? blogCategory.slug!.trim()
                : "";

            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogCategoryPagedScreen(
                      categoryId: blogCategory.id,
                    ),
                  ),
                );
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xffE6ECF2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff121423),
                            ),
                          ),
                          // if (slug.isNotEmpty) ...[
                          //   const SizedBox(height: 4),
                          //   Text(
                          //     slug,
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //     style: const TextStyle(
                          //       fontSize: 12,
                          //       color: Color(0xff6B7280),
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      app_language_rtl.$!
                          ? CupertinoIcons.right_chevron
                          : CupertinoIcons.right_chevron,
                      size: 18,
                      color: const Color(0xff6B7280),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                app_language_rtl.$!
                    ? CupertinoIcons.arrow_right
                    : CupertinoIcons.arrow_left,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "blog_categories_ucf".tr(context: context),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff121423),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: _openSearchScreen,
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}