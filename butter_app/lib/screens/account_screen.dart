import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';
import 'settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Profil', 'Tes recos', 'Feedback'];

  // TODO: à remplacer par la vraie logique d'abonnement
  bool _isPremium = true;

  // Notifications dismissables
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': "Members' event - 001",
      'body': "On se retrouve le 19 février au premier Butter mixer.\nFood, drinks, vibe...\n\nOn a hâte de te rencontrer 🤝",
      'cta': "Je m'inscris",
      'image': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
    },
    {
      'id': '2',
      'title': "Members' favorites",
      'body': "Les meilleures pâtes à la vodka de Paris selon toi :",
      'hasInput': true,
    },
  ];

  final Set<String> _dismissedNotifications = {};

  void _dismissNotification(String id) {
    setState(() {
      _dismissedNotifications.add(id);
    });
  }

  List<Map<String, dynamic>> get _visibleNotifications {
    return _notifications
        .where((n) => !_dismissedNotifications.contains(n['id']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Contenu scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre "Compte" + icône réglages
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 73.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Compte',
                            style: AppTheme.titleLarge.copyWith(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SettingsScreen(),
                                ),
                              );
                            },
                            child: AppIcons.svg(AppIcons.settings, size: 22.sp, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Onglets + cloche notifications
                    _buildTabBar(),

                    SizedBox(height: 28.h),

                    // Contenu selon l'onglet
                    if (_selectedTab == 0) _buildProfilTab(),
                    if (_selectedTab == 1) _buildTesRecosTab(),
                    if (_selectedTab == 2) _buildFeedbackTab(),
                    if (_selectedTab == 3) _buildNotificationsTab(),
                  ],
                ),
              ),
            ),

            // Bouton "Donne ton avis" fixé en bas
            Padding(
              padding: EdgeInsets.only(bottom: 100.h),
              child: _buildAppStoreButton(),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final prenomController = TextEditingController(text: 'Laura');
    final nomController = TextEditingController(text: 'Derhy');
    final dateController = TextEditingController(text: '15/03/1998');

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320.w,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16.sp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header avec titre + fermer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Modifier mon profil',
                        style: AppTheme.titleLarge.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1EFEB),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: AppIcons.svg(AppIcons.close, size: 12.sp, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Champ Prénom
                  _buildDialogField(label: 'Prénom', controller: prenomController),
                  SizedBox(height: 16.h),

                  // Champ Nom
                  _buildDialogField(label: 'Nom', controller: nomController),
                  SizedBox(height: 16.h),

                  // Champ Date de naissance
                  _buildDialogField(label: 'Date de naissance', controller: dateController),
                  SizedBox(height: 16.h),

                  // Champ email/téléphone (non modifiable)
                  _buildDialogField(
                    label: 'Adresse mail / numéro de téléphone',
                    controller: TextEditingController(text: 'laura.derhy@email.com'),
                    readOnly: true,
                  ),
                  SizedBox(height: 28.h),

                  // Bouton Enregistrer
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 174.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: Center(
                          child: Text(
                            'Enregistrer',
                            style: AppTheme.bodyMedium.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogField({required String label, required TextEditingController controller, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF565656),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: readOnly ? const Color(0xFFE5E3DF) : const Color(0xFFF1EFEB),
            borderRadius: BorderRadius.circular(8.sp),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            style: AppTheme.bodyMedium.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: readOnly ? const Color(0xFF999999) : Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
              isCollapsed: true,
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // Les 3 onglets : 78x30 chacun, 5px d'espace entre
          for (int i = 0; i < _tabs.length; i++) ...[
            GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: Container(
                width: 78.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: (_selectedTab == i && _selectedTab != 3) ? Colors.black : const Color(0xFFF1EFEB),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Center(
                  child: Text(
                    _tabs[i],
                    style: AppTheme.bodyMedium.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: (_selectedTab == i && _selectedTab != 3) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            if (i < _tabs.length - 1) SizedBox(width: 5.w),
          ],

          // Espace flexible entre Feedback et la cloche
          const Spacer(),

          // Cloche notifications : 36x30
          GestureDetector(
            onTap: () => setState(() => _selectedTab = 3),
            child: Container(
              width: 36.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: _selectedTab == 3 ? Colors.black : const Color(0xFFF1EFEB),
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Center(
                child: AppIcons.svg(
                  AppIcons.notification,
                  size: 16.sp,
                  color: _selectedTab == 3 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilTab() {
    return Column(
      children: [
        // Photo de profil
        Center(
          child: Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        SizedBox(height: 14.h),

        // Nom
        Center(
          child: Text(
            'Laura Derhy',
            style: AppTheme.titleLarge.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: 4.h),

        // Membre depuis
        Center(
          child: Text(
            'Membre depuis 2026',
            style: AppTheme.bodyMedium.copyWith(
              fontSize: 12.sp,
              color: const Color(0xFF565656),
            ),
          ),
        ),

        SizedBox(height: 18.h),

        // Bouton "Modifier mon profil"
        Center(
          child: GestureDetector(
            onTap: () => _showEditProfileDialog(),
            child: Container(
              width: 174.w,
              height: 29.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Center(
                child: Text(
                  'Modifier mon profil',
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        if (_isPremium)
          // Section statut Butter+ pour les membres premium
          _buildPremiumStatusCard()
        else
          // Bouton "Devenir membre+"
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 174.w,
                height: 29.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE189),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Center(
                  child: Text(
                    'Devenir membre+',
                    style: AppTheme.bodyMedium.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),

        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildPremiumStatusCard() {
    return Center(
      child: Container(
        width: 174.w,
        height: 29.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF5D57A),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Center(
          child: Text(
            'Membre Butter+',
            style: AppTheme.bodyMedium.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTesRecosTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),

          // Titre
          Center(
            child: Text(
              'Tu connais un restaurant qui devrait\nêtre sur Butter ?',
              textAlign: TextAlign.center,
              style: AppTheme.titleLarge.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Sous-titre
          Center(
            child: Text(
              'Enrichis Butter en nous faisant découvrir\ntes adresses préférées',
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(
                fontSize: 12.sp,
                color: const Color(0xFF565656),
              ),
            ),
          ),

          SizedBox(height: 28.h),

          // Champ "Nom du restaurant"
          _buildTextField(hint: 'Nom du restaurant', height: 35.h),

          SizedBox(height: 10.h),

          // Champ "Ville/arrondissement"
          _buildTextField(hint: 'Ville/arrondissement', height: 35.h),

          SizedBox(height: 10.h),

          // Champ "Commentaires" (multiline)
          _buildTextField(hint: 'Commentaires', height: 77.h, maxLines: 5),

          SizedBox(height: 32.h),

          // Bouton "Envoyer"
          Center(
            child: Container(
              width: 174.w,
              height: 29.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Center(
                child: Text(
                  'Envoyer',
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildFeedbackTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),

          // Titre
          Center(
            child: Text(
              'On t\'écoute et on lit tout !',
              textAlign: TextAlign.center,
              style: AppTheme.titleLarge.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Grand champ texte
          Center(
            child: Container(
              width: 260.w,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.sp),
                border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
              ),
              child: TextField(
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: AppTheme.bodyMedium.copyWith(fontSize: 12.sp),
                decoration: InputDecoration(
                  hintText: 'Remarque, conseil, demande...',
                  hintStyle: AppTheme.bodyMedium.copyWith(
                    fontSize: 12.sp,
                    color: const Color(0xFFAAAAAA),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                ),
              ),
            ),
          ),

          SizedBox(height: 32.h),

          // Bouton "Envoyer"
          Center(
            child: Container(
              width: 174.w,
              height: 29.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Center(
                child: Text(
                  'Envoyer',
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Lien email
          Center(
            child: Text(
              'contact@butterguide.com',
              style: AppTheme.bodyMedium.copyWith(
                fontSize: 12.sp,
                decoration: TextDecoration.underline,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    // Dans l'onglet Notifications, on affiche TOUTES les notifs (pas de dismiss)
    return Column(
      children: [
        ..._notifications.map((notif) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              bottom: 12.h,
            ),
            child: notif['image'] != null
                ? _buildEventNotification(notif, showDismiss: false)
                : _buildInputNotification(notif, showDismiss: false),
          );
        }),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildTextField({required String hint, required double height, int maxLines = 1}) {
    return Center(
      child: Container(
        width: 260.w,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.sp),
          border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
        ),
        child: TextField(
          maxLines: maxLines,
          textAlignVertical: maxLines == 1 ? TextAlignVertical.center : TextAlignVertical.top,
          style: AppTheme.bodyMedium.copyWith(fontSize: 12.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTheme.bodyMedium.copyWith(
              fontSize: 12.sp,
              color: const Color(0xFFAAAAAA),
            ),
            border: InputBorder.none,
            isCollapsed: maxLines == 1,
            contentPadding: maxLines == 1
                ? EdgeInsets.symmetric(horizontal: 14.w)
                : EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          ),
        ),
      ),
    );
  }

  Widget _buildAppStoreButton() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse('https://apps.apple.com/fr/app/butter-guide-de-restaurants/id6749227938');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
        width: 214.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(1.w, 1.h),
              blurRadius: 10.sp,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.svg(AppIcons.upRightArrow, size: 14.sp, color: Colors.black),
            SizedBox(width: 8.w),
            Text(
              "Donne ton avis sur l'app store",
              style: AppTheme.bodyMedium.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  /// Notification avec image à gauche (ex: Members' event)
  Widget _buildEventNotification(Map<String, dynamic> notif, {bool showDismiss = true}) {
    return Container(
      width: 347.w,
      decoration: const BoxDecoration(
        color: Color(0xFFF1EFEB),
      ),
      padding: EdgeInsets.all(11.w),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(6.sp),
              child: Image.network(
                notif['image'],
                width: 104.w,
                height: 130.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 104.w,
                  height: 130.h,
                  color: Colors.grey[300],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Texte + CTA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre + croix (si autorisé)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notif['title'],
                          style: AppTheme.titleLarge.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (showDismiss)
                        GestureDetector(
                          onTap: () => _dismissNotification(notif['id']),
                          child: AppIcons.svg(AppIcons.close, size: 18.sp, color: Colors.black),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    notif['body'],
                    style: AppTheme.bodyMedium.copyWith(
                      fontSize: 10.sp,
                      color: const Color(0xFF4A4A4A),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 10.h),
                // Bouton CTA
                if (notif['cta'] != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.sp),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      notif['cta'],
                      style: AppTheme.bodyMedium.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
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

  /// Notification avec champ de saisie (ex: Members' favorites)
  Widget _buildInputNotification(Map<String, dynamic> notif, {bool showDismiss = true}) {
    return Container(
      width: 347.w,
      height: 142.h,
      decoration: const BoxDecoration(
        color: Color(0xFFF1EFEB),
      ),
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre + croix (si autorisé)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    notif['title'],
                    style: AppTheme.titleLarge.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (showDismiss)
                GestureDetector(
                  onTap: () => _dismissNotification(notif['id']),
                  child: AppIcons.svg(AppIcons.close, size: 18.sp, color: Colors.black),
                ),
            ],
          ),

          SizedBox(height: 10.h),

          // Description centrée
          Center(
            child: Text(
              notif['body'],
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(
                fontSize: 10.sp,
                color: const Color(0xFF4A4A4A),
                height: 1.4,
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Barre de saisie avec bouton envoyer
          Container(
            height: 36.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.sp),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 14.w),
                    child: TextField(
                      style: AppTheme.bodyMedium.copyWith(fontSize: 11.sp),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Container(
                    width: 26.w,
                    height: 26.h,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
