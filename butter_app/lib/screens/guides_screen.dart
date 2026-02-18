import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/guide_card.dart';
import '../utils/responsive.dart';
import 'guide_detail_screen.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  // Mock : restaurants "Coups de coeur de la semaine"
  static final List<Restaurant> _coupsDeCoeur = [
    Restaurant(
      id: '1',
      name: 'HALO',
      logoPath: 'assets/logos/halo.png',
      arrondissement: 'Paris 2',
      cuisine: 'Français',
      priceRange: '€€€',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '2',
      name: 'HALO',
      logoPath: 'assets/logos/halo.png',
      arrondissement: 'Paris 2',
      cuisine: 'Français',
      priceRange: '€€€',
      photoLieu: '',
      photoPlat: '',
    ),
    Restaurant(
      id: '3',
      name: 'HALO',
      logoPath: 'assets/logos/halo.png',
      arrondissement: 'Paris 2',
      cuisine: 'Français',
      priceRange: '€€€',
      photoLieu: '',
      photoPlat: '',
    ),
  ];

  // Mock : guides
  static final List<Map<String, String>> _guides = [
    {
      'title': 'Manger au comptoir',
      'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
      'description': "Si t'adores regarder les chefs dans les yeux lorsqu'ils te concoctent ton plat, ou que t'aimes juste être assis sur une chaise haute (la par contre je comprends pas), on te propose nos meilleurs endroits pour manger au comptoir.",
    },
    {
      'title': 'Nouveaux sur Butter',
      'image': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
      'description': 'Les dernières adresses ajoutées sur Butter, à découvrir en avant-première.',
    },
    {
      'title': 'Brunchs à Paris',
      'image': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
      'description': 'Notre sélection des meilleurs brunchs parisiens pour un dimanche parfait.',
    },
    {
      'title': 'Date spots',
      'image': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      'description': 'Les adresses les plus romantiques pour un dîner en tête-à-tête.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header : titre seul
              _buildHeader(),

              SizedBox(height: 20.h),

              // Section "Coups de coeur de la semaine"
              _buildCoupsDeCoeurSection(),

              SizedBox(height: 20.h),

              // Séparateur
              Center(
                child: Container(
                  width: 352.w,
                  height: 0.5,
                  color: const Color(0xFFC7C7C7),
                ),
              ),

              SizedBox(height: 21.h),

              // Section guides en grille 2 colonnes
              _buildGuidesGrid(context),

              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 73.h),
      child: Text(
        'Guides',
        style: AppTheme.titleLarge.copyWith(
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCoupsDeCoeurSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Coups de coeur de la semaine',
            style: AppTheme.titleLarge.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 237.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20.w),
            itemCount: _coupsDeCoeur.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: RestaurantCard(
                  restaurant: _coupsDeCoeur[index],
                  cardWidth: 139.w,
                  cardHeight: 237.h,
                  onTap: () {},
                  onBookmarkTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openGuide(BuildContext context, Map<String, String> guide) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GuideDetailScreen(
          guideTitle: guide['title']!,
          guideDescription: guide['description']!,
        ),
      ),
    );
  }

  Widget _buildGuidesGrid(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < _guides.length; i += 2)
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: SizedBox(
                height: 194.h,
                child: Row(
                  children: [
                    Expanded(
                      child: GuideCard(
                        title: _guides[i]['title']!,
                        imageUrl: _guides[i]['image']!,
                        onTap: () => _openGuide(context, _guides[i]),
                      ),
                    ),
                    SizedBox(width: 11.w),
                    if (i + 1 < _guides.length)
                      Expanded(
                        child: GuideCard(
                          title: _guides[i + 1]['title']!,
                          imageUrl: _guides[i + 1]['image']!,
                          onTap: () => _openGuide(context, _guides[i + 1]),
                        ),
                      ),
                    if (i + 1 >= _guides.length)
                      const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
