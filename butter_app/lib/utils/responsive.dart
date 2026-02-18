import 'package:flutter/material.dart';

/// Utilitaire pour adapter les dimensions Figma (390x843) à n'importe quel écran
/// Tout est basé sur la LARGEUR pour garantir un layout identique sur tous les écrans
class Responsive {
  static const double figmaWidth = 390;
  static const double maxWidth = 430; // Largeur max pour simuler un mobile
  static const double minWidth = 320; // Largeur min (petits téléphones)

  static double _screenWidth = figmaWidth;

  /// Initialiser avec le contexte (à appeler une fois au début)
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Limiter entre minWidth et maxWidth pour garder le layout cohérent
    double width = size.width;
    if (width > maxWidth) {
      width = maxWidth;
    } else if (width < minWidth) {
      width = minWidth;
    }
    _screenWidth = width;
  }

  /// Convertir une dimension Figma en dimension responsive
  /// Basé uniquement sur la largeur pour un layout identique partout
  static double size(double figmaValue) {
    return (figmaValue / figmaWidth) * _screenWidth;
  }

  /// Largeur de l'écran (contrainte entre min et max)
  static double get screenWidth => _screenWidth;

  /// Ratio actuel par rapport au design Figma
  static double get ratio => _screenWidth / figmaWidth;
}

/// Extension pour faciliter l'utilisation
extension ResponsiveExtension on num {
  /// Dimension responsive (largeur, hauteur, padding, margin, fontSize, etc.)
  /// Tout est basé sur la largeur de l'écran
  double get w => Responsive.size(toDouble());
  double get h => Responsive.size(toDouble());
  double get sp => Responsive.size(toDouble());
}
