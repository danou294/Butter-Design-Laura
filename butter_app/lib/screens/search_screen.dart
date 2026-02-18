import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../utils/responsive.dart';
import 'results_screen.dart';

class SearchScreen extends StatefulWidget {
  final String selectedCity;

  const SearchScreen({
    super.key,
    required this.selectedCity,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // État des filtres sélectionnés
  Set<String> selectedMoment = {};
  Set<String> selectedPreferences = {};
  Set<String> selectedCuisine = {};
  Set<String> selectedPrix = {};
  Set<String> selectedTypeEndroit = {};
  Set<String> selectedAmbiance = {};
  Set<String> selectedRestrictions = {};

  // État pour "Voir plus"
  bool showMoreCuisine = false;
  bool showMoreTypeEndroit = false;

  // État pour Localisation
  bool isLocalisationExpanded = false;
  Set<String> selectedZones = {};
  Set<String> selectedArrondissements = {};
  Set<String> selectedBanlieues = {};
  bool presDesMoiSelected = false;

  // Données localisation
  final List<String> zones = ['Ouest', 'Centre', 'Est'];
  final List<String> arrondissements = ['1e', '2e', '3e', '4e', '5e', '6e', '7e', '8e', '9e', '10e', '11e', '12e', '13e', '14e', '15e', '16e', '17e', '18e', '19e', '20e'];
  final List<String> banlieues = ['Boulogne', 'Levallois', 'Neuilly'];

  // Mapping zones -> arrondissements/banlieues
  final Map<String, List<String>> zoneArrondissements = {
    'Ouest': ['8e', '15e', '16e', '17e'],
    'Centre': ['1e', '2e', '3e', '4e', '5e', '6e', '7e', '9e', '14e', '18e'],
    'Est': ['10e', '11e', '12e', '13e', '19e', '20e'],
  };
  final Map<String, List<String>> zoneBanlieues = {
    'Ouest': ['Boulogne', 'Neuilly', 'Levallois'],
    'Centre': [],
    'Est': [],
  };

  void _toggleZone(String zone) {
    setState(() {
      if (selectedZones.contains(zone)) {
        // Désélectionner la zone et ses arrondissements/banlieues
        selectedZones.remove(zone);
        for (final arr in zoneArrondissements[zone] ?? []) {
          selectedArrondissements.remove(arr);
        }
        for (final ban in zoneBanlieues[zone] ?? []) {
          selectedBanlieues.remove(ban);
        }
      } else {
        // Sélectionner la zone et ses arrondissements/banlieues
        selectedZones.add(zone);
        selectedArrondissements.addAll(zoneArrondissements[zone] ?? []);
        selectedBanlieues.addAll(zoneBanlieues[zone] ?? []);
      }
    });
  }

  void _toggleArrondissement(String arr) {
    setState(() {
      if (selectedArrondissements.contains(arr)) {
        selectedArrondissements.remove(arr);
      } else {
        selectedArrondissements.add(arr);
      }
      // Mettre à jour les zones en fonction des arrondissements sélectionnés
      _updateZonesFromArrondissements();
    });
  }

  void _toggleBanlieue(String banlieue) {
    setState(() {
      if (selectedBanlieues.contains(banlieue)) {
        selectedBanlieues.remove(banlieue);
      } else {
        selectedBanlieues.add(banlieue);
      }
      // Mettre à jour les zones en fonction des banlieues sélectionnées
      _updateZonesFromArrondissements();
    });
  }

  void _updateZonesFromArrondissements() {
    // Pour chaque zone, vérifier si tous ses arrondissements et banlieues sont sélectionnés
    for (final zone in zones) {
      final zoneArrs = zoneArrondissements[zone] ?? [];
      final zoneBans = zoneBanlieues[zone] ?? [];

      final allArrsSelected = zoneArrs.every((arr) => selectedArrondissements.contains(arr));
      final allBansSelected = zoneBans.isEmpty || zoneBans.every((ban) => selectedBanlieues.contains(ban));

      if (allArrsSelected && allBansSelected && zoneArrs.isNotEmpty) {
        selectedZones.add(zone);
      } else {
        selectedZones.remove(zone);
      }
    }
  }

  // Données des filtres
  final List<String> moments = ['Petit-déjeuner - Brunch', 'Déjeuner', 'Goûter', 'Dîner', 'Drinks'];
  final List<String> preferences = ['Ouvert maintenant', 'Sans réservation', 'Salle privatisable'];
  final List<String> cuisinesBase = ['Italien', 'Méditerranéen', 'Japonais', 'Français'];
  final List<String> cuisinesExtra = ['Sud-américain', 'Chinois', 'Coréen', 'Américain'];
  final List<String> prix = ['€', '€€', '€€€', '€€€€'];
  final List<String> typesEndroitBase = ['Bar', 'Restaurant', 'Cave à manger', 'Coffee shop', 'Terrasse', 'Fast'];
  final List<String> typesEndroitExtra = ['Brasserie', 'Hôtel', 'Gastronomique'];
  final List<String> ambiances = ['Entre amis', 'En famille', 'Date', 'Festif'];
  final List<String> restrictions = ['Casher', '100% végétarien', '"Healthy"'];

  List<String> get cuisines => showMoreCuisine ? [...cuisinesBase, ...cuisinesExtra] : cuisinesBase;
  List<String> get typesEndroit => showMoreTypeEndroit ? [...typesEndroitBase, ...typesEndroitExtra] : typesEndroitBase;

  int get totalFiltersSelected =>
      selectedMoment.length +
      selectedPreferences.length +
      selectedCuisine.length +
      selectedPrix.length +
      selectedTypeEndroit.length +
      selectedAmbiance.length +
      selectedRestrictions.length +
      selectedZones.length +
      selectedArrondissements.length +
      selectedBanlieues.length +
      (presDesMoiSelected ? 1 : 0);

  List<String> get activeFiltersList {
    final filters = <String>[];
    filters.addAll(selectedMoment);
    filters.addAll(selectedPreferences);
    filters.addAll(selectedCuisine);
    filters.addAll(selectedPrix);
    filters.addAll(selectedTypeEndroit);
    filters.addAll(selectedAmbiance);
    filters.addAll(selectedRestrictions);

    // Ajouter les zones sélectionnées
    filters.addAll(selectedZones);

    // Collecter les arrondissements/banlieues déjà couverts par les zones
    final coveredArrs = <String>{};
    final coveredBans = <String>{};
    for (final zone in selectedZones) {
      coveredArrs.addAll(zoneArrondissements[zone] ?? []);
      coveredBans.addAll(zoneBanlieues[zone] ?? []);
    }

    // Ajouter seulement les arrondissements/banlieues non couverts par une zone
    for (final arr in selectedArrondissements) {
      if (!coveredArrs.contains(arr)) {
        filters.add(arr);
      }
    }
    for (final ban in selectedBanlieues) {
      if (!coveredBans.contains(ban)) {
        filters.add(ban);
      }
    }

    if (presDesMoiSelected) filters.add('Près de moi');
    return filters;
  }

  void _resetFilters() {
    setState(() {
      selectedMoment.clear();
      selectedPreferences.clear();
      selectedCuisine.clear();
      selectedPrix.clear();
      selectedTypeEndroit.clear();
      selectedAmbiance.clear();
      selectedRestrictions.clear();
      selectedZones.clear();
      selectedArrondissements.clear();
      selectedBanlieues.clear();
      presDesMoiSelected = false;
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                    // Header avec ville et bouton fermer
                    _buildHeader(),

                    SizedBox(height: 16.h),

                    // Barre de recherche
                    _buildSearchInput(),

                    SizedBox(height: 12.h),

                    // Dropdown Localisation
                    _buildLocalisationDropdown(),

                    SizedBox(height: 12.h),

                    // Section des filtres
                    _buildFiltersSection(),

                    SizedBox(height: 16.h), // Espace pour le footer fixe
                  ],
                ),
              ),
            ),

            // Footer fixe
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Column(
            children: [
              Text(
                widget.selectedCity,
                style: AppTheme.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                height: 1,
                width: 30.w,
                color: AppTheme.textPrimary,
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
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
                    child: AppIcons.svg(AppIcons.close, size: 12.sp, color: AppTheme.textPrimary
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: 56.h,
        padding: EdgeInsets.only(left: 20.w, right: 6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(1.w, 1.h),
              blurRadius: 10.sp,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                style: AppTheme.bodyMedium.copyWith(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Nom du restaurant',
                  hintStyle: AppTheme.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    color: AppTheme.textSecondary,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                // TODO: Rechercher par nom
              },
              child: Container(
                width: 89.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppTheme.textPrimary,
                  borderRadius: BorderRadius.circular(5.sp),
                ),
                child: Center(
                  child: Text(
                    'Rechercher',
                    style: AppTheme.bodyMedium.copyWith(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalisationDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(1.w, 1.h),
              blurRadius: 10.sp,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec titre et flèche
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  isLocalisationExpanded = !isLocalisationExpanded;
                });
              },
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Localisation',
                      style: AppTheme.titleLarge.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 23.w,
                      height: 23.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1EFEB),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: AnimatedRotation(
                          turns: isLocalisationExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 18.sp,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contenu déroulant
            if (isLocalisationExpanded) ...[
              SizedBox(height: 20.h),

              // Bouton "Près de moi"
              GestureDetector(
                onTap: () {
                  setState(() {
                    presDesMoiSelected = !presDesMoiSelected;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: presDesMoiSelected ? const Color(0xFFF1EFEB) : Colors.white,
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all(
                      color: presDesMoiSelected ? AppTheme.textPrimary : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Près de moi',
                      style: AppTheme.bodyMedium.copyWith(
                        fontSize: 14.sp,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Zones (Ouest, Centre, Est) avec icônes
              LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final boxWidth = (totalWidth - 2 * 7.w) / 3;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: zones.asMap().entries.map((entry) {
                      final index = entry.key;
                      final zone = entry.value;
                      final isSelected = selectedZones.contains(zone);
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () => _toggleZone(zone),
                            child: Column(
                              children: [
                                // Rectangle avec image
                                Container(
                                  width: boxWidth,
                                  height: 61.h,
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFF1EFEB) : Colors.white,
                                    borderRadius: BorderRadius.circular(10.sp),
                                    border: Border.all(
                                      color: isSelected ? AppTheme.textPrimary : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.map_outlined,
                                      size: 35.sp,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                // Texte en dessous
                                Text(
                                  zone,
                                  style: AppTheme.bodyMedium.copyWith(
                                    fontSize: 12.sp,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (index < zones.length - 1) SizedBox(width: 7.w),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),

              SizedBox(height: 20.h),

              // Grille des arrondissements (5 colonnes)
              LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final spacing = 6.w;
                  final itemWidth = (totalWidth - 4 * spacing) / 5;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: 8.h,
                    children: arrondissements.map((arr) {
                      final isSelected = selectedArrondissements.contains(arr);
                      return GestureDetector(
                        onTap: () => _toggleArrondissement(arr),
                        child: Container(
                          width: itemWidth,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFF1EFEB) : Colors.white,
                            borderRadius: BorderRadius.circular(7.sp),
                            border: Border.all(
                              color: isSelected ? AppTheme.textPrimary : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              arr,
                              style: AppTheme.bodyMedium.copyWith(
                                fontSize: 12.sp,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              SizedBox(height: 16.h),

              // Banlieues (Boulogne, Levallois, Neuilly)
              LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final boxWidth = (totalWidth - 2 * 7.w) / 3;
                  return Row(
                    children: banlieues.asMap().entries.map((entry) {
                      final index = entry.key;
                      final banlieue = entry.value;
                      final isSelected = selectedBanlieues.contains(banlieue);
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () => _toggleBanlieue(banlieue),
                            child: Container(
                              width: boxWidth,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFF1EFEB) : Colors.white,
                                borderRadius: BorderRadius.circular(8.sp),
                                border: Border.all(
                                  color: isSelected ? AppTheme.textPrimary : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  banlieue,
                                  style: AppTheme.bodyMedium.copyWith(
                                    fontSize: 12.sp,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (index < banlieues.length - 1) SizedBox(width: 7.w),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: 351.w,
        padding: EdgeInsets.all(21.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(1.w, 1.h),
              blurRadius: 10.sp,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Moment
            _buildFilterCategory(
              title: 'Moment',
              options: moments,
              selected: selectedMoment,
              onToggle: (value) {
                setState(() {
                  if (selectedMoment.contains(value)) {
                    selectedMoment.remove(value);
                  } else {
                    selectedMoment.add(value);
                  }
                });
              },
            ),

            SizedBox(height: 24.h),

            // Préférences
            _buildFilterCategory(
              title: 'Préférences',
              options: preferences,
              selected: selectedPreferences,
              onToggle: (value) {
                setState(() {
                  if (selectedPreferences.contains(value)) {
                    selectedPreferences.remove(value);
                  } else {
                    selectedPreferences.add(value);
                  }
                });
              },
            ),

            SizedBox(height: 24.h),

            // Cuisine
            _buildFilterCategory(
              title: 'Cuisine',
              options: cuisines,
              selected: selectedCuisine,
              onToggle: (value) {
                setState(() {
                  if (selectedCuisine.contains(value)) {
                    selectedCuisine.remove(value);
                  } else {
                    selectedCuisine.add(value);
                  }
                });
              },
              showVoirPlus: !showMoreCuisine,
              onVoirPlusTap: () {
                setState(() {
                  showMoreCuisine = true;
                });
              },
            ),

            SizedBox(height: 24.h),

            // Prix
            _buildFilterCategory(
              title: 'Prix',
              options: prix,
              selected: selectedPrix,
              onToggle: (value) {
                setState(() {
                  if (selectedPrix.contains(value)) {
                    selectedPrix.remove(value);
                  } else {
                    selectedPrix.add(value);
                  }
                });
              },
            ),

            SizedBox(height: 24.h),

            // Type d'endroit
            _buildFilterCategory(
              title: "Type d'endroit",
              options: typesEndroit,
              selected: selectedTypeEndroit,
              onToggle: (value) {
                setState(() {
                  if (selectedTypeEndroit.contains(value)) {
                    selectedTypeEndroit.remove(value);
                  } else {
                    selectedTypeEndroit.add(value);
                  }
                });
              },
              showVoirPlus: !showMoreTypeEndroit,
              onVoirPlusTap: () {
                setState(() {
                  showMoreTypeEndroit = true;
                });
              },
            ),

            SizedBox(height: 24.h),

            // Ambiance
            _buildFilterCategory(
              title: 'Ambiance',
              options: ambiances,
              selected: selectedAmbiance,
              onToggle: (value) {
                setState(() {
                  if (selectedAmbiance.contains(value)) {
                    selectedAmbiance.remove(value);
                  } else {
                    selectedAmbiance.add(value);
                  }
                });
              },
            ),

            SizedBox(height: 24.h),

            // Restrictions
            _buildFilterCategory(
              title: 'Restrictions',
              options: restrictions,
              selected: selectedRestrictions,
              onToggle: (value) {
                setState(() {
                  if (selectedRestrictions.contains(value)) {
                    selectedRestrictions.remove(value);
                  } else {
                    selectedRestrictions.add(value);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCategory({
    required String title,
    required List<String> options,
    required Set<String> selected,
    required Function(String) onToggle,
    bool showVoirPlus = false,
    VoidCallback? onVoirPlusTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.titleLarge.copyWith(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 9.h,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () => onToggle(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF1EFEB) : Colors.white,
                  borderRadius: BorderRadius.circular(7.sp),
                  border: Border.all(
                    color: isSelected ? AppTheme.textPrimary : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  option,
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 11.sp,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (showVoirPlus) ...[
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: onVoirPlusTap,
            child: Text(
              'Voir plus',
              style: AppTheme.bodySmall.copyWith(
                fontSize: 11.sp,
                decoration: TextDecoration.underline,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    final hasFilters = totalFiltersSelected > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _resetFilters,
            child: Text(
              'Réinitialiser',
              style: AppTheme.bodyMedium.copyWith(
                fontSize: 14.sp,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: hasFilters ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ResultsScreen(
                    activeFilters: activeFiltersList,
                    resultCount: 32,
                  ),
                ),
              );
            } : null,
            child: Container(
              width: 156.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: hasFilters ? AppTheme.textPrimary : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(21.sp),
              ),
              child: Center(
                child: Text(
                  hasFilters ? '32 résultats' : 'Résultats',
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
