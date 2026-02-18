import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';

/// Notifier global (conservé pour compatibilité)
class TabBarStyle {
  static final ValueNotifier<bool> isDarkBackground = ValueNotifier(false);
}

class CustomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 12.h),
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40.sp),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              height: 64.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0).withOpacity(0.45),
                borderRadius: BorderRadius.circular(40.sp),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / 4;

                  return Stack(
                    children: [
                      // Sliding pill indicator
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: currentIndex * itemWidth,
                        top: 0,
                        bottom: 0,
                        width: itemWidth,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(34.sp),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Tab items row
                      Row(
                        children: [
                          _TabItem(
                            svgPath: AppIcons.home,
                            label: 'Accueil',
                            isSelected: currentIndex == 0,
                            onTap: () => onTap(0),
                          ),
                          _TabItem(
                            svgPath: AppIcons.book,
                            label: 'Guides',
                            iconSize: 22.sp,
                            isSelected: currentIndex == 1,
                            onTap: () => onTap(1),
                          ),
                          _TabItem(
                            svgPath: AppIcons.bookmark,
                            label: 'Favoris',
                            isSelected: currentIndex == 2,
                            onTap: () => onTap(2),
                          ),
                          _TabItem(
                            svgPath: AppIcons.user,
                            label: 'Compte',
                            isSelected: currentIndex == 3,
                            onTap: () => onTap(3),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double? iconSize;

  const _TabItem({
    required this.svgPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.svg(
              svgPath,
              size: iconSize ?? 20.sp,
              color: isSelected
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFF555555),
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
