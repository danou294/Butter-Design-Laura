import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../models/restaurant.dart';
import '../models/favorites_manager.dart';
import '../widgets/restaurant_card.dart';
import '../utils/responsive.dart';
import 'restaurant_detail_screen.dart';

class GuideDetailScreen extends StatefulWidget {
  final String guideTitle;
  final String guideDescription;

  const GuideDetailScreen({
    super.key,
    required this.guideTitle,
    required this.guideDescription,
  });

  @override
  State<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends State<GuideDetailScreen> {
  // Mock restaurants du guide
  static final List<Restaurant> _restaurants = [
    Restaurant(
      id: '1',
      name: 'DAME',
      logoPath: 'assets/logos/dame.png',
      arrondissement: 'Paris 9',
      cuisine: 'Français',
      priceRange: '€€€',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '2',
      name: "ALFI'S",
      logoPath: '',
      arrondissement: 'Paris 1',
      cuisine: 'Italien',
      priceRange: '€€',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '3',
      name: 'La Table de Martine',
      logoPath: '',
      arrondissement: 'Paris 16',
      cuisine: 'Méditerranéen',
      priceRange: '€€',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '4',
      name: 'CRAVAN',
      logoPath: 'assets/logos/cravan.png',
      arrondissement: 'Paris 2',
      cuisine: 'Anglais',
      priceRange: '€€',
      photoLieu: '',
      photoPlat: '',
    ),
  ];
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
    final isSaved = _manager.isGuideSaved(widget.guideTitle);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bouton retour + titre
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 73.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 33.w,
                        height: 33.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1EFEB),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.keyboard_arrow_left, size: 20.sp, color: AppTheme.textPrimary),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Guides',
                      style: AppTheme.titleLarge.copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Nom du guide + bookmark
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.guideTitle,
                        style: AppTheme.titleLarge.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: GestureDetector(
                        onTap: () => _manager.toggleSaveGuide(widget.guideTitle),
                        child: AppIcons.svg(isSaved ? AppIcons.bookmarkFilled : AppIcons.bookmark, size: 22.sp, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // Description du guide
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  widget.guideDescription,
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF4A4A4A),
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Grille masonry des restaurants
              _buildRestaurantsGrid(),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantsGrid() {
    final leftColumn = <Restaurant>[];
    final rightColumn = <Restaurant>[];
    for (int i = 0; i < _restaurants.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(_restaurants[i]);
      } else {
        rightColumn.add(_restaurants[i]);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colonne gauche
          Expanded(
            child: Column(
              children: leftColumn.map((restaurant) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: RestaurantCard(
                    restaurant: restaurant,
                    cardWidth: 177.w,
                    cardHeight: 267.h,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(width: 8.w),

          // Colonne droite (décalée pour effet masonry)
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 40.h),
                ...rightColumn.map((restaurant) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: RestaurantCard(
                      restaurant: restaurant,
                      cardWidth: 177.w,
                      cardHeight: 267.h,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
