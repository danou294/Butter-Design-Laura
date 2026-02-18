import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/featured_restaurant_card.dart';
import '../utils/responsive.dart';
import '../models/favorites_manager.dart';
import '../widgets/save_bottom_sheet.dart';
import 'search_screen.dart';
import 'restaurant_detail_screen.dart';
import 'guide_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCity = 'Paris';
  final _favManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _favManager.addListener(_onFavChanged);
  }

  @override
  void dispose() {
    _favManager.removeListener(_onFavChanged);
    super.dispose();
  }

  void _onFavChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec logo et villes
              _buildHeader(),

              SizedBox(height: 24.h),

              // Barre de recherche
              _buildSearchBar(),

              SizedBox(height: 11.h),

              // Filtres rapides
              _buildQuickFilters(),

              SizedBox(height: 30.h),

              // Section "Recommandés pour toi"
              _buildRecommendedSection(),

              SizedBox(height: 33.h),

              // Section carrousel horizontal
              _buildHorizontalSection(
                title: 'Restaurants italiens pour un first date',
              ),

              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 38.h),
      child: Row(
        children: [
          // Logo Butter
          Padding(
            padding: EdgeInsets.only(left: 19.w),
            child: Image.asset(
              'assets/logos/butter_logo.jpg',
              height: 46.sp,
            ),
          ),
          SizedBox(width: 36.w),
          // Navigation villes (scroll jusqu'au bord droit)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: MockData.cities.map((city) {
                  final isSelected = city == selectedCity;
                  return Padding(
                    padding: EdgeInsets.only(right: 40.w),
                    child: GestureDetector(
                      onTap: () {
                        if (city == 'Paris') {
                          setState(() => selectedCity = city);
                        } else {
                          _showComingSoonCity(city);
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            city,
                            style: AppTheme.bodyMedium.copyWith(
                              fontSize: 14.sp,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            height: 1,
                            width: 30.w,
                            color: isSelected ? AppTheme.textPrimary : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openSearchScreen() {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SearchScreen(selectedCity: selectedCity),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showComingSoonCity(String city) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => _ComingSoonScreen(cityName: city),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: _openSearchScreen,
        child: Container(
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: Offset(0, 2.h),
                blurRadius: 8.sp,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 14.sp,
                color: AppTheme.textPrimary.withOpacity(0.5),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  'Commencer ma recherche',
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary.withOpacity(0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: MockData.quickFilters.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;
          final isLast = index == MockData.quickFilters.length - 1;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 10.w),
              child: GestureDetector(
                onTap: () {
                  // TODO: Appliquer le filtre
                },
                child: Container(
                  height: 44.h,
                  padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 6.h, bottom: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.sp),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        offset: Offset(0, 2.h),
                        blurRadius: 8.sp,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        filter['title']!,
                        style: AppTheme.chipText.copyWith(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        filter['subtitle']!,
                        style: AppTheme.chipText.copyWith(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF6D6D6D),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Text(
            'Recommandés pour toi',
            style: AppTheme.titleLarge.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 17.h),
        SizedBox(
          height: 288.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20.w),
            itemCount: MockData.recommendedRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = MockData.recommendedRestaurants[index];
              return Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: FeaturedRestaurantCard(
                  restaurant: restaurant,
                  isSaved: _favManager.isRestaurantSaved(restaurant.id),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
                      ),
                    );
                  },
                  onReserveTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
                      ),
                    );
                  },
                  onBookmarkTap: () {
                    if (!_favManager.isRestaurantSaved(restaurant.id)) {
                      _favManager.toggleSaveRestaurant(restaurant.id);
                    }
                    SaveBottomSheet.show(context, restaurant.id, saveCount: restaurant.saveCount);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalSection({required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.titleLarge.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 24.w),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GuideDetailScreen(
                        guideTitle: title,
                        guideDescription: 'Découvre notre sélection.',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Tout voir',
                  style: AppTheme.bodySmall.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 21.h),
        SizedBox(
          height: 237.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20.w),
            itemCount: MockData.recommendedRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = MockData.recommendedRestaurants[index];
              return Padding(
                padding: EdgeInsets.only(right: 6.w),
                child: RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ComingSoonScreen extends StatelessWidget {
  final String cityName;

  const _ComingSoonScreen({required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Bouton retour
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, top: 12.h),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 33.w,
                    height: 33.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1EFEB),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AppIcons.svg(AppIcons.arrowBack, size: 16.sp, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cityName,
                      style: AppTheme.titleLarge.copyWith(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      'On cherche les meilleures adresses à $cityName pour te les partager très prochainement.',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyMedium.copyWith(
                        fontSize: 14.sp,
                        color: const Color(0xFF565656),
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'Stay tuned !',
                      style: AppTheme.bodyMedium.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
