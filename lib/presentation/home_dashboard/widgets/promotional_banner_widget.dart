import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PromotionalBannerWidget extends StatefulWidget {
  const PromotionalBannerWidget({super.key});

  @override
  State<PromotionalBannerWidget> createState() =>
      _PromotionalBannerWidgetState();
}

class _PromotionalBannerWidgetState extends State<PromotionalBannerWidget>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late final List<Map<String, dynamic>> _banners;
  late final AnimationController _autoController;
  static const _autoPlayInterval = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _banners = [
      {
        'title': 'Get 10% Cashback',
        'subtitle': 'On your first UPI payment',
        'image':
            'https://images.pexels.com/photos/4386431/pexels-photo-4386431.jpeg?auto=compress&cs=tinysrgb&w=800',
        'color': const Color(0xFF5f259f),
        'action': 'Pay Now',
      },
      {
        'title': 'Zero Fee Transfer',
        'subtitle': 'Send money to any bank account',
        'image':
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=800&q=60',
        'color': const Color(0xFF00c851),
        'action': 'Transfer',
      },
      {
        'title': 'Invest in Gold',
        'subtitle': 'Start with just ₹1',
        'image':
            'https://images.pixabay.com/photo/2016/11/10/05/09/gold-1813429_960_720.jpg',
        'color': const Color(0xFFff8800),
        'action': 'Invest Now',
      },
    ];

    _autoController = AnimationController(
      vsync: this,
      duration: _autoPlayInterval,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (_pageController.hasClients) {
            final next = (_currentIndex + 1) % _banners.length;
            _pageController.animateToPage(
              next,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
          _autoController.forward(from: 0); // loop
        }
      });
    _autoController.forward();
  }

  @override
  void dispose() {
    _autoController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Container(
                  width: 90.w,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        CustomImageWidget(
                          imageUrl: banner['image'] as String,
                          width: double.infinity,
                          height: 20.h,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: double.infinity,
                          height: 20.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                (banner['color'] as Color)
                                    .withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner['title'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleLarge
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  banner['subtitle'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle banner action
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: banner['color'] as Color,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 1.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    banner['action'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: banner['color'] as Color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _banners.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _pageController.animateToPage(
                  entry.key,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ),
                child: Container(
                  width: _currentIndex == entry.key ? 8.w : 2.w,
                  height: 1.h,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentIndex == entry.key
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
