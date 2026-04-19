import 'dart:async';

import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:active_ecommerce_cms_demo_app/custom/device_info.dart';
import 'package:active_ecommerce_cms_demo_app/custom/useful_elements.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/screens/blog_posts_details.dart'
    show BlogPostsDetailsScreen;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../custom/paged_view/models/page_result.dart';
import '../../custom/paged_view/paged_view.dart';
import '../data_model/blog_list_post_response.dart';
import '../repositories/blog_repostries.dart';

class BlogCategorySearchScreen extends StatefulWidget {
  final int? categoryId;
  final String? title;
  final String? keyword;

  const BlogCategorySearchScreen({
    super.key,
    this.categoryId,
    this.title,
    this.keyword,
  });

  @override
  State<BlogCategorySearchScreen> createState() =>
      _BlogCategorySearchScreenState();
}

class _BlogCategorySearchScreenState extends State<BlogCategorySearchScreen> {
  bool _showSearchBar = true;
  late final TextEditingController _searchController;
  String _activeKeyword = "";
  Timer? _searchDebounce;

  @override
  void initState() {
    _activeKeyword = (widget.keyword ?? "").trim();
    _searchController = TextEditingController(text: _activeKeyword);
    super.initState();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _applySearch() {
    final String newKeyword = _searchController.text.trim();

    if (newKeyword == _activeKeyword) return;

    setState(() {
      _activeKeyword = newKeyword;
    });
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _applySearch();
    });
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    setState(() {
      _searchController.clear();
      _activeKeyword = "";
    });
  }

  List<BlogModel> _mapRecentBlogsToBlogModels(List<RecentBlog>? recentBlogs) {
    if (recentBlogs == null || recentBlogs.isEmpty) {
      return [];
    }

    return recentBlogs.map((recent) {
      return BlogModel(
        id: recent.id,
        title: recent.title,
        slug: recent.slug,
        shortDescription: recent.shortDescription,
        description: recent.description,
        banner: recent.banner?.toString(),
        metaTitle: recent.metaTitle,
        metaDescription: recent.metaDescription,
        status: recent.status,
        category: null,
        categoryId: recent.categoryId,
      );
    }).toList();
  }

  String _resolveImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) {
      return "";
    }

    final String value = path.trim();

    if (value.startsWith("http://") || value.startsWith("https://")) {
      return value;
    }

    if (value.startsWith("/")) {
      return "${AppConfig.BASE_URL}$value";
    }

    if (RegExp(r'^\d+$').hasMatch(value)) {
      return "";
    }

    return "${AppConfig.BASE_URL}/$value";
  }

  Future<PageResult<BlogModel>> _fetchBlogs(int page) async {
    final res = await BlogRepository().getBlogForCategories(
      page: page,
      categoryId: widget.categoryId,
      paginate: "",
      keyword: _activeKeyword,
    );

    final List<BlogModel> list = (res.data != null && res.data!.isNotEmpty)
        ? res.data!
        : _mapRecentBlogsToBlogModels(res.recentBlogs);

    final int currentPage = res.meta?.currentPage ?? 1;
    final int lastPage = res.meta?.lastPage ?? 1;
    final bool hasMore = currentPage < lastPage;

    return PageResult<BlogModel>(
      data: list,
      hasMore: hasMore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: MyTheme.mainColor,
      body: PagedView<BlogModel>(
        key: ValueKey("blog_${widget.categoryId}_${_activeKeyword}"),
        fetchPage: _fetchBlogs,
        layout: PagedLayout.masonry,
        gridCrossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        loadingItemBuilder: (_, index) {
          return ShimmerHelper.loadingItemBuilder(index);
        },
        emptyBuilder: (context) {
          return Center(
            child: Text(
              'no_data_is_available'.tr(context: context),
              style: const TextStyle(color: MyTheme.font_grey),
            ),
          );
        },
        itemBuilder: (context, blog, index) {
          final String imageUrl = _resolveImageUrl(blog.banner);

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
                color: Colors.grey.shade300,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusDefault),
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusDefault),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: imageUrl.isEmpty
                              ? Colors.grey.shade300
                              : Colors.transparent,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.5),
                              Colors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 113, 10, 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.title ?? "",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            blog.title ?? "",
                            style: const TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: Colors.white70,
                            ),
                          ),
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      backgroundColor: MyTheme.mainColor,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
        ),
      ),
      title: buildAppBarTitle(context),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildAppBarTitle(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: buildAppBarTitleOption(context),
      secondChild: buildAppBarSearchOption(context),
      firstCurve: Curves.fastOutSlowIn,
      secondCurve: Curves.fastOutSlowIn,
      crossFadeState:
          _showSearchBar ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 500),
    );
  }

  Container buildAppBarTitleOption(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 37),
      child: Row(
        children: [
          Container(
            width: 20,
            margin: const EdgeInsetsDirectional.only(
              end: AppDimensions.paddingDefault,
            ),
            child: UsefulElements.backButton(color: "black"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.paddingSupSmall,
              ),
              child: Text(
                widget.title ?? 'blogs_ucf'.tr(context: context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showSearchBar = true;
              });
            },
            child: const Icon(
              Icons.search,
              size: 20,
              color: MyTheme.dark_grey,
            ),
          ),
        ],
      ),
    );
  }

  Container buildAppBarSearchOption(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: DeviceInfo(context).width,
      height: 40,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? CupertinoIcons.arrow_right
                  : CupertinoIcons.arrow_left,
              color: MyTheme.dark_grey,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              onSubmitted: (_) => _applySearch(),
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: _applySearch,
                  icon: const Icon(
                    Icons.search,
                    color: MyTheme.grey_153,
                  ),
                ),
                filled: true,
                fillColor: MyTheme.white.withValues(alpha: 0.6),
                hintText: 'search_in_blogs'.tr(context: context),
                hintStyle: const TextStyle(
                  fontSize: 14.0,
                  color: MyTheme.font_grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: MyTheme.noColor,
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusHalfSmall,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: MyTheme.noColor,
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusHalfSmall,
                  ),
                ),
                contentPadding: const EdgeInsets.all(8.0),
                suffixIcon: _activeKeyword.isNotEmpty
                    ? IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(
                          Icons.close,
                          color: MyTheme.grey_153,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}