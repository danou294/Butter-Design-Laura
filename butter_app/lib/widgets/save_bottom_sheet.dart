import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/favorites_manager.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';

/// Bottom sheet qui apparaît quand on enregistre un restaurant
class SaveBottomSheet extends StatefulWidget {
  final String restaurantId;
  final int saveCount;

  const SaveBottomSheet({super.key, required this.restaurantId, this.saveCount = 0});

  static void show(BuildContext context, String restaurantId, {int saveCount = 0}) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SaveBottomSheet(restaurantId: restaurantId, saveCount: saveCount),
    );
  }

  @override
  State<SaveBottomSheet> createState() => _SaveBottomSheetState();
}

class _SaveBottomSheetState extends State<SaveBottomSheet> {
  final _manager = FavoritesManager();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.sp),
          topRight: Radius.circular(16.sp),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Poignée de drag
          SizedBox(height: 10.h),
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFC7C7C7),
              borderRadius: BorderRadius.circular(2.sp),
            ),
          ),

          SizedBox(height: 20.h),

          // Ligne "Enregistré" + bookmark rempli
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enregistré',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _manager.toggleSaveRestaurant(widget.restaurantId);
                    });
                    Future.delayed(const Duration(milliseconds: 350), () {
                      if (mounted) Navigator.of(context).pop();
                    });
                  },
                  child: AppIcons.svg(
                    _manager.isRestaurantSaved(widget.restaurantId)
                        ? AppIcons.bookmarkFilled
                        : AppIcons.bookmark,
                    size: 22.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Phrase "xxx personnes ont enregistré cet endroit" (seulement si >= 10)
          if (widget.saveCount >= 10) ...[
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  '${widget.saveCount} personnes ont enregistré cet endroit',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                ),
              ),
            ),
          ],

          SizedBox(height: 16.h),

          // Ligne "Have been"
          _buildCollectionRow(
            label: 'Have been',
            subtitle: 'Restaurants que tu as testés',
            isSelected: _manager.isHaveBeen(widget.restaurantId),
            onTap: () {
              setState(() {
                _manager.toggleHaveBeen(widget.restaurantId);
              });
            },
          ),

          // Séparateur
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            height: 0.5,
            color: const Color(0xFFD9D9D9),
          ),

          // Ligne "Want to try"
          _buildCollectionRow(
            label: 'Want to try',
            subtitle: 'Ta wishlist de restaurants',
            isSelected: _manager.isWantToTry(widget.restaurantId),
            onTap: () {
              setState(() {
                _manager.toggleWantToTry(widget.restaurantId);
              });
            },
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildCollectionRow({
    required String label,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF565656),
                    ),
                  ),
                ],
              ),
            ),
            isSelected
                ? AppIcons.svg(AppIcons.check, size: 20.sp, color: Colors.black)
                : AppIcons.svg(AppIcons.add, size: 20.sp, color: const Color(0xFFC7C7C7)),
          ],
        ),
      ),
    );
  }
}
