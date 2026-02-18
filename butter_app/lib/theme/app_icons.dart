import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Centralise tous les SVG custom de l'app
class AppIcons {
  AppIcons._();

  static const String _basePath = 'design/icones';

  // Navigation
  static const String home = '$_basePath/home-2.svg';
  static const String arrowBack = '$_basePath/arrow-right.svg';
  static const String arrowRight = '$_basePath/right-arrow.svg';
  static const String upRightArrow = '$_basePath/up-right-arrow.svg';
  static const String close = '$_basePath/close.svg';

  // Actions
  static const String bookmark = '$_basePath/bookmark.svg';
  static const String bookmarkFilled = '$_basePath/bookmark-filled.svg';
  static const String export = '$_basePath/export.svg';
  static const String add = '$_basePath/add.svg';
  static const String check = '$_basePath/check.svg';
  static const String search = '$_basePath/star.svg'; // à remplacer si besoin

  // Tabs
  static const String book = '$_basePath/book.svg';
  static const String user = '$_basePath/user.svg';
  static const String notification = '$_basePath/notification.svg';
  static const String settings = '$_basePath/settings.svg';

  // Social
  static const String instagram = '$_basePath/instagram-3.svg';
  static const String linkedin = '$_basePath/linkedin.svg';
  static const String tikTok = '$_basePath/tik-tok.svg';
  static const String link = '$_basePath/link.svg';
  static const String telephone = '$_basePath/telephone.svg';
  static const String email = '$_basePath/email.svg';

  // Divers
  static const String bin = '$_basePath/bin.svg';
  static const String logout = '$_basePath/logout.svg';
  static const String history = '$_basePath/history.svg';
  static const String padlock = '$_basePath/padlock.svg';
  static const String star = '$_basePath/star.svg';

  /// Widget helper pour afficher un SVG avec taille et couleur
  static Widget svg(
    String assetPath, {
    double? size,
    Color? color,
  }) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }
}
