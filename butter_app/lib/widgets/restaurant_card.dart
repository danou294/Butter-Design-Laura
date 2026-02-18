import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/restaurant.dart';
import '../models/favorites_manager.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';
import 'save_bottom_sheet.dart';

class RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final double? cardWidth;
  final double? cardHeight;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onBookmarkTap,
    this.cardWidth,
    this.cardHeight,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  final _manager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _manager.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _manager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  void _handleBookmarkTap() {
    final id = widget.restaurant.id;
    if (!_manager.isRestaurantSaved(id)) {
      _manager.toggleSaveRestaurant(id);
    }
    SaveBottomSheet.show(context, id, saveCount: widget.restaurant.saveCount);
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.cardWidth ?? 139.w;
    final height = widget.cardHeight ?? 237.h;
    final isSaved = _manager.isRestaurantSaved(widget.restaurant.id);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(5.sp),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 8.h,
            bottom: 5.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne info : Arrondissement | Cuisine | Prix + Bookmark
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.restaurant.arrondissement} | ${widget.restaurant.cuisine} | ${widget.restaurant.priceRange}',
                      style: GoogleFonts.inriaSans(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: _handleBookmarkTap,
                    child: AppIcons.svg(
                      isSaved ? AppIcons.bookmarkFilled : AppIcons.bookmark,
                      size: 14.sp,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),

              // Espace réservé pour le logo du restaurant
              SizedBox(
                height: 34.h,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: widget.restaurant.logoPath.isNotEmpty
                      ? Image.asset(
                          widget.restaurant.logoPath,
                          height: 28.h,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 28.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4.sp),
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 28.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4.sp),
                          ),
                        ),
                ),
              ),

              SizedBox(height: 4.h),

              // Photos : 2/3 lieu + 1/3 plat
              Expanded(
                child: Row(
                  children: [
                    // Photo lieu (2/3)
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6.sp),
                            bottomLeft: Radius.circular(6.sp),
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                          ),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[400],
                                child: const Center(
                                  child: Icon(Icons.restaurant, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Photo plat (1/3)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            bottomLeft: Radius.zero,
                            topRight: Radius.circular(6.sp),
                            bottomRight: Radius.circular(6.sp),
                          ),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[400],
                                child: const Center(
                                  child: Icon(Icons.dining, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
