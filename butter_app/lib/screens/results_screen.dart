import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/custom_tab_bar.dart';
import '../main.dart';
import 'restaurant_detail_screen.dart';

class ResultsScreen extends StatefulWidget {
  final List<String> activeFilters;
  final int resultCount;

  const ResultsScreen({
    super.key,
    required this.activeFilters,
    required this.resultCount,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int _displayedCount = 10;

  // Données de test - sera remplacé par la base de données
  final List<Restaurant> restaurants = [
    Restaurant(
      id: '1',
      name: 'DAME',
      arrondissement: 'Paris 9',
      cuisine: 'Français',
      priceRange: '€€€',
      logoPath: '',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '2',
      name: "ALFI'S",
      arrondissement: 'Paris 1',
      cuisine: 'Italien',
      priceRange: '€€',
      logoPath: '',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '3',
      name: 'La Table de Martine',
      arrondissement: 'Paris 16',
      cuisine: 'Méditerranéen',
      priceRange: '€€€',
      logoPath: '',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '4',
      name: 'PUBLIC HOUSE',
      arrondissement: 'Paris 2',
      cuisine: 'Anglais',
      priceRange: '€€',
      logoPath: '',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '5',
      name: 'Chez Marcel',
      arrondissement: 'Paris 11',
      cuisine: 'Français',
      priceRange: '€€',
      logoPath: '',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '6',
      name: 'Pasta Fresca',
      arrondissement: 'Paris 3',
      cuisine: 'Italien',
      priceRange: '€',
      logoPath: '',
      photoLieu: '',
      photoPlat: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),

                SizedBox(height: 17.h),

                // Filtres actifs (chips scrollables)
                _buildActiveFilters(),

                SizedBox(height: 33.h),

                // Grille de résultats
                Expanded(
                  child: _buildResultsGrid(),
                ),
              ],
            ),
          ),

          // Tab bar en bas
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomTabBar(
              currentIndex: 0,
              onTap: (index) {
                MainScreen.tabSwitchNotifier.value = index;
                Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 73.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bouton retour au-dessus du titre
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

          SizedBox(height: 12.h),

          // Titre
          Text(
            'Résultats',
            style: AppTheme.titleLarge.copyWith(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 4.h),

          // Sous-titre
          Text(
            '${widget.resultCount} adresses correspondantes',
            style: AppTheme.bodyMedium.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return SizedBox(
      height: 27.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: widget.activeFilters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EFEB),
                borderRadius: BorderRadius.circular(6.sp),
              ),
              child: Center(
                child: Text(
                  widget.activeFilters[index],
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 12.sp,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsGrid() {
    // Limiter à _displayedCount
    final visible = restaurants.take(_displayedCount).toList();
    final leftColumn = <Restaurant>[];
    final rightColumn = <Restaurant>[];

    for (int i = 0; i < visible.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(visible[i]);
      } else {
        rightColumn.add(visible[i]);
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
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
                        onBookmarkTap: () {},
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
                          onBookmarkTap: () {},
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),

          // Bouton "Charger plus" si il reste des résultats
          if (_displayedCount < restaurants.length) ...[
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  _displayedCount += 10;
                });
              },
              child: Container(
                width: 174.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EFEB),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Center(
                  child: Text(
                    'Charger plus',
                    style: AppTheme.bodyMedium.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],

          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
