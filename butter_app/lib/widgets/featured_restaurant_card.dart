import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/restaurant.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';

class FeaturedRestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onReserveTap;
  final VoidCallback? onBookmarkTap;
  final bool isSaved;

  const FeaturedRestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onReserveTap,
    this.onBookmarkTap,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 295.w,
        height: 288.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.sp),
        ),
        child: Stack(
          children: [
            // Image de fond
            ClipRRect(
              borderRadius: BorderRadius.circular(3.sp),
              child: Image.network(
                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: Icon(Icons.restaurant, color: Colors.white54, size: 48.sp),
                    ),
                  );
                },
              ),
            ),

            // Overlay sombre pour lisibilité
            ClipRRect(
              borderRadius: BorderRadius.circular(3.sp),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),

            // Icône bookmark en haut à droite
            Positioned(
              top: 15.h,
              right: 15.w,
              child: GestureDetector(
                onTap: onBookmarkTap,
                child: AppIcons.svg(
                  isSaved ? AppIcons.bookmarkFilled : AppIcons.bookmark,
                  size: 19.sp,
                  color: Colors.white,
                ),
              ),
            ),

            // Contenu ancré en bas
            Positioned(
              left: 0,
              right: 0,
              bottom: 24.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nom du restaurant
                  Text(
                    restaurant.name,
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Infos : cuisine - arrondissement
                  Text(
                    '${restaurant.cuisine} - ${restaurant.arrondissement}',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 19.h),

                  // Bouton Réserver (toujours présent pour garder la même structure)
                  GestureDetector(
                    onTap: onReserveTap,
                    child: Container(
                      width: 78.w,
                      height: 23.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(6.sp),
                        border: Border.all(
                          color: Colors.white,
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Réserver',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
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
    );
  }
}
