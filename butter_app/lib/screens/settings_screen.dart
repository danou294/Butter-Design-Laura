import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 38.h),

                // Bouton fermer (X) en haut à droite
                Align(
                  alignment: Alignment.topRight,
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
                        child: AppIcons.svg(AppIcons.close, size: 16.sp, color: Colors.black),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // Titre "Réglages"
                Text(
                  'Réglages',
                  style: GoogleFonts.inter(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 36.h),

                // Section Préférences
                _buildSectionTitle('Préférences'),
                SizedBox(height: 16.h),
                _buildSettingsItem(
                  svgIcon: AppIcons.notification,
                  label: 'Notifications',
                ),

                SizedBox(height: 36.h),

                // Section Achats
                _buildSectionTitle('Achats'),
                SizedBox(height: 16.h),
                _buildSettingsItem(
                  label: 'Restaurer mes achats',
                ),

                SizedBox(height: 36.h),

                // Section Ressources
                _buildSectionTitle('Ressources'),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () => _showContactSupportDialog(context),
                  child: _buildSettingsItem(
                    svgIcon: AppIcons.email,
                    label: 'Contacter le support',
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: () => _launchUrl('https://apps.apple.com/fr/app/butter-guide-de-restaurants/id6749227938'),
                  child: _buildSettingsItem(
                    svgIcon: AppIcons.star,
                    label: "Noter sur l'App Store",
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: () => _launchUrl('https://www.linkedin.com/company/butterappli/'),
                  child: _buildSettingsItem(
                    svgIcon: AppIcons.linkedin,
                    label: 'Suivre Butter',
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: () => _launchUrl('https://www.instagram.com/butterguide?igsh=YWJydmVlemoyZ2s0'),
                  child: _buildSettingsItem(
                    svgIcon: AppIcons.instagram,
                    label: 'Suivre @butterguide',
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: () => _launchUrl('https://www.tiktok.com/@butterguide?_r=1&_t=ZN-941HQLVRKsw'),
                  child: _buildSettingsItem(
                    svgIcon: AppIcons.tikTok,
                    label: 'Suivre Butterguide',
                  ),
                ),

                SizedBox(height: 36.h),

                // Se déconnecter
                GestureDetector(
                  onTap: () => _showConfirmDialog(
                    context,
                    title: 'Se déconnecter',
                    message: 'Es-tu sûr(e) de vouloir te déconnecter ?',
                    confirmLabel: 'Se déconnecter',
                    onConfirm: () {
                      Navigator.of(context).pop(); // ferme dialog
                      Navigator.of(context).pop(); // retour
                    },
                  ),
                  child: _buildSettingsItem(
                    svgIcon: AppIcons.logout,
                    label: 'Se déconnecter',
                  ),
                ),
                SizedBox(height: 14.h),
                // Supprimer le compte (en rouge)
                GestureDetector(
                  onTap: () => _showConfirmDialog(
                    context,
                    title: 'Supprimer le compte',
                    message: 'Es-tu sûr(e) de vouloir supprimer ton compte ? Cette action est irréversible.',
                    confirmLabel: 'Supprimer',
                    isDestructive: true,
                    onConfirm: () {
                      Navigator.of(context).pop(); // ferme dialog
                      Navigator.of(context).pop(); // retour
                    },
                  ),
                  child: _buildSettingsItem(
                    svgIcon: AppIcons.bin,
                    label: 'Supprimer le compte',
                    isDestructive: true,
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showContactSupportDialog(BuildContext context) {
    const email = 'contact@butterguide.com';
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300.w,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16.sp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Contacter le support',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    email,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF565656),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      // Copier l'adresse
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(const ClipboardData(text: email));
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Adresse copiée !',
                                  style: GoogleFonts.inter(fontSize: 12.sp),
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1EFEB),
                              borderRadius: BorderRadius.circular(20.sp),
                            ),
                            child: Center(
                              child: Text(
                                'Copier',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Ouvrir l'app mail
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(ctx).pop();
                            _launchUrl('mailto:$email');
                          },
                          child: Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20.sp),
                            ),
                            child: Center(
                              child: Text(
                                'Envoyer un mail',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300.w,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16.sp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF565656),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(ctx).pop(),
                          child: Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1EFEB),
                              borderRadius: BorderRadius.circular(20.sp),
                            ),
                            child: Center(
                              child: Text(
                                'Annuler',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: onConfirm,
                          child: Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: isDestructive ? Colors.red : Colors.black,
                              borderRadius: BorderRadius.circular(20.sp),
                            ),
                            child: Center(
                              child: Text(
                                confirmLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSettingsItem({
    String? svgIcon,
    required String label,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w),
      child: Row(
        children: [
          if (svgIcon != null) ...[
            AppIcons.svg(
              svgIcon,
              size: 18.sp,
              color: isDestructive ? Colors.red : Colors.black,
            ),
            SizedBox(width: 12.w),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: isDestructive ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
