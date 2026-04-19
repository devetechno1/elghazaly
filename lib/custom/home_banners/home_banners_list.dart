import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';

import '../../app_config.dart';
import '../../data_model/slider_response.dart';
import '../../services/navigation_service.dart';
import '../aiz_image.dart';
import '../dynamic_size_image_banner.dart';

class HomeBannersList extends StatefulWidget {
  final bool isBannersInitial;
  final List<AIZSlider> bannersImagesList;
  final double fallbackAspectRatio;
  final double aspectRatio;
  final double viewportFraction;
  final bool padEnds;
  final bool? enlargeCenterPage;
  final bool makeOneBannerDynamicSize;
  final CenterPageEnlargeStrategy enlargeStrategy;

  const HomeBannersList({
    Key? key,
    required this.isBannersInitial,
    this.aspectRatio = 1.1,
    required this.bannersImagesList,
    this.fallbackAspectRatio = 2.0,
    this.viewportFraction = 0.49,
    this.padEnds = false,
    this.enlargeCenterPage = false,
    this.makeOneBannerDynamicSize = true,
    this.enlargeStrategy = CenterPageEnlargeStrategy.scale,
  }) : super(key: key);

  @override
  State<HomeBannersList> createState() => _HomeBannersListState();
}

class _HomeBannersListState extends State<HomeBannersList> {
  late PageController _pageController;
  int _currentPage = 0;
  final Map<int, double> _aspectByIndex = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);

    if (widget.bannersImagesList.isNotEmpty) {
      _resolveAspect(0, widget.bannersImagesList[0].photo);
    }
  }

  @override
  void didUpdateWidget(covariant HomeBannersList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bannersImagesList != widget.bannersImagesList &&
        widget.bannersImagesList.isNotEmpty) {
      _aspectByIndex.clear();
      _currentPage = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resolveAspect(0, widget.bannersImagesList[0].photo);
      });
    }

    if (oldWidget.viewportFraction != widget.viewportFraction) {
      final oldController = _pageController;
      _pageController = PageController(
        initialPage: _currentPage,
        viewportFraction: widget.viewportFraction,
      );
      oldController.dispose();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _resolveAspect(int index, String? url) {
    if (url == null || url.isEmpty) return;
    if (_aspectByIndex.containsKey(index)) return;

    final img = Image.network(url);
    final stream = img.image.resolve(const ImageConfiguration());
    ImageStreamListener? listener;

    listener = ImageStreamListener((info, _) {
      final w = info.image.width.toDouble();
      final h = info.image.height.toDouble();
      if (w > 0 && h > 0) {
        _aspectByIndex[index] = w / h;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() {});
        });
      }
      stream.removeListener(listener!);
    }, onError: (_, __) {
      stream.removeListener(listener!);
    });

    stream.addListener(listener);
  }

  Widget _bannerCard(BuildContext context, AIZSlider item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
          onTap: () => NavigationService.handleUrls(item.url, context: context),
          child: AIZImage.radiusImage(item.photo, 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBannersInitial && widget.bannersImagesList.isEmpty) {
      return const LoadingImageBannerWidget();
    }
    if (widget.bannersImagesList.isEmpty) {
      return const SizedBox();
    }

    if (widget.bannersImagesList.length == 1 && widget.makeOneBannerDynamicSize) {
      return DynamicSizeImageBanner(
        urlToOpen: widget.bannersImagesList.first.url,
        photo: widget.bannersImagesList.first.photo,
      );
    }

    // ✅ المطلوب: لو عدد البانرات = 3 استخدم CarouselSlider بالشكل اللي في الصورة
   if (widget.bannersImagesList.length == 3) {
  return LayoutBuilder(
    builder: (context, constraints) {
      const double bannerAspectRatio = 1.1; // ✅ 436*436 = مربع
      const double viewportFraction = 0.5;

      final cardWidth = constraints.maxWidth * viewportFraction;
      final cardHeight = cardWidth / bannerAspectRatio;

      return SizedBox(
        height: cardHeight,
        child: CarouselSlider.builder(
          itemCount: widget.bannersImagesList.length,
          itemBuilder: (context, index, realIndex) {
            final item = widget.bannersImagesList[index];
            return _bannerCard(context, item);
          },
          options: CarouselOptions(
            height: cardHeight,
            viewportFraction: viewportFraction,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            padEnds: true,
            enableInfiniteScroll: true,
            autoPlay: true,
            aspectRatio: bannerAspectRatio,
          ),
        ),
      );
    },
  );
}

    // ✅ باقي الحالات: سيب PageView زي ما هو
    final canScroll = widget.bannersImagesList.length > 1;
    final currentAspect =
        widget.aspectRatio > 0 ? widget.aspectRatio : widget.fallbackAspectRatio;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * widget.viewportFraction - 16;
        final cardHeight = cardWidth / currentAspect;

        return Container(
          height: cardHeight,
          alignment: Alignment.topCenter,
          child: PageView.builder(
            controller: _pageController,
            padEnds: widget.padEnds,
            physics: canScroll
                ? const PageScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            itemCount: widget.bannersImagesList.length,
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              _resolveAspect(i, widget.bannersImagesList[i].photo);
            },
            itemBuilder: (context, index) {
              final item = widget.bannersImagesList[index];
              _resolveAspect(index, item.photo);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusNormal),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusNormal),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusNormal),
                      onTap: () => NavigationService.handleUrls(
                        item.url,
                        context: context,
                      ),
                      child: AIZImage.radiusImage(item.photo, 2),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}