import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/screens/blog_posts_details.dart'
    show BlogPostsDetailsScreen;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../custom/paged_view/models/page_result.dart';
import '../../../custom/paged_view/paged_view.dart';
import '../../../data_model/blog_list_post_response.dart';
import '../../../repositories/blog_repostries.dart';
import '../../blog_posts_search_screen.dart';

class BlogCategorySearchList extends StatefulWidget {
  const BlogCategorySearchList({
    Key? key,
  }) : super(key: key);

  @override
  State<BlogCategorySearchList> createState() => _BlogCategorySearchListState();
}

class _BlogCategorySearchListState extends State<BlogCategorySearchList> {
  static const int _paginate = 20;

  final PagedViewController<BlogModel> _blogController =
      PagedViewController<BlogModel>();

  bool _showSearchBar = false;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _blogController.refresh();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<PageResult<BlogModel>> _fetchBlogs(int page) async {
    try {
      final res = await BlogRepository().getBlogForCategories(
        page: page,
        categoryId: null,
        paginate: "",
        keyword: "",
      );

      final List<BlogModel> list = res.data ?? [];
      final int currentPage = res.meta?.currentPage ?? 1;
      final int lastPage = res.meta?.lastPage ?? 1;
      final bool hasMore = currentPage < lastPage;

      return PageResult<BlogModel>(
        data: list,
        hasMore: hasMore,
      );
    } catch (_) {
      return const PageResult<BlogModel>(
        data: [],
        hasMore: false,
      );
    }
  }

  void _clearSearch() {
    setState(() {
      _showSearchBar = false;
      _searchController.clear();
    });
  }

  void _openSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogCategorySearchScreen(
          categoryId: null,
          title: "blog_categories_ucf".tr(context: context),
          keyword: _searchController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.mainColor,
      appBar: AppBar(
        backgroundColor: MyTheme.mainColor,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: AnimatedCrossFade(
          firstChild: _buildAppBarTitle(context),
          secondChild: _buildAppBarSearch(context),
          crossFadeState: _showSearchBar
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
          firstCurve: Curves.fastOutSlowIn,
          secondCurve: Curves.fastOutSlowIn,
        ),
      ),
      body: PagedView<BlogModel>(
        controller: _blogController,
        fetchPage: _fetchBlogs,
        layout: PagedLayout.masonry,
        gridCrossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        loadingItemBuilder: (_, index) {
          return ShimmerHelper.loadingItemBuilder(index);
        },
        emptyBuilder: (_) => Center(
          child: Text(
            'no_data_is_available'.tr(context: context),
            style: const TextStyle(
              fontSize: 14,
              color: MyTheme.font_grey,
            ),
          ),
        ),
        itemBuilder: (context, blog, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlogPostsDetailsScreen(blog: blog),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusDefault),
                image: blog.banner != null && blog.banner.toString().isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(blog.banner ?? ""),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: const Color(0xffD9E2EC),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusDefault),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.35),
                              Colors.black.withValues(alpha: 0.55),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 113, 10, 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.title ?? "",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            blog.shortDescription ?? "",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
              onPressed: () {
                setState(() {
                  _showSearchBar = true;
                });
              },
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

  Widget _buildAppBarSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: _clearSearch,
              icon: Icon(
                app_language_rtl.$!
                    ? CupertinoIcons.arrow_right
                    : CupertinoIcons.arrow_left,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              readOnly: true,
              autofocus: true,
              onTap: _openSearchScreen,
              decoration: InputDecoration(
                hintText: 'search_in_blogs'.tr(context: context),
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: MyTheme.font_grey,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.8),
                prefixIcon: IconButton(
                  onPressed: _openSearchScreen,
                  icon: const Icon(
                    Icons.search,
                    color: MyTheme.grey_153,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(
                    Icons.close,
                    color: MyTheme.grey_153,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}