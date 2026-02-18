# Prompt de reproduction complète - Butter App

> Ce prompt permet à une IA de reproduire exactement le design actuel de l'application Butter en Flutter.

---

## CONTEXTE

Tu vas créer une application Flutter appelée **Butter**, une app de découverte de restaurants à Paris. L'app cible l'**iPhone 12 Pro (390×844 pt)** et tourne en Flutter Web (Chrome). Toute l'interface est en français. La police par défaut est **Google Fonts Inter** (sauf mention contraire).

---

## 1. STRUCTURE DU PROJET

```
butter_app/
├── pubspec.yaml
├── design/
│   └── icones/                          # SVGs custom (25 fichiers)
├── assets/
│   ├── logos/                           # Logos restaurants (PNG) + butter_logo.jpg
│   └── image_1436.png                   # Image fond restaurant détail
├── lib/
│   ├── main.dart                        # Entry point + MainScreen avec navigation
│   ├── theme/
│   │   ├── app_theme.dart               # Couleurs, styles, thème global
│   │   └── app_icons.dart               # Chemins SVG + helper widget
│   ├── utils/
│   │   └── responsive.dart              # Système responsive (390×844 base)
│   ├── models/
│   │   ├── restaurant.dart              # Modèle Restaurant + MockData
│   │   └── favorites_manager.dart       # Singleton ChangeNotifier pour favoris
│   ├── screens/
│   │   ├── home_screen.dart             # Accueil (header, recherche, filtres, carrousels)
│   │   ├── search_screen.dart           # Recherche plein écran avec filtres
│   │   ├── results_screen.dart          # Résultats en grille masonry
│   │   ├── restaurant_detail_screen.dart# Détail restaurant (blur plein écran)
│   │   ├── guides_screen.dart           # Liste des guides
│   │   ├── guide_detail_screen.dart     # Détail d'un guide
│   │   ├── favorites_screen.dart        # Favoris avec filtres et progression
│   │   ├── account_screen.dart          # Compte (Profil, Recos, Feedback, Notifs)
│   │   └── settings_screen.dart         # Réglages
│   └── widgets/
│       ├── custom_tab_bar.dart          # Tab bar flottante glass effect
│       ├── fake_status_bar.dart         # Fausse status bar iPhone (heure, signal, batterie)
│       ├── restaurant_card.dart         # Petite carte restaurant (beige)
│       ├── featured_restaurant_card.dart# Grande carte featured (avec image)
│       ├── guide_card.dart              # Carte guide (image + titre)
│       └── save_bottom_sheet.dart       # Bottom sheet "Enregistré"
```

---

## 2. DÉPENDANCES (pubspec.yaml)

```yaml
environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.17
  url_launcher: ^6.2.5
  share_plus: ^7.2.2

flutter:
  uses-material-design: true
  assets:
    - design/icones/
    - assets/logos/
    - assets/
```

---

## 3. SYSTÈME RESPONSIVE (responsive.dart)

Classe `Responsive` + extensions `.w`, `.h`, `.sp` sur `num`.

- Largeur Figma de base : **390**
- Limite min : 320, max : 430
- Conversion : `(valeur / 390) * largeurÉcran`
- `.w`, `.h` et `.sp` utilisent **tous le même calcul** basé sur la largeur
- `Responsive.init(context)` appelé dans le build du MainScreen

**Utilisation** : TOUTES les dimensions utilisent ces extensions. Aucune valeur brute.

---

## 4. ICÔNES SVG (app_icons.dart)

Toutes les icônes sont des **SVG custom** dans `design/icones/`. La classe `AppIcons` centralise les chemins et fournit un widget helper.

```
Fichiers SVG disponibles :
home-2.svg, arrow-right.svg, right-arrow.svg, up-right-arrow.svg, close.svg,
bookmark.svg, bookmark-filled.svg, export.svg, add.svg, check.svg, star.svg,
book.svg, user.svg, notification.svg, settings.svg,
instagram-3.svg, linkedin.svg, tik-tok.svg, link.svg, telephone.svg, email.svg,
bin.svg, logout.svg, history.svg, padlock.svg
```

**Helper** : `AppIcons.svg(assetPath, size: double?, color: Color?)` → retourne un `SvgPicture.asset` avec `ColorFilter.mode(color, BlendMode.srcIn)`.

---

## 5. THÈME (app_theme.dart)

```
Couleurs :
- backgroundColor : #FEFFFF (fond app — PAS blanc pur)
- cardBackground : #F1EFEB (beige chaud)
- textPrimary : #000000
- textSecondary : #6D6D6D
- chipBackground : #FFFFFF
- chipBorder : #E0E0E0
- accentColor : #1A1A1A

Styles de texte (tous en Inter sauf cardInfo) :
- titleLarge : 15, bold, noir
- titleMedium : 14, semi-bold, noir
- bodyMedium : 12, regular, noir
- bodySmall : 10, regular, #6D6D6D
- cardInfo : Inria Sans, 11, regular, noir  ← seule exception à Inter
- chipText : 11, regular, noir
- tabLabel : 10, regular, noir

ThemeData :
- scrollbarTheme : thickness 2.0, radius 1.0, thumbColor noir 26%, minThumbLength 30
```

---

## 6. MODÈLE DE DONNÉES

### Restaurant
```dart
class Restaurant {
  String id, name, logoPath, arrondissement, cuisine, priceRange;
  String photoLieu, photoPlat;
  bool hasReservation;  // default: false
  String? description, videoNote;
  List<String> tags, addresses, metroStations, photos;
  String? horairesJour, horairesHeures;
  int saveCount;  // default: 0
}
```

### MockData
3 restaurants recommandés :
- **CRAVAN** : Paris 16, Bar à cocktails, €€€, hasReservation: true, tags [Français, Cocktails, Intimiste], metro [Passy], 2 photos Unsplash, saveCount: 47
- **DAME** : 75017/75018, Français, €€€, hasReservation: true, tags [Français, Convivial, Casher], metro [Liège, Pigalle], 3 photos, saveCount: 124
- **HALO** : Paris 2, Français, €€€, hasReservation: true, tags [Français, Moderne], metro [Sentier, Grands Boulevards], 1 photo, saveCount: 31

4 villes : Paris, Marrakech, Londres, Mykonos
3 filtres rapides : "Date intimiste / dans l'ouest", "Brunch sans résa / dans le marais", "Déj rapide / rive gauche"

### FavoritesManager
Singleton (ChangeNotifier) avec 3 ensembles : `_savedRestaurantIds` (All), `_haveBeen`, `_wantToTry`, et `_savedGuides`. Toggle dans une sous-collection ajoute automatiquement dans All.

---

## 7. NAVIGATION (main.dart)

### Architecture
- `MaterialApp` → `Center` → `Container(maxWidth: 430)` → `MainScreen`
- `MainScreen` : `Scaffold` avec `Stack` contenant :
  - `IndexedStack` avec 4 `Navigator` imbriqués (un par onglet, chacun avec son `GlobalKey<NavigatorState>`)
  - `Positioned(top: 0)` → `FakeStatusBar` (overlay transparent en haut, au-dessus du contenu)
  - `Positioned(left: 0, right: 0, bottom: 0)` → `CustomTabBar` (flottant par-dessus le contenu)
- Re-tap sur le même onglet = `popUntil((route) => route.isFirst)`
- Fond scaffold : `AppTheme.backgroundColor`
- Pas de gradient overlay en haut — la FakeStatusBar est transparente

### 4 onglets
0. **Accueil** → HomeScreen
1. **Guides** → GuidesScreen
2. **Favoris** → FavoritesScreen
3. **Compte** → AccountScreen

### Navigation
- Intra-onglet (tab bar visible) : `Navigator.of(context).push()` — RestaurantDetailScreen, SettingsScreen, GuideDetailScreen
- Plein écran (tab bar cachée) : `Navigator.of(context, rootNavigator: true).push()` — SearchScreen, ComingSoonScreen

---

## 8. FAKE STATUS BAR (fake_status_bar.dart)

Simule la status bar iPhone avec Dynamic Island pour l'aperçu web.

### Structure
- Container hauteur 44.h, padding horizontal 24.w
- Row spaceBetween :
  - **Gauche** : heure (HH:mm) en Inter 14.sp semi bold
  - **Centre** : Dynamic Island simulée (Container 90.w × 24.h, noir, borderRadius 20.sp)
  - **Droite** : signal (4 barres de 3.w, hauteurs 4-11.h, spacing 1.w), wifi (Icons.wifi 14.sp), batterie (Container 22.w × 10.h avec bordure + remplissage + terminal 1.5.w × 4.h)
- Paramètre `isDark` (default false) : contrôle si le texte/icônes sont noirs (false) ou blancs (true)
- Fond transparent — le contenu des pages peut passer derrière

### Note web
Sur le web, `MediaQuery.of(context).padding.top` retourne 0. Toutes les pages doivent donc utiliser un padding top explicite de minimum 38.h pour ne pas chevaucher la FakeStatusBar.

---

## 9. TAB BAR FLOTTANTE (custom_tab_bar.dart)

Design inspiré de **Luma** : pill flottante avec glass effect et indicateur animé.

### Structure
- `Container` extérieur : padding bottom = safeArea > 0 ? safeArea : 12.h, couleur transparente
- `Padding` horizontal 20.w
- `ClipRRect` borderRadius 40.sp → `BackdropFilter` blur sigma 40/40
- `Container` intérieur : hauteur 64.h, padding 5.w/5.h
  - Fond : **#F0F0F0 à 45% d'opacité** (glass effect)
  - BorderRadius 40.sp
  - **Bordure blanche** : 40% opacité, épaisseur 1
  - BoxShadow : noir 6% blur 16 offset(0,2)

### Indicateur animé (sliding pill)
- `LayoutBuilder` → `Stack` :
  - `AnimatedPositioned` : durée 300ms, courbe easeInOut
  - Position : `left = currentIndex * (largeur / 4)`, width = `largeur / 4`
  - Décor : fond blanc, borderRadius 34.sp, boxShadow noir 6% blur 8 offset(0,2)

### Items (Row de 4 Expanded égaux)
- `GestureDetector` + `Column(mainAxisAlignment: center)` :
  - Icône SVG : 20.sp (sauf Guides = 22.sp)
  - Espace 3.h
  - Texte : Inter 10.sp
  - **Sélectionné** : couleur #1A1A1A, fontWeight **w600**
  - **Non sélectionné** : couleur **#555555**, fontWeight **w500**

### Icônes
- Accueil : AppIcons.home (home-2.svg)
- Guides : AppIcons.book (book.svg), iconSize: 22.sp
- Favoris : AppIcons.bookmark (bookmark.svg)
- Compte : AppIcons.user (user.svg)

### TabBarStyle (conservé pour compatibilité)
```dart
class TabBarStyle {
  static final ValueNotifier<bool> isDarkBackground = ValueNotifier(false);
}
```
Le restaurant detail screen set `isDarkBackground = true` en initState et `false` en dispose.

---

## 10. HOME SCREEN

### Header
- Padding top : 38.h
- Logo Butter : `Image.asset('assets/logos/butter_logo.jpg', height: 46.sp)`, marge gauche 19.w
- Villes : espace après logo 36.w, espace entre villes 40.w
- Ville sélectionnée : 14.sp semi-bold noir + soulignement (30.w largeur, 1 hauteur, espace 4.h)
- Ville non sélectionnée : 14.sp regular #6D6D6D
- Tap Paris → sélectionne. Autres villes → écran ComingSoonScreen (rootNavigator)

### Barre de recherche
- Hauteur 56.h, borderRadius 30.sp, padding horizontal 20.w
- Icône `Icons.search` 14.sp noir 50%, espace 14.w, texte "Commencer ma recherche" 14.sp semi-bold noir 50%
- Shadow : offset(0, 2.h) blur 8.sp noir 8%
- Tap → SearchScreen (rootNavigator, transition slide-up 300ms easeOutCubic)

### Filtres rapides (3 chips en Row)
- Marge top : 11.h après la barre
- Expanded chacun, espace 10.w entre eux
- Hauteur 44.h, borderRadius 6.sp, padding 8.w/6.h
- Titre 9.sp semi-bold noir, sous-titre 9.sp regular #6D6D6D
- Shadow : offset(0, 2.h) blur 8.sp noir 6%

### Section "Recommandés pour toi"
- Marge top : 30.h
- Titre "Recommandés pour toi" : 15.sp bold, padding gauche 20.w
- Espace titre → cartes : 17.h
- `ListView.builder` horizontal, `SizedBox` hauteur 288.h, padding gauche 20.w
- Espace entre cartes : 5.w
- Utilise `FeaturedRestaurantCard` avec callbacks onTap, onReserveTap, onBookmarkTap
- Tap → `RestaurantDetailScreen`
- **Bookmark** : si pas enregistré → enregistre + ouvre SaveBottomSheet. Si déjà enregistré → ouvre SaveBottomSheet directement

### Section "Restaurants italiens pour un first date"
- Marge top : 33.h
- Titre 15.sp bold + "Tout voir" (10.sp regular souligné) aligné à droite, espace 24.w entre les deux
- Espace titre → cartes : 21.h
- `ListView.builder` horizontal, `SizedBox` hauteur 237.h, padding gauche 20.w
- Espace entre cartes : 6.w
- Utilise `RestaurantCard` standard

### Bottom padding
- 100.h en bas pour la tab bar flottante

---

## 11. FEATURED RESTAURANT CARD

- 295.w × 288.h, borderRadius 3.sp
- Image de fond fixe (Unsplash) + gradient overlay (transparent → noir 40%)
- Bookmark en haut droite : top 15.h, right 15.w, AppIcons.bookmark 19.sp blanc (rempli si isSaved)

### Contenu ancré en BAS (`Positioned bottom: 24.h, left: 0, right: 0`)
- Nom : Inter 24.sp bold blanc, centré
- Espace 10.h
- "cuisine - arrondissement" : Inter 10.sp w300 blanc, centré
- Espace 19.h
- Bouton "Réserver" (TOUJOURS affiché, pas conditionnel) : 78.w × 23.h, borderRadius 6.sp, bordure blanche 0.5, fond transparent, texte Inter 10.sp w500 blanc

---

## 12. RESTAURANT CARD (petite carte beige)

- 139.w × 237.h (par défaut, taille customisable via cardWidth/cardHeight), borderRadius 5.sp, fond #F1EFEB
- Padding : 5.w gauche/droite, 8.h haut, 5.h bas

### Contenu (Column)
1. **Ligne info** : "Paris 2 | Français | €€€" — **Inria Sans** 8.sp regular noir + espace 8.w + icône AppIcons.bookmark 14.sp noir (rempli si isSaved)
2. **Logo** : SizedBox hauteur 34.h, logo 28.h (placeholder gris 80.w × 28.h si absent)
3. **Espace 4.h**
4. **Photos** (Expanded, Row) : 2/3 lieu + 1/3 plat, padding 2.w entre
   - Lieu : borderRadius 6.sp topLeft+bottomLeft
   - Plat : borderRadius 6.sp topRight+bottomRight
   - Images Unsplash hardcodées

### Bookmark comportement
- Premier tap → enregistre dans All + ouvre SaveBottomSheet
- Déjà enregistré → ouvre SaveBottomSheet pour modifier

---

## 13. SAVE BOTTOM SHEET

- `showModalBottomSheet`, `useRootNavigator: true`, fond transparent
- Container : fond #FEFFFF, borderRadius haut 16.sp
- Poignée : 36.w × 4.h, borderRadius 2.sp, #C7C7C7
- **Header** : "Enregistré" 18.sp bold + AppIcons.bookmark 22.sp noir (rempli si enregistré, outline sinon)
  - **L'icône bookmark du header est cliquable** : tap → unsave (setState pour feedback visuel) → fermeture automatique après 350ms
- Compteur de saves (si saveCount >= 10) : "X personnes ont enregistré ce restaurant" 11.sp #888888
- **"Have been"** : padding 24.w × 16.h, texte 14.sp semi bold + sous-texte "Restaurants que tu as testés" 10.sp #565656
  - Icône : AppIcons.check 20.sp noir si sélectionné, AppIcons.add 20.sp #C7C7C7 sinon
- Séparateur #D9D9D9 0.5
- **"Want to try"** : même format, sous-texte "Ta wishlist de restaurants"
- Pas de bouton "Retirer des favoris" — l'unsave se fait via l'icône bookmark du header

---

## 14. RESTAURANT DETAIL SCREEN

### Architecture globale
`Scaffold` fond noir, body = **Stack** à 4 couches :

**Couche 1 — Image fond plein écran** :
- `Positioned.fill` → `Image.asset('assets/image_1436.png')`, fit: cover

**Couche 2 — Blur plein écran** :
- `Positioned.fill` → `ClipRect` → `BackdropFilter(sigmaX: 300, sigmaY: 300)` → `Container(color: noir 10%)`

**Couche 3 — Contenu scrollable** :
- `SingleChildScrollView` → `Column`

**Couche 4 — Boutons fixes** :
- Bouton retour : `Positioned` top: 55.h, left: 17.w
  - 40.w × 40.h cercle, fond blanc 20% opacité, `Icons.keyboard_arrow_left` 25.sp blanc
- Bouton share : `Positioned` top: 55.h, right: 17.w
  - 40.w × 40.h cercle, fond blanc 20% opacité, `AppIcons.export` 18.sp blanc
  - Action : `Share.share("J'ai trouvé ce restaurant sur Butter : ${r.name}")`

### Carousel de photos
- `SizedBox(height: 105.h)` en haut
- `SizedBox(height: 400.h)` contenant un `PageView.builder`
- `PageController(viewportFraction: 360 / 390)`
- Chaque photo : `Padding(horizontal: 5.w)` → `ClipRRect(borderRadius: 15.sp)` → Image
- Indicateur "1/7" : top 12.h, right 12.w, Inter regular 12.sp blanc

### Section info restaurant (`_buildRestaurantInfo`)
- Padding horizontal 20.w
- Nom : Inter **24.sp** semi-bold (w600) blanc
- Espace 8.h, "arrondissement – prix" : Inter 13.sp regular blanc 70%
- Espace 19.h, Tags row :
  - Tag "Ouvert" : 64.w × 21.h, borderRadius 30, fond #D4F2DA, texte Inter 11.sp w500 #3C8D57
  - Tags cuisine : 70.w × 21.h, borderRadius 30, fond transparent, bordure blanche 50% 0.5, texte Inter 11.sp regular blanc 70%
  - Espace entre tags : 4.w
- Espace 25.h, **3 boutons d'action** (Row spaceBetween) :
  - Chacun 114.w × 49.h, borderRadius 10.sp
  - **"Réserver"** (isFirst) : fond blanc, icône calendar_today_outlined 14.sp noir, texte 11.sp w500 noir
  - **"La carte"** : fond #D9D9D9 10%, icône `Icons.menu` 14.sp blanc, texte 11.sp w500 blanc 60%
  - **"Enregistrer"** : fond #D9D9D9 10%, AppIcons.bookmark 14.sp blanc, texte 11.sp w500 blanc 60%
    - Tap → enregistre si pas encore + ouvre SaveBottomSheet
  - Espace icône → texte : 7.h
- Espace 27.h

### Section pré-blur (`_buildPreBlurContent`)
- Description : Inter 12.sp regular blanc, hauteur ligne 1.5
- Espace 23.h
- Note vidéo : Container 352.w × 47.h, fond #D9D9D9 20%, borderRadius 8.sp, padding horizontal 18.w
  - Texte Inter 12.sp regular blanc + icône AppIcons.upRightArrow 14.sp blanc à droite
- Espace 27.h

### Section post-blur (`_buildBlurContent`)
Les titres de section utilisent `_buildSectionTitle` : Inter 11.sp w500 blanc 70% + ligne horizontale 0.2 blanc 70% + espaces 13.h dessus / 11.h dessous

**Adresses** :
- Chaque adresse : Inter 13.sp w500 blanc, souligné, cliquable (GestureDetector → dialog choix Maps)
- Espace entre adresses : 16.h, espace après : 38.h

**Dialog choix Maps** :
- barrierColor : noir 20%
- Glass effect : ClipRRect + BackdropFilter blur sigma 30
- Container : largeur 280.w, padding 20.w, borderRadius 16.sp
- Fond : blanc 50% opacité, bordure blanche 30% opacité 0.5
- Titre "Ouvrir avec" : Inter 16.sp bold noir
- 3 boutons : Apple Plans, Google Maps, Waze
  - Hauteur 40.h, fond #F1EFEB, borderRadius 30.sp, texte Inter 13.sp w500 noir, espace 10.h
- **Pas de bouton "Annuler"** — fermeture en tapant à l'extérieur

**Metro** :
- `Wrap` spacing 72.w, runSpacing 10.h
- Chaque station : `Row(mainAxisSize: MainAxisSize.min)` avec :
  - Nom : Inter 13.sp w500 blanc
  - Espace 10.w
  - Pastille : cercle 13.sp, couleur selon ligne (ligne 2 = #0065AE bleu), numéro Inter 9.sp regular blanc height 1.0
- Espace après : 38.h

**Horaires (dépliable)** :
- Header cliquable : toggle `_horairesExpanded`
- Première ligne = Row avec :
  - Expanded : jour + heures (via `_buildHoraireRow`)
  - `AnimatedRotation` flèche (0 ou 0.5 tours, 200ms), keyboard_arrow_down 14.sp blanc 70%
- Jour : SizedBox 90.w, Inter 13.sp w500 blanc
- Heures : Inter 13.sp w500 blanc (ou blanc 30% si "Fermé")
- Jour actuel : w600 (semi-bold)
- Spacing bottom 6.h par ligne
- Espace après : 54.h

**Boutons sociaux (Row centered)** :
- 3 boutons : téléphone, site web (link), Instagram
- Style : 61.w × 43.h, fond #D9D9D9 10%, borderRadius 12.sp
- Icônes : 20.sp blanc
- Espace entre boutons : 4.w
- Espace après : 33.h

**Bloc Concierge Edgar** :
- Container 352.w, auto hauteur, fond #D9D9D9 20%, borderRadius 8.sp, padding 16.w/20.h
- RichText aligné à gauche, Inter 12.sp regular blanc, hauteur 1.5
- "Contacte Edgar" souligné (underline + decorationColor blanc)
- **Action WhatsApp** : ouvre `https://wa.me/33972105408?text=[message encodé]`
- Message : "Hello Edgar, j'ai besoin d'une table chez [nom du restaurant] que j'ai trouvé sur Butter, tu peux m'aider ?"

**Espace bas : 120.h** (pour la tab bar)

---

## 15. SEARCH SCREEN (plein écran, cache la tab bar)

### Header
- Padding 20.w/12.h, ville centrée 14.sp medium + soulignement 30.w × 1 noir
- Bouton fermer (X) à droite : 33.w × 33.h cercle #F1EFEB, AppIcons.close 12.sp

### Barre de recherche
- 56.h, borderRadius 30.sp, padding gauche 20.w / droite 6.w
- TextField "Nom du restaurant" 14.sp + bouton "Rechercher" (89.w × 24.h, noir, borderRadius 5.sp, texte 10.sp medium blanc) + marge droite 14.w
- Shadow : offset(1.w, 1.h) blur 10.sp noir 20%

### Dropdown Localisation
- AnimatedContainer, padding 20.w, borderRadius 30.sp, même shadow
- Titre "Localisation" 17.sp bold + bouton flèche (23.w × 23.h cercle #F1EFEB, keyboard_arrow_down 18.sp, rotation animée 300ms)

**Contenu déplié :**
- "Près de moi" : pleine largeur, 36.h, borderRadius 8.sp
- Zones (Ouest, Centre, Est) : rectangles 61.h, borderRadius 10.sp, Icons.map_outlined 35.sp, espace 7.w, texte 12.sp
- Arrondissements (1e→20e) : grille 5 colonnes, 36.h, borderRadius 7.sp, spacing 6.w/8.h
- Banlieues (Boulogne, Levallois, Neuilly) : 28.h, borderRadius 8.sp, espace 7.w
- Sélectionné : fond #F1EFEB + contour noir. Normal : fond blanc + contour gris
- Sync zone ↔ arrondissements ↔ banlieues automatique

### Section Filtres
- Container 351.w, padding 21.w, borderRadius 30.sp, même shadow
- 7 catégories (titre 17.sp bold, espace 20.h avant chips, espace 24.h entre catégories) :
  - **Moment** : Petit-déjeuner - Brunch, Déjeuner, Goûter, Dîner, Drinks
  - **Préférences** : Ouvert maintenant, Sans réservation, Salle privatisable
  - **Cuisine** : Italien, Méditerranéen, Japonais, Français (+Voir plus: Sud-américain, Chinois, Coréen, Américain)
  - **Prix** : €, €€, €€€, €€€€
  - **Type d'endroit** : Bar, Restaurant, Cave à manger, Coffee shop, Terrasse, Fast (+Voir plus: Brasserie, Hôtel, Gastronomique)
  - **Ambiance** : Entre amis, En famille, Date, Festif
  - **Restrictions** : Casher, 100% végétarien, "Healthy"
- Chips : padding 15.w/6.h, borderRadius 7.sp, texte 11.sp, Wrap spacing 10.w/9.h

### Footer (fixé en bas)
- Padding 24.h/20.w, bordure top gris
- "Réinitialiser" : 14.sp medium souligné
- Bouton "32 résultats" : 156.w × 42.h, borderRadius 21.sp, fond noir (actif) / gris (désactivé), texte 14.sp medium blanc

---

## 16. RESULTS SCREEN

### Header
- Padding : 20.w horizontal, 73.h top
- Bouton retour : 33×33 cercle #F1EFEB, Icons.keyboard_arrow_left 20.sp noir
- **Le bouton retour est AU-DESSUS du titre, pas à gauche sur la même ligne**
- Espace bouton → titre : 12.h
- "Résultats" 28.sp semi-bold (w600)
- "X adresses correspondantes" 10.sp semi-bold noir

### Filtres actifs
- Chips scrollables, hauteur 27.h, padding 20.w
- Chip : padding 12.w, borderRadius 6.sp, fond #F1EFEB, texte 12.sp, espace 8.w

### Grille masonry
- Padding 20.w, espace colonnes 8.w, décalage colonne droite 40.h
- Cartes 177.w × 267.h, espace 12.h
- 6 restaurants mock

---

## 17. GUIDES SCREEN

### Header
- "Guides" 28.sp semi-bold (w600), padding 20.w/73.h top

### "Coups de coeur de la semaine"
- Titre 15.sp bold, espace 15.h
- ListView horizontal, hauteur 237.h, RestaurantCard 139.w × 237.h, espace 5.w

### Séparateur
- 352.w centré, 0.5 hauteur, #C7C7C7, espace 20.h/21.h

### Grille guides (2 colonnes)
- Padding 20.w, rangées hauteur 194.h, espace colonnes 11.w, espace rangées 24.h
- 4 guides : "Manger au comptoir", "Nouveaux sur Butter", "Brunchs à Paris", "Date spots"
- GuideCard : image (Expanded, borderRadius 3.sp) + bookmark (top 8.h right 8.w, blanc, rempli si enregistré) + titre 11.sp

### Bottom padding : 100.h

---

## 18. GUIDE DETAIL SCREEN

- Bouton retour : 33×33 cercle #F1EFEB, Icons.keyboard_arrow_left 20.sp noir
- **Le bouton retour est À GAUCHE du titre "Guides" sur la même ligne** (Row)
- Position : padding 20.w horizontal, 73.h top
- Espace bouton → titre : 12.w
- "Guides" 28.sp semi-bold (w600)
- Nom du guide : 20.sp bold, Expanded(flex: 3) + espace 24.w + AppIcons.bookmark 22.sp noir (rempli si enregistré)
- Bookmark décalé : Padding(top: 4.h)
- Description 11.sp #4A4A4A hauteur 1.5
- Grille masonry : cartes 177.w × 267.h, décalage droite 40.h, espace 8.w / 12.h

---

## 19. FAVORITES SCREEN

### Header
- "Favoris" 28.sp semi-bold (w600), padding top 73.h

### Barre de progression
- Largeur 255.w, hauteur barre 8.h, borderRadius 10.sp
- Fond : #FEE189 20%, remplissage : #FEE189 100%
- Indicateur : emoji 🧈 (taille 31 × 0.8), positionné sur le bord
- "Tu as testé X% de tes adresses enregistrées" 10.sp #565656

### Onglets
- 4 boutons (78.w × 30.h, borderRadius 20.sp, espace 8.w) : All, Want to try, Have been, Guides
- Sélectionné : fond noir, texte blanc 10.sp semi-bold
- Normal : fond #F1EFEB, texte noir

### Contenu
- Section Guides : carrousel 180.h, cartes 172.w, espace 9.w
- Séparateur 352.w centré, 0.5 #C7C7C7
- Grille masonry (même format)
- Message vide : "Rien ici pour le moment.\nEnregistre des adresses pour les retrouver ici !"

### Bottom padding : 100.h

---

## 20. ACCOUNT SCREEN

### Structure
- `Column` → `Expanded(SingleChildScrollView)` + bouton fixé en bas

### Header
- Icône AppIcons.settings 22.sp noir en haut droite (20.w right, **73.h top**) → SettingsScreen
- "Compte" 28.sp semi-bold (w600)

### Onglets internes
- 3 onglets (78.w × 30.h, borderRadius 20.sp, espace 5.w) : Profil, Tes recos, Feedback
- 1 cloche (36.w × 30.h, borderRadius 20.sp), séparée par Spacer
- Sélectionné : fond noir, texte/icône blanc. Normal : fond #F1EFEB, texte/icône noir
- Texte : 11.sp semi-bold, icône cloche : AppIcons.notification 16.sp

### Profil (tab 0)
- Photo 80.w × 80.h cercle, nom "Laura Derhy" 18.sp bold, "Membre depuis 2026" 12.sp #565656
- Bouton "Modifier mon profil" 174.w × 29.h noir, borderRadius 20.sp, texte 11.sp bold blanc
- Espace 12.h
- **Si premium** : bouton "Membre Butter+" 174.w × 29.h, fond #F5D57A (jaune beurre), borderRadius 20.sp, texte 11.sp bold noir
  - Pas de gradient, pas de "Renouvellement le..."
- **Si non-premium** : bouton "Devenir membre+" 174.w × 29.h, fond #FEE189, borderRadius 20.sp, texte 11.sp bold noir

### Modifier mon profil (dialog)
- Container 320.w, padding 24.w, borderRadius 16.sp, fond backgroundColor
- Titre "Modifier mon profil" 18.sp bold + bouton fermer (28×28 cercle #F1EFEB, close 12.sp)
- 4 champs : Prénom, Nom, Date de naissance, Email (readOnly, fond #E5E3DF)
- Champs : hauteur 40.h, fond #F1EFEB, borderRadius 8.sp, texte 13.sp w500
- Labels : 11.sp w500 #565656
- Bouton "Enregistrer" 174.w × 36.h noir, borderRadius 20.sp

### Tes recos (tab 1)
- Formulaire centré : "Tu connais un restaurant..." 15.sp bold
- 3 champs (260.w, borderRadius 6.sp, bordure #D1D5DB) : Nom, Ville, Commentaires (77.h multiline)
- Bouton "Envoyer" 174.w × 29.h

### Feedback (tab 2)
- "On t'écoute et on lit tout !" 15.sp bold
- Textarea 260.w × 200.h + bouton "Envoyer"
- "contact@butterguide.com" 12.sp souligné

### Notifications (tab 3 = cloche)
- 2 notifications mock :
  - **Event** (347.w, fond #F1EFEB) : image 104.w × 130.h + titre 13.sp bold + body 10.sp #4A4A4A + CTA
  - **Input** (347.w × 142.h, fond #F1EFEB) : titre centré + body + champ texte avec bouton envoyer rond (26×26 noir, arrow_upward 14.sp blanc)

### Bouton "Donne ton avis sur l'app store"
- 214.w × 36.h blanc, borderRadius 8.sp, shadow offset(1,1) blur 10 noir 15%
- AppIcons.upRightArrow 14.sp + texte Inter medium 12.sp
- Padding bottom : **100.h**
- **Action** : ouvre https://apps.apple.com/fr/app/butter-guide-de-restaurants/id6749227938

---

## 21. SETTINGS SCREEN

- Padding horizontal 20.w, top padding 38.h
- Bouton fermer (X) aligné droite, "Réglages" Inter bold 36.sp

### Sections (espace 36.h entre)
Titre : Inter bold 16.sp, espace 16.h avant items, espace 14.h entre items
Item : padding gauche 24.w, icône SVG 18.sp + espace 12.w + texte Inter regular 14.sp

- **Préférences** : Notifications (notification.svg)
- **Achats** : Restaurer mes achats (pas d'icône)
- **Ressources** :
  - Contacter le support (email.svg) → dialog avec options "Copier" / "Envoyer un mail" à contact@butterguide.com
  - Noter sur l'App Store (star.svg) → https://apps.apple.com/fr/app/butter-guide-de-restaurants/id6749227938
  - Suivre Butter (linkedin.svg) → https://www.linkedin.com/company/butterappli/
  - Suivre @butterguide (instagram-3.svg) → https://www.instagram.com/butterguide?igsh=YWJydmVlemoyZ2s0
  - Suivre Butterguide (tik-tok.svg) → https://www.tiktok.com/@butterguide?_r=1&_t=ZN-941HQLVRKsw
- **Actions** : Se déconnecter (logout.svg), Supprimer le compte (bin.svg, **texte et icône en rouge**)

### Dialog Contact Support
- Largeur 300.w, padding 24.w, borderRadius 16.sp, fond backgroundColor
- Titre "Contacter le support" Inter 18.sp bold
- Email "contact@butterguide.com" Inter 13.sp #565656
- 2 boutons côte à côte (Expanded chacun, espace 10.w) :
  - "Copier" : 36.h, fond #F1EFEB, borderRadius 20.sp → copie email + snackbar "Adresse copiée !"
  - "Envoyer un mail" : 36.h, fond noir, texte blanc → ouvre mailto:contact@butterguide.com

### Dialogs de confirmation (déconnexion, suppression)
- Largeur 300.w, padding 24.w, borderRadius 16.sp
- Titre 18.sp bold + message 13.sp #565656
- 2 boutons : "Annuler" (#F1EFEB) + "Confirmer" (noir, ou rouge si destructif)

---

## 22. COMING SOON SCREEN

- Intégré dans home_screen.dart (class `_ComingSoonScreen`)
- Navigation : rootNavigator = true
- Bouton retour : 33×33 cercle #F1EFEB, AppIcons.arrowBack 16.sp noir
- Contenu centré, padding 40.w :
  - Nom ville : Inter bold 36.sp
  - Message "On cherche les meilleures adresses..." 14.sp #565656
  - "Stay tuned !" 14.sp semi-bold noir

---

## 23. LIENS EXTERNES

- **Contact support** : contact@butterguide.com (dialog avec copier / ouvrir mail)
- **App Store** : https://apps.apple.com/fr/app/butter-guide-de-restaurants/id6749227938
- **LinkedIn** : https://www.linkedin.com/company/butterappli/
- **Instagram** : https://www.instagram.com/butterguide?igsh=YWJydmVlemoyZ2s0
- **TikTok** : https://www.tiktok.com/@butterguide?_r=1&_t=ZN-941HQLVRKsw
- **Contacte Edgar (WhatsApp)** : +33 9 72 10 54 08 via https://wa.me/33972105408?text=[message encodé]
  - Message : "Hello Edgar, j'ai besoin d'une table chez [nom du restaurant] que j'ai trouvé sur Butter, tu peux m'aider ?"
- **Share restaurant** : Share natif (share_plus) avec "J'ai trouvé ce restaurant sur Butter : [nom du resto]"

---

## 24. INTERACTIONS ET COMPORTEMENTS

### Bookmark restaurant
1. Premier tap sur bookmark (carte ou featured card) → enregistre dans All + ouvre SaveBottomSheet
2. Déjà enregistré → ouvre SaveBottomSheet directement pour modifier collections
3. Bottom sheet : "Have been" et "Want to try" (toggle indépendants)
4. **Unsave** : tap sur l'icône bookmark dans le header du bottom sheet → unsave visuel (setState) + fermeture après 350ms

### Bookmark guide
- Toggle direct (pas de bottom sheet)
- Icône : outline si pas enregistré, rempli si enregistré

### Navigation
- Toutes les cartes restaurant naviguent vers RestaurantDetailScreen
- Toutes les cartes guide naviguent vers GuideDetailScreen
- Re-tap même onglet tab bar = pop racine

### Filtres recherche
- Sync zone ↔ arrondissements automatique
- "Voir plus" sur Cuisine et Type d'endroit
- "Réinitialiser" remet tout à zéro
- Bouton résultats actif quand >= 1 filtre

### Tab bar
- Animation smooth de la pill blanche entre onglets (300ms easeInOut)
- Glass effect (BackdropFilter blur 40 + fond #F0F0F0 à 45% + bordure blanche)
- Toutes les pages ont 100.h de padding en bas (sauf restaurant detail = 120.h)

---

## 25. RÈGLES DE DESIGN

- **Tout** est en unités relatives via `.w`, `.h`, `.sp` — jamais de valeurs brutes
- `.w`, `.h` et `.sp` utilisent **tous le même calcul** basé sur la largeur (390)
- Fond de l'app : **#FEFFFF** (pas blanc pur)
- Cartes beiges : **#F1EFEB**
- Police par défaut : **Inter** sauf ligne info petites cartes (**Inria Sans**)
- Boutons ronds navigation : 33×33 cercle #F1EFEB, icône keyboard_arrow_left 20.sp noir
- Bouton retour fiche restaurant : 40×40 cercle blanc 20%, icône keyboard_arrow_left 25.sp blanc
- Boutons action principaux (Envoyer, Modifier) : 174×29 noir borderRadius 20, texte Inter bold 11 blanc
- Bouton premium : 174×29, fond #F5D57A (jaune beurre), même style
- Grilles masonry : 2 colonnes Expanded, colonne droite décalée de 40.h
- Shadows : `BoxShadow(color, offset, blurRadius, spreadRadius: 0)`
- Tab bar flottante : Positioned dans un Stack dans main.dart (pas bottomNavigationBar)
- FakeStatusBar transparente en overlay — pas de gradient blanc global
- Sur le web, padding top minimum de 38.h sur toutes les pages pour ne pas chevaucher la FakeStatusBar
