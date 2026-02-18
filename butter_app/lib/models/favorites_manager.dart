import 'package:flutter/material.dart';

/// Gère l'état des favoris (restaurants et guides enregistrés)
class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._();
  factory FavoritesManager() => _instance;
  FavoritesManager._();

  // Tous les restaurants enregistrés (= "All")
  final Set<String> _savedRestaurantIds = {};

  // Collections spécifiques
  final Set<String> _haveBeen = {};
  final Set<String> _wantToTry = {};

  // Guides enregistrés
  final Set<String> _savedGuides = {};

  // --- Restaurants ---

  bool isRestaurantSaved(String id) => _savedRestaurantIds.contains(id);
  bool isHaveBeen(String id) => _haveBeen.contains(id);
  bool isWantToTry(String id) => _wantToTry.contains(id);

  void toggleSaveRestaurant(String id) {
    if (_savedRestaurantIds.contains(id)) {
      _savedRestaurantIds.remove(id);
      _haveBeen.remove(id);
      _wantToTry.remove(id);
    } else {
      _savedRestaurantIds.add(id);
    }
    notifyListeners();
  }

  void toggleHaveBeen(String id) {
    // Enregistre automatiquement si pas encore fait
    _savedRestaurantIds.add(id);
    if (_haveBeen.contains(id)) {
      _haveBeen.remove(id);
    } else {
      _haveBeen.add(id);
    }
    notifyListeners();
  }

  void toggleWantToTry(String id) {
    // Enregistre automatiquement si pas encore fait
    _savedRestaurantIds.add(id);
    if (_wantToTry.contains(id)) {
      _wantToTry.remove(id);
    } else {
      _wantToTry.add(id);
    }
    notifyListeners();
  }

  Set<String> get savedRestaurantIds => _savedRestaurantIds;
  Set<String> get haveBeenIds => _haveBeen;
  Set<String> get wantToTryIds => _wantToTry;

  // --- Guides ---

  bool isGuideSaved(String guideTitle) => _savedGuides.contains(guideTitle);

  void toggleSaveGuide(String guideTitle) {
    if (_savedGuides.contains(guideTitle)) {
      _savedGuides.remove(guideTitle);
    } else {
      _savedGuides.add(guideTitle);
    }
    notifyListeners();
  }

  Set<String> get savedGuidesTitles => _savedGuides;
}
