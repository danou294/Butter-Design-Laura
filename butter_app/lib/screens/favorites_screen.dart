import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/restaurant.dart';
import '../models/favorites_manager.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/guide_card.dart';
import '../utils/responsive.dart';
import 'restaurant_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _selectedFilter = 'All';
  final _manager = FavoritesManager();

  final List<String> _filters = ['All', 'Want to try', 'Have been', 'Guides'];

  // Catalogue complet de tous les restaurants (lookup par id)
  static final Map<String, Restaurant> _allRestaurants = {
    '1': Restaurant(
      id: '1',
      name: 'DAME',
      logoPath: 'assets/logos/dame.png',
      arrondissement: 'Paris 9',
      cuisine: 'Français',
      priceRange: '€€€',
      photoLieu: '',
      photoPlat: '',
    ),
    '2': Restaurant(
      id: '2',
      name: 'HALO',
      logoPath: 'assets/logos/halo.png',
      arrondissement: 'Paris 2',
      cuisine: 'Français',
      priceRange: '€€€',
      photoLieu: '',
      photoPlat: '',
    ),
    '3': Restaurant(
      id: '3',
      name: "ALFI'S",
      logoPath: '',
      arrondissement: 'Paris 1',
      cuisine: 'Italien',
      priceRange: '€€',
      photoLieu: '',
      photoPlat: '',
    ),
    '4': Restaurant(
      id: '4',
      name: 'CRAVAN',
      logoPath: 'assets/logos/cravan.png',
      arrondissement: 'Paris 8',
      cuisine: 'Bar à cocktails',
      priceRange: '€€€',
      photoLieu: '',
      photoPlat: '',
    ),
  };

  // Données mock guides pour la section guides
  final List<Map<String, String>> _allGuides = [
    {
      'title': 'Manger au comptoir',
      'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
    },
    {
      'title': 'Nouveaux sur Butter',
      'image': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
    },
    {
      'title': 'Brunchs à Paris',
      'image': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
    },
    {
      'title': 'Date spots',
      'image': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
    },
  ];

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

  /// Restaurants filtrés selon l'onglet sélectionné
  List<Restaurant> get _filteredRestaurants {
    Set<String> ids;
    switch (_selectedFilter) {
      case 'Have been':
        ids = _manager.haveBeenIds;
        break;
      case 'Want to try':
        ids = _manager.wantToTryIds;
        break;
      default: // 'All'
        ids = _manager.savedRestaurantIds;
    }
    return ids
        .where((id) => _allRestaurants.containsKey(id))
        .map((id) => _allRestaurants[id]!)
        .toList()
        .reversed
        .toList();
  }

  /// Guides enregistrés
  List<Map<String, String>> get _savedGuides {
    return _allGuides
        .where((g) => _manager.isGuideSaved(g['title']!))
        .toList();
  }

  double get _progress {
    final saved = _manager.savedRestaurantIds.length;
    if (saved == 0) return 0.0;
    return _manager.haveBeenIds.length / saved;
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
              // Header : titre + barre de progression
              _buildHeader(),

              SizedBox(height: 22.h),

              // Onglets de filtrage
              _buildFilterChips(),

              SizedBox(height: 18.h),

              // Section Guides (visible sur All et Guides)
              if ((_selectedFilter == 'All' || _selectedFilter == 'Guides') &&
                  _savedGuides.isNotEmpty)
                _buildGuidesSection(),

              if (_selectedFilter != 'Guides' && _filteredRestaurants.isNotEmpty) ...[
                SizedBox(height: 24.h),

                // Séparateur
                if ((_selectedFilter == 'All' || _selectedFilter == 'Guides') &&
                    _savedGuides.isNotEmpty)
                  Center(
                    child: Container(
                      width: 352.w,
                      height: 0.5,
                      color: const Color(0xFFC7C7C7),
                    ),
                  ),

                SizedBox(height: 24.h),

                // Grille masonry des restaurants favoris
                _buildFavoritesGrid(),
              ],

              // Message vide si rien à afficher
              if (_selectedFilter == 'Guides' && _savedGuides.isEmpty ||
                  _selectedFilter != 'Guides' && _filteredRestaurants.isEmpty && _savedGuides.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                  child: Center(
                    child: Text(
                      'Rien ici pour le moment.\nEnregistre des adresses pour les retrouver ici !',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyMedium.copyWith(
                        fontSize: 12.sp,
                        color: const Color(0xFF565656),
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final percent = (_progress * 100).round();

    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 73.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favoris',
            style: AppTheme.titleLarge.copyWith(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 20.h),

          _buildProgressBar(),

          SizedBox(height: 4.h),

          Text(
            'Tu as testé $percent% de tes adresses enregistrées',
            style: AppTheme.bodyMedium.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF565656),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    const double barWidth = 255;
    const double barHeight = 8;
    const double logoSize = 31;

    return SizedBox(
      width: barWidth.w,
      height: logoSize.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: barWidth.w,
            height: barHeight.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE189).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.sp),
            ),
          ),
          Container(
            width: (barWidth * _progress).w,
            height: barHeight.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE189),
              borderRadius: BorderRadius.circular(10.sp),
            ),
          ),
          Positioned(
            left: (barWidth * _progress).w - (logoSize / 2).w,
            child: Text(
              '🧈',
              style: TextStyle(fontSize: (logoSize * 0.8).sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 30.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                width: 78.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : const Color(0xFFF1EFEB),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: AppTheme.bodyMedium.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGuidesSection() {
    final guides = _savedGuides;
    final isGridMode = _selectedFilter == 'Guides';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Guides',
            style: AppTheme.titleLarge.copyWith(
              fontSize: 15.sp,
            ),
          ),
        ),
        SizedBox(height: 15.h),
        if (isGridMode)
          // Grille 2 colonnes pour l'onglet "Guides"
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                for (int i = 0; i < guides.length; i += 2)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: SizedBox(
                      height: 180.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: GuideCard(
                              title: guides[i]['title']!,
                              imageUrl: guides[i]['image']!,
                              onTap: () {},
                            ),
                          ),
                          SizedBox(width: 11.w),
                          if (i + 1 < guides.length)
                            Expanded(
                              child: GuideCard(
                                title: guides[i + 1]['title']!,
                                imageUrl: guides[i + 1]['image']!,
                                onTap: () {},
                              ),
                            ),
                          if (i + 1 >= guides.length)
                            const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )
        else
          // Ligne horizontale scrollable pour l'onglet "All"
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 20.w),
              itemCount: guides.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 11.w),
                  child: SizedBox(
                    width: 139.w,
                    child: GuideCard(
                      title: guides[index]['title']!,
                      imageUrl: guides[index]['image']!,
                      onTap: () {},
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildFavoritesGrid() {
    final restaurants = _filteredRestaurants;
    final leftColumn = <Restaurant>[];
    final rightColumn = <Restaurant>[];
    for (int i = 0; i < restaurants.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(restaurants[i]);
      } else {
        rightColumn.add(restaurants[i]);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
