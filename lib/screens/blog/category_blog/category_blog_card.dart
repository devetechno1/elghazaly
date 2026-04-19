import 'package:flutter/material.dart';

import '../../../data_model/category_blog_response.dart';
import '../../../my_theme.dart';

class BlogCategoryCard extends StatelessWidget {
  const BlogCategoryCard({
    Key? key,
    required this.category,
    this.onTap,
  }) : super(key: key);

  final BlogCategory category;
  final VoidCallback? onTap;


  Widget build(BuildContext context) {
    final String title = category.categoryName?.trim().isNotEmpty == true
        ? category.categoryName!.trim()
        : "Unnamed";

    final String slug = category.slug?.trim().isNotEmpty == true
        ? category.slug!.trim()
        : "";

    // final String createdAtText = category.createdAt != null
    //     ? category.createdAt!.toLocal().toString().split(' ')[0]
    //     : "";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: const Color.fromARGB(255, 224, 228, 233),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: MyTheme.mainColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.category,
                size: 30,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height:20,
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff121423),
                    height: 1.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            SizedBox(
              height: 18,
              child: Center(
                child: Text(
                  slug,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: MyTheme.medium_grey,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // if (createdAtText.isNotEmpty)
            //   Flexible(
            //     child: Row(
            //       children: [
            //         const Text(
            //           'Created at :',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 10,
            //             fontWeight: FontWeight.w500,
            //             color: Color(0xffA7AFB7),
            //             height: 1.1,
            //           ),
            //         ),
            //         const SizedBox(height: 2),
            //         Text(
            //           createdAtText,
            //           textAlign: TextAlign.center,
            //           maxLines: 1,
            //           overflow: TextOverflow.ellipsis,
            //           style: const TextStyle(
            //             fontSize: 8,
            //             color: MyTheme.medium_grey,
            //             height: 1.2,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}