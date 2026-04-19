import 'dart:async';

import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:active_ecommerce_cms_demo_app/custom/useful_elements.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/screens/blog_posts_details.dart'
    show BlogPostsDetailsScreen;
import 'package:flutter/material.dart';

import '../../custom/paged_view/models/page_result.dart';
import '../../custom/paged_view/paged_view.dart';
import '../data_model/blog_list_post_response.dart';
import '../repositories/blog_repostries.dart';
import 'blog_posts_search_screen.dart';

class BlogCategoryPagedScreen extends StatefulWidget {
  final int? categoryId;
  final String? title;
  final String? keyword;

  const BlogCategoryPagedScreen({
    super.key,
    this.categoryId,
    this.title,
    this.keyword,
  });

  @override
  State<BlogCategoryPagedScreen> createState() =>
      _BlogCategoryPagedScreenState();
}

class _BlogCategoryPagedScreenState extends State<BlogCategoryPagedScreen> {
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

  void _openSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogCategorySearchScreen(
          categoryId: widget.categoryId,
          title: widget.title,
          keyword: _searchController.text.trim(),
        ),
      ),
    );
  }

  Future<PageResult<BlogModel>> _fetchBlogs(int page) async {
    final res = await BlogRepository().getBlogForCategories(
      page: page,
      categoryId: widget.categoryId,
      paginate: "",
      keyword: _activeKeyword,
    );

    final List<BlogModel> list = res.data ?? [];
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
/*************  ✨ Windsurf Command ⭐  *************/
/// Builds the UI for the blog posts screen.
/*******  353ff642-877e-462f-9349-bd888ed9a458  *******/        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                image: DecorationImage(
                  image: NetworkImage(blog.banner ?? ""),
                  fit: BoxFit.cover,
                ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            margin: const EdgeInsetsDirectional.only(
              end: AppDimensions.paddingDefault,
            ),
            alignment: Alignment.center,
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
            onTap: _openSearchScreen,
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
}