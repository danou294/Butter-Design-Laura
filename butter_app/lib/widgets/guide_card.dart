import 'package:flutter/material.dart';
import '../models/favorites_manager.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';

class GuideCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const GuideCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  @override
  State<GuideCard> createState() => _GuideCardState();
}

class _GuideCardState extends State<GuideCard> {
  final _manager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _manager.addListener(_onChanged);
  }

  @override
  void dispose() {
    _manager.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isSaved = _manager.isGuideSaved(widget.title);

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du guide avec icône enregistrer
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3.sp),
                  child: Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(Icons.menu_book, color: Colors.grey, size: 32.sp),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () => _manager.toggleSaveGuide(widget.title),
                    child: SizedBox(
                      width: 14.w,
                      height: 19.h,
                      child: FittedBox(
                        child: AppIcons.svg(isSaved ? AppIcons.bookmarkFilled : AppIcons.bookmark, size: 19.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // Titre en dessous
          Text(
            widget.title,
            style: AppTheme.bodyMedium.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
