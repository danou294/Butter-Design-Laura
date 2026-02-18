import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/restaurant.dart';
import '../models/favorites_manager.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';
import '../widgets/save_bottom_sheet.dart';
import '../widgets/custom_tab_bar.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  int _currentPhotoIndex = 0;
  late PageController _pageController;
  final _favManager = FavoritesManager();
  bool _horairesExpanded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 360 / 390);
    _favManager.addListener(_onFavChanged);
    TabBarStyle.isDarkBackground.value = true;
  }

  @override
  void dispose() {
    TabBarStyle.isDarkBackground.value = false;
    _favManager.removeListener(_onFavChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onFavChanged() {
    if (mounted) setState(() {});
  }

  List<String> get _photos {
    if (widget.restaurant.photos.isNotEmpty) return widget.restaurant.photos;
    return ['https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'];
  }

  String get _currentDayName {
    const days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    return days[DateTime.now().weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Couche 1 : Image plein écran (fond) — -20% exposition
          Positioned.fill(
            child: Image.asset(
              'assets/image_1436.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Couche 2 : Blur sigma 300
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 300, sigmaY: 300),
                child: Container(
                  color: Colors.black.withOpacity(0.10),
                ),
              ),
            ),
          ),

          // Contenu scrollable
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Espace au-dessus du carousel — 105
                SizedBox(height: 105.h),

                // Carousel de photos — hauteur 400, radius 15, padding 5
                SizedBox(
                  height: 400.h,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _photos.length,
                    onPageChanged: (index) {
                      setState(() => _currentPhotoIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.sp),
                              child: Image.network(
                                _photos[index],
                                width: double.infinity,
                                height: 400.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[800],
                                  child: Center(
                                    child: AppIcons.svg(AppIcons.book, size: 48.sp, color: Colors.white54),
                                  ),
                                ),
                              ),
                            ),
                            // Indicateur photo "1/7" — top right, 12sp blanc
                            if (_photos.length > 1)
                              Positioned(
                                top: 12.h,
                                right: 12.w,
                                child: Text(
                                  '${index + 1}/${_photos.length}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Espace après carousel — 33
                SizedBox(height: 33.h),

                // Contenu texte
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRestaurantInfo(r),
                      _buildPreBlurContent(r),
                      _buildBlurContent(r),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bouton retour — 40x40, cercle, FFFFFF 20%, icône 25x25
          Positioned(
            top: 55.h,
            left: 17.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.keyboard_arrow_left, size: 25.sp, color: Colors.white),
                ),
              ),
            ),
          ),

          // Bouton share — 40x40, cercle, FFFFFF 20%, en haut à droite
          Positioned(
            top: 55.h,
            right: 17.w,
            child: GestureDetector(
              onTap: () {
                Share.share("J'ai trouvé ce restaurant sur Butter : ${r.name}");
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AppIcons.svg(AppIcons.export, size: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  /// Infos du restaurant
  Widget _buildRestaurantInfo(Restaurant r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nom — 24sp semi-bold blanc
        Text(
          r.name,
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // Espace nom → sous-titre — 8
        SizedBox(height: 8.h),

        // Sous-titre — 13sp regular, blanc 70%, tiret long
        Text(
          '${r.arrondissement} – ${r.priceRange}',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.7),
          ),
        ),

        // Espace sous-titre → tags — 19
        SizedBox(height: 19.h),

        // Tags — espacement 4
        Row(
          children: [
            _buildStatusTag(isOpen: true),
            SizedBox(width: 4.w),
            ...r.tags.expand((tag) => [_buildTag(tag), SizedBox(width: 4.w)]).toList()..removeLast(),
          ],
        ),

        // Espace tags → boutons d'action — 25
        SizedBox(height: 25.h),

        // 3 boutons d'action — 114x49, radius 10, spacing 6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(
              label: 'Réserver',
              isFirst: true,
              icon: Icon(Icons.calendar_today_outlined, size: 14.sp, color: Colors.black),
              onTap: () {},
            ),
            _buildActionButton(
              label: 'La carte',
              icon: Icon(Icons.menu, size: 14.sp, color: Colors.white),
              onTap: () {},
            ),
            _buildActionButton(
              label: 'Enregistrer',
              icon: AppIcons.svg(
                _favManager.isRestaurantSaved(widget.restaurant.id)
                    ? AppIcons.bookmarkFilled
                    : AppIcons.bookmark,
                size: 14.sp,
                color: Colors.white,
              ),
              onTap: () {
                final id = widget.restaurant.id;
                if (!_favManager.isRestaurantSaved(id)) {
                  _favManager.toggleSaveRestaurant(id);
                }
                SaveBottomSheet.show(context, id, saveCount: widget.restaurant.saveCount);
              },
            ),
          ],
        ),

        // Espace boutons → description — 27
        SizedBox(height: 27.h),
      ],
    );
  }

  // Tag "Ouvert/Fermé" — 64x21, radius 30, fond D4F2DA, texte 11 medium 3C8D57
  Widget _buildStatusTag({required bool isOpen}) {
    return Container(
      width: 64.w,
      height: 21.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isOpen ? const Color(0xFFD4F2DA) : const Color(0xFFF5D6D6),
        borderRadius: BorderRadius.circular(30.sp),
      ),
      child: Text(
        isOpen ? 'Ouvert' : 'Fermé',
        style: GoogleFonts.inter(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: isOpen ? const Color(0xFF3C8D57) : const Color(0xFFC62828),
        ),
      ),
    );
  }

  // Tags cuisine — 70x21, radius 30, sans fond, bordure blanc 50% 0.5, texte 11 regular blanc 70%
  Widget _buildTag(String label) {
    return Container(
      width: 70.w,
      height: 21.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.sp),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }

  // Bouton d'action — 114x49, radius 10
  Widget _buildActionButton({
    required String label,
    Widget? icon,
    bool isFirst = false,
    VoidCallback? onTap,
  }) {
    final bgColor = isFirst
        ? Colors.white
        : const Color(0xFFD9D9D9).withOpacity(0.1);
    final textColor = isFirst
        ? Colors.black
        : Colors.white.withOpacity(0.6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 114.w,
        height: 49.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon,
              SizedBox(height: 7.h),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bouton social — 61x43 rectangle, radius 12, D9D9D9 10%
  Widget _buildSocialButton({
    required Widget icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 61.w,
        height: 43.h,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9).withOpacity(0.10),
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Center(child: icon),
      ),
    );
  }

  /// Description + note vidéo
  Widget _buildPreBlurContent(Restaurant r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Description — 12sp regular, blanc 100%
        if (r.description != null)
          Text(
            r.description!,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.5,
            ),
          ),

        // Espace description → note vidéo — 23
        SizedBox(height: 23.h),

        // Note vidéo — 352x47, D9D9D9 20%, radius 8, padding horizontal 18
        Container(
          width: 352.w,
          height: 47.h,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.sp),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'On a testé ce restaurant en vidéo, découvre-la ici',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              AppIcons.svg(AppIcons.upRightArrow, size: 14.sp, color: Colors.white),
            ],
          ),
        ),

        // Espace note vidéo → adresses — 27
        SizedBox(height: 27.h),
      ],
    );
  }

  /// Sections Adresses, Metro, Horaires, Social, Edgar
  Widget _buildBlurContent(Restaurant r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Adresses
        if (r.addresses.isNotEmpty) ...[
          _buildSectionTitle(r.addresses.length > 1 ? 'Adresses' : 'Adresse'),
          ...r.addresses.asMap().entries.map((entry) => Padding(
            padding: EdgeInsets.only(
              bottom: entry.key < r.addresses.length - 1 ? 16.h : 0,
            ),
            child: GestureDetector(
              onTap: () => _showMapChoiceDialog(entry.value),
              child: Text(
                entry.value,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          )),
          // Espace adresses → metro — 38
          SizedBox(height: 38.h),
        ],

        // Section Metro
        if (r.metroStations.isNotEmpty) ...[
          _buildSectionTitle('Metro'),
          Wrap(
            spacing: 72.w,
            runSpacing: 10.h,
            children: r.metroStations.map((station) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  station,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.w),
                // Pastille — cercle 13, couleur selon ligne, numéro 9sp regular blanc
                Container(
                  width: 13.sp,
                  height: 13.sp,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0065AE),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '2',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            )).toList(),
          ),
          // Espace après metro — 38
          SizedBox(height: 38.h),
        ],

        // Section Horaires
        if (r.horairesJour != null) ...[
          GestureDetector(
            onTap: () => setState(() => _horairesExpanded = !_horairesExpanded),
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre — 11sp medium, blanc 70%
                Text(
                  'Horaires',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                // Espace titre → séparateur — 13
                SizedBox(height: 13.h),
                // Séparateur — 0.2, blanc 70%
                Container(
                  width: double.infinity,
                  height: 0.2,
                  color: Colors.white.withOpacity(0.7),
                ),
                // Espace séparateur → contenu — 11
                SizedBox(height: 11.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildHoraireRow(
                        _horairesExpanded ? 'Lundi' : r.horairesJour!,
                        r.horairesHeures ?? '',
                        isBold: _horairesExpanded
                            ? _currentDayName == 'Lundi'
                            : _currentDayName == r.horairesJour,
                      ),
                    ),
                    // Flèche — 14x14, blanc 70%
                    AnimatedRotation(
                      turns: _horairesExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 14.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                if (_horairesExpanded) ...[
                  _buildHoraireRow('Mardi', r.horairesHeures ?? '', isBold: _currentDayName == 'Mardi'),
                  _buildHoraireRow('Mercredi', r.horairesHeures ?? '', isBold: _currentDayName == 'Mercredi'),
                  _buildHoraireRow('Jeudi', r.horairesHeures ?? '', isBold: _currentDayName == 'Jeudi'),
                  _buildHoraireRow('Vendredi', r.horairesHeures ?? '', isBold: _currentDayName == 'Vendredi'),
                  _buildHoraireRow('Samedi', r.horairesHeures ?? '', isBold: _currentDayName == 'Samedi'),
                  _buildHoraireRow('Dimanche', 'Fermé', isBold: _currentDayName == 'Dimanche'),
                ],
              ],
            ),
          ),
        ],

        // Espace horaires → boutons sociaux — 54
        SizedBox(height: 54.h),

        // Boutons sociaux — 61x43, radius 12, D9D9D9 10%, espacement 4
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: AppIcons.svg(AppIcons.telephone, size: 20.sp, color: Colors.white),
              onTap: () {},
            ),
            SizedBox(width: 4.w),
            _buildSocialButton(
              icon: AppIcons.svg(AppIcons.link, size: 20.sp, color: Colors.white),
              onTap: () {},
            ),
            SizedBox(width: 4.w),
            _buildSocialButton(
              icon: AppIcons.svg(AppIcons.instagram, size: 20.sp, color: Colors.white),
              onTap: () {},
            ),
          ],
        ),

        // Espace social → Edgar — 33
        SizedBox(height: 33.h),

        // Concierge Edgar — 352x70, D9D9D9 20%, radius 8, padding h16 v20
        GestureDetector(
          onTap: () => _openEdgarWhatsApp(r.name),
          child: Container(
            width: 352.w,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.sp),
            ),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Une demande sur-mesure, une table introuvable ?\n',
                  ),
                  // "Contacte Edgar" souligné ensemble
                  TextSpan(
                    text: 'Contacte Edgar',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                  const TextSpan(text: ', notre concierge disponible 24/7.'),
                ],
              ),
            ),
          ),
        ),

        // Espace bas de page — assez pour ne pas être caché par la tab bar
        SizedBox(height: 120.h),
      ],
    );
  }

  Future<void> _openEdgarWhatsApp(String restaurantName) async {
    const phone = '33972105408';
    final message = Uri.encodeComponent(
      "Hello Edgar, j'ai besoin d'une table chez $restaurantName que j'ai trouvé sur Butter, tu peux m'aider ?"
    );
    final url = 'https://wa.me/$phone?text=$message';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showMapChoiceDialog(String address) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.sp),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  width: 280.w,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16.sp),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 24.w),
                          Text(
                            'Ouvrir avec',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: AppIcons.svg(AppIcons.close, size: 14.sp, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildMapOption(
                        label: 'Apple Plans',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(height: 10.h),
                      _buildMapOption(
                        label: 'Google Maps',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(height: 10.h),
                      _buildMapOption(
                        label: 'Waze',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapOption({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF1EFEB),
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // Titre de section — 11sp medium blanc 70%, séparateur 0.2 blanc 70%, spacing 13+11
  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 13.h),
        Container(
          width: double.infinity,
          height: 0.2,
          color: Colors.white.withOpacity(0.7),
        ),
        SizedBox(height: 11.h),
      ],
    );
  }

  // Ligne horaire — 13sp medium blanc 100%, jour actuel en semi-bold
  Widget _buildHoraireRow(String jour, String heures, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              jour,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            heures,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: heures == 'Fermé'
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
