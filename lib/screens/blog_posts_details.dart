import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:active_ecommerce_cms_demo_app/custom/useful_elements.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../data_model/blog_list_post_response.dart';

class BlogPostsDetailsScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogPostsDetailsScreen({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.mainColor,
      appBar: AppBar(
        title: Text(
          blog.title ?? '',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: UsefulElements.backButton(),
        backgroundColor: MyTheme.mainColor,
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: SingleChildScrollView(
          child: Html(
            data: blog.description ?? '',
            style: {
              "html": Style(
                  fontSize: FontSize(
                    12,
                  ),
                  backgroundColor: MyTheme.mainColor),
            },
          ),
        ),
      ),
    );
  }
}
