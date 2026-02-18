# Dimensions et Espacements - Butter App

**Base de référence : iPhone 12 Pro (390 x 844 pt)**

---

## GLOBAL

- Marge horizontale gauche/droite : 20, mais parfois on dépasse vers la droite en fonction des pages
- Couleur de fond : #FEFFFF
- Couleur texte principal : #000000
- Couleur texte secondaire : #6D6D6D
- Couleur card beige : #F1EFEB
- Couleur séparateur : #C7C7C7
- Scrollbar : épaisseur 2px, radius 1, couleur noir 26% opacité, minThumbLength 30
- Police par défaut : Inter (sauf mention contraire comme Inria Sans)

---

## ARCHITECTURE & NAVIGATION

- Navigation principale : 4 onglets (Accueil, Guides, Favoris, Compte)
- Chaque onglet a son propre Navigator imbriqué (IndexedStack + Navigator)
- Les sous-pages (restaurant détail, réglages, guide détail) restent dans l'onglet = tab bar visible
- Les overlays (recherche, coming soon ville) utilisent rootNavigator = tab bar cachée
- Re-tap sur même onglet = pop jusqu'à la racine

---

## FAKE STATUS BAR (en haut de l'écran)

- Positionnée en overlay dans le Stack de main.dart (au-dessus du contenu)
- Hauteur : 44
- Fond : transparent (le contenu des pages passe derrière)
- Dynamic Island simulée : 90×24, noir, corner radius 20
- Heure à gauche : Inter 14 semi bold
- Icônes à droite : signal (4 barres), wifi (14), batterie (22×10)
- Paramètre `isDark` : false par défaut (texte noir), true pour pages sombres (texte blanc)
- Sur web, `MediaQuery.padding.top` = 0, donc les pages utilisent un padding top manuel de 38 minimum pour ne pas chevaucher la status bar

---

## HOME SCREEN

### Header (Logo + Villes)
- Padding top : 38
- Logo : image `assets/logos/butter_logo.jpg` (V2-BNoir copie.jpg), hauteur 46
- Marge gauche du logo : 19
- Espace entre logo et première ville : 36
- Espace entre chaque ville : 40
- Taille texte ville : 14
- Ville sélectionnée : semi bold, couleur noire
- Ville non sélectionnée : regular, couleur #6D6D6D
- Largeur du soulignement ville sélectionnée : 30
- Hauteur du soulignement : 1
- Espace entre texte ville et soulignement : 4
- Villes disponibles : Paris (actif), Marrakech, Londres, Mykonos
- Clic sur ville autre que Paris → écran "Coming Soon"

### Barre de recherche
- Hauteur : 56
- Border radius : 30
- Padding horizontal interne : 20
- Taille icône loupe : 14
- Couleur icône loupe : noir à 50% opacité
- Espace entre loupe et texte : 14
- Taille texte placeholder : 14 semi bold, noir à 50% opacité
- Texte placeholder : "Commencer ma recherche"
- Drop shadow : X:0, Y:2, Blur:8, Color:#000000 8%
- Espace après barre de recherche : 11

### Filtres rapides (3 chips)
- Hauteur d'un chip : 44
- Espace entre les chips : 10
- Border radius : 6
- Padding interne : 8 gauche, 8 droite, 6 haut, 6 bas
- Taille texte titre : 9 semi bold noir
- Taille texte sous-titre : 9 regular #6D6D6D
- Drop shadow : X:0, Y:2, Blur:8, Color:#000000 6%
- Espace après filtres : 30

### Section "Recommandés pour toi"
- Taille du titre : 15 bold
- Espace entre titre et cartes : 17
- Espace après section : 33

### Featured Card (grande carte)
- Largeur : 295
- Hauteur : 288
- Border radius : 3
- Espace entre les cartes : 5
- Position icône bookmark depuis le haut : 15
- Position icône bookmark depuis la droite : 15
- Taille icône bookmark : 19 (blanc, rempli si enregistré)
- Taille nom du restaurant : 24 bold blanc
- Taille infos (cuisine - arrondissement) : 10 light blanc
- Largeur bouton "Réserver" : 78
- Hauteur bouton "Réserver" : 23
- Border radius bouton "Réserver" : 6
- Bordure bouton "Réserver" : blanche 0.5
- Taille texte bouton : 10 medium blanc
- Espace entre haut de la card et nom du restaurant : 144
- Espace entre nom du restaurant et infos : 10
- Espace entre infos et bouton réserver : 19
- Gradient overlay : transparent → noir 40%
- Clic → ouvre page restaurant détail
- Bookmark : si pas enregistré → enregistre + ouvre SaveBottomSheet. Si déjà enregistré → ouvre SaveBottomSheet directement

### Section "Restaurants italiens..."
- Taille du titre : 15 bold
- Taille texte "Tout voir" : 10 regular souligné
- Espace entre titre et "Tout voir" : 24 (SizedBox width)
- Espace entre titre et cartes : 21
- Espace entre les petites cartes : 6

### Petite carte restaurant (RestaurantCard)
- Largeur par défaut : 139
- Hauteur par défaut : 237
- Border radius : 5
- Couleur fond : #F1EFEB
- Padding : 5 gauche, 5 droite, 8 haut, 5 bas
- Taille texte infos (Paris 2 | Français | €€€) : 8, police Inria Sans
- Espace entre texte infos et icône bookmark : 8
- Taille icône bookmark : 14 (noir, outline ou rempli selon isSaved)
- Hauteur espace logo : 34
- Hauteur logo : 28
- Largeur logo placeholder : 80
- Espace entre logo et photos : 4
- Border radius des photos : 6 (coins intérieurs uniquement)
- Ratio photo lieu / photo plat : 2/3 - 1/3
- Espace entre les 2 photos : 4 (2 de chaque côté)
- Clic → ouvre page restaurant détail
- Bookmark : si pas enregistré → enregistre + ouvre SaveBottomSheet. Si déjà enregistré → ouvre SaveBottomSheet directement

---

## ESPACEMENTS VERTICAUX HOME (du haut vers le bas)

- Espace après header : 24
- Espace après barre de recherche : 11
- Espace après filtres rapides : 30
- Espace après section "Recommandés" : 33
- Espace en bas de page : 24

---

## TAB BAR (navigation principale — style glass effect flottant)

- Hauteur intérieure : 64
- Padding horizontal extérieur : 20
- Padding intérieur : 5
- Border radius extérieur : 40
- Glass effect : ClipRRect + BackdropFilter blur sigma 40/40
- Couleur fond : #F0F0F0 à 45% d'opacité
- Bordure : blanche à 40% d'opacité, épaisseur 1
- BoxShadow : noir 6% blur 16 offset(0,2)
- Indicateur animé (pill blanche) : borderRadius 34, ombre noir 6% blur 8 offset(0,2), animation 300ms easeInOut
- Taille des icônes : 20 (Guides = 22)
- Taille du texte : 10
- Espace entre icône et texte : 3
- Onglets : Accueil, Guides, Favoris, Compte
- Icône sélectionnée : couleur #1A1A1A, fontWeight w600
- Icône non sélectionnée : couleur #555555, fontWeight w500
- Icônes SVG : home-2, book, bookmark, user
- Padding bottom : safeArea bottom si > 0, sinon 12

---

## ÉCRAN COMING SOON (villes non disponibles)

- Bouton retour : 33×33, cercle, fond #F1EFEB, icône arrow_back 16, noir
- Position : 20 gauche, 12 top
- Nom de la ville : Inter bold 36, centré
- Espace nom → message : 20
- Message : Inter regular 14 #565656, centré, hauteur de ligne 1.5
- Texte : "On cherche les meilleures adresses à [ville] pour te les partager très prochainement."
- Espace → "Stay tuned !" : 8
- "Stay tuned !" : Inter semi bold 14, noir
- Contenu centré verticalement, padding horizontal 40

---

## PAGE RECHERCHE

### Header
- Padding : 20 horizontal, 12 vertical
- Taille texte ville : 14 medium, centré
- Soulignement ville : largeur 30, hauteur 1, noir
- Taille bouton fermer (X) : 33x33
- Forme bouton X : rond (cercle)
- Couleur fond bouton X : #F1EFEB
- Taille icône croix : 12
- Navigation : rootNavigator (cache la tab bar)

### Barre de recherche
- Hauteur : 56
- Border radius : 30
- Padding gauche : 20, padding droite : 6
- Placeholder : "Nom du restaurant"
- Taille texte : 14
- Largeur bouton "Rechercher" : 89
- Hauteur bouton "Rechercher" : 24
- Border radius bouton "Rechercher" : 5
- Couleur bouton : noir
- Taille texte bouton : 10 medium blanc
- Marge droite bouton "Rechercher" : 14
- Drop shadow : X:1, Y:1, Blur:10, Color:#000000 20%
- Espace après : 12

### Dropdown Localisation (dépliable)
- Padding interne : 20
- Border radius : 30
- Taille texte "Localisation" : 17 bold
- Bouton flèche : rond 23x23
- Couleur fond bouton flèche : #F1EFEB
- Taille icône flèche : 18
- Rotation flèche ouverte : 180°
- Animation : 300ms
- Drop shadow : X:1, Y:1, Blur:10, Color:#000000 20%
- Zone cliquable : toute la ligne header (titre + flèche)
- Espace après : 12

#### Contenu déplié
- Espace avant contenu : 20
- Bouton "Près de moi" : largeur 100%, hauteur 36, border radius 8
- Espace après "Près de moi" : 20

- Zones (Ouest, Centre, Est) :
  - Hauteur rectangles : 61
  - Border radius : 10
  - Icône : map_outlined, taille 35
  - Spacing entre rectangles : 7
  - Texte zone : en dessous, fontSize 12
  - Espace après texte : 8
  - Espace après zones : 20

- Arrondissements (1e à 20e) :
  - Grille : 5 colonnes
  - Hauteur : 36
  - Border radius : 7
  - Spacing horizontal : 6
  - Spacing vertical : 8
  - Taille texte : 12
  - Espace après : 16

- Banlieues (Boulogne, Levallois, Neuilly) :
  - Hauteur : 28
  - Border radius : 8
  - Spacing entre boxes : 7
  - Taille texte : 12

- État sélectionné (tous éléments) : fond #F1EFEB, contour noir
- État normal : fond blanc, contour gris

### Section filtres (bloc blanc)
- Largeur : 351
- Padding interne : 21
- Border radius : 30
- Drop shadow : X:1, Y:1, Blur:10, Color:#000000 20%

### Titres de catégorie
- Taille : 17 bold
- Espace titre → chips : 20
- Espace vertical entre catégories : 24

### Chips de filtre
- Padding horizontal : 15
- Padding vertical : 6
- Border radius : 7
- Taille texte : 11
- Gap horizontal : 10
- Gap vertical : 9
- État normal : fond blanc, contour gris (#D1D5DB)
- État sélectionné : fond #F1EFEB, contour noir

### Données des filtres
- Moment : Petit-déjeuner - Brunch, Déjeuner, Goûter, Dîner, Drinks
- Préférences : Ouvert maintenant, Sans réservation, Salle privatisable
- Cuisine (base) : Italien, Méditerranéen, Japonais, Français
- Cuisine (voir plus) : Sud-américain, Chinois, Coréen, Américain
- Prix : €, €€, €€€, €€€€
- Type d'endroit (base) : Bar, Restaurant, Cave à manger, Coffee shop, Terrasse, Fast
- Type d'endroit (voir plus) : Brasserie, Hôtel, Gastronomique
- Ambiance : Entre amis, En famille, Date, Festif
- Restrictions : Casher, 100% végétarien, "Healthy"

### Footer recherche
- Padding vertical : 24, horizontal : 20
- Bordure top : gris clair
- Taille texte "Réinitialiser" : 14, souligné, medium
- Bouton "Résultats" : 156×42, border radius 21
- État désactivé : fond gris / État actif : fond noir
- Taille texte bouton : 14 medium blanc

---

## PAGE RÉSULTATS

### Header
- Padding : 20 horizontal, 73 top
- Bouton retour : 33x33, rond, fond #F1EFEB, icône keyboard_arrow_left 20, noir
- **Le bouton retour est AU-DESSUS du titre (pas à gauche sur la même ligne)**
- Espace bouton → titre : 12
- Titre "Résultats" : 28 semi-bold (w600)
- Espace titre → sous-titre : 4
- Sous-titre : "X adresses correspondantes", 10 semi bold noir

### Filtres actifs (chips scrollables)
- Hauteur : 27
- Padding horizontal : 20
- Espace entre chips : 8
- Padding horizontal chip : 12
- Border radius chip : 6
- Couleur fond chip : #F1EFEB
- Taille texte chip : 12 noir
- Espace après filtres : 33

### Grille masonry résultats
- Padding horizontal : 20
- Espace entre colonnes : 8
- Décalage colonne droite : 40
- Espace entre cartes : 12
- Carte restaurant : 177x267
- Clic sur carte → page restaurant détail

---

## PAGE RESTAURANT DÉTAIL

### Structure
- Fond : noir
- Couche 1 : Image plein écran en fond (Image.asset 'assets/image_1436.png', Positioned.fill, BoxFit.cover)
- Couche 2 : Blur plein écran (ClipRect + BackdropFilter sigma 300/300 + Container noir 10%)
- Couche 3 : Contenu scrollable (SingleChildScrollView dans Stack)
- Couche 4 : Boutons retour et share fixes (Positioned)

### Bouton retour (fixe, en haut à gauche)
- Position : top 55, left 17
- Dimensions : 40×40, cercle
- Fond : blanc 20% opacité
- Icône : Icons.keyboard_arrow_left, taille 25, blanc

### Bouton share (fixe, en haut à droite)
- Position : top 55, right 17
- Dimensions : 40×40, cercle
- Fond : blanc 20% opacité
- Icône : AppIcons.export SVG, taille 18, blanc
- Action : Share.share("J'ai trouvé ce restaurant sur Butter : [nom]")

### Carousel de photos
- Espace au-dessus : 105
- Hauteur : 400
- Border radius : 15
- viewportFraction : 360/390
- Padding horizontal entre photos : 5
- Indicateur "1/7" : top 12, right 12, Inter regular 12, blanc

### Nom du restaurant
- Espace après carousel : 33
- Taille : 24 semi-bold (w600)
- Couleur : blanc

### Sous-titre (arrondissement – prix)
- Espace après nom : 8
- Taille : 13 regular
- Couleur : blanc 70%
- Séparateur : tiret long (–)

### Tags (Ouvert + tags cuisine)
- Espace après sous-titre : 19
- Espace entre tags : 4
- Tag "Ouvert" : 64×21, radius 30, fond #D4F2DA, texte 11 medium #3C8D57
- Tags cuisine : 70×21, radius 30, sans fond, bordure blanc 50% 0.5, texte 11 regular blanc 70%

### 3 boutons d'action (Réserver, La carte, Enregistrer)
- Espace après tags : 25
- Disposition : Row spaceBetween
- Chaque bouton : 114×49, radius 10
- "Réserver" (premier) : fond blanc, icône calendar_today_outlined 14, texte 11 medium noir
- "La carte" : fond D9D9D9 10%, icône menu 14, texte 11 medium blanc 60%
- "Enregistrer" : fond D9D9D9 10%, icône bookmark 14, texte 11 medium blanc 60%

### Description
- Espace après boutons : 27
- Taille : 12 regular
- Couleur : blanc 100%
- Hauteur de ligne : 1.5

### Note vidéo
- Espace après description : 23
- Largeur : 352
- Hauteur : 47
- Fond : D9D9D9 20%
- Border radius : 8
- Padding horizontal : 18
- Texte : 12 regular blanc
- Icône flèche : up-right-arrow 14, blanc

### Section Adresses
- Espace après note vidéo : 27
- Titre "Adresse(s)" : 11 medium, blanc 70%
- Séparateur : espace 13 dessus, épaisseur 0.2, blanc 70%, espace 11 dessous
- Adresses : 13 medium blanc, souligné, cliquable → dialog Maps
- Espace entre adresses : 16
- Espace après section : 38

### Dialog choix Maps
- barrierColor : noir 20%
- Glass effect : ClipRRect + BackdropFilter blur sigma 30
- Container : largeur 280, padding 20, corner 16
- Fond : blanc 50% opacité, bordure blanche 30% 0.5
- Titre "Ouvrir avec" : Inter 16 bold noir
- 3 boutons : Apple Plans, Google Maps, Waze (hauteur 40, fond #F1EFEB, corner 30, texte 13 medium noir, espace 10)

### Section Metro
- Espace avant : 38
- Stations en Wrap, spacing 72, runSpacing 10
- Nom station : 13 medium blanc
- Pastille ligne : cercle 13, couleur selon ligne, numéro 9 regular blanc
- Espace nom → pastille : 10
- Espace après : 38

### Section Horaires (dépliable)
- Titre + séparateur : même style que les autres
- Première ligne : jour + heures (Expanded) + flèche déroulante (AnimatedRotation 200ms)
- Flèche : keyboard_arrow_down 14, blanc 70%
- Jours : 13 medium blanc, largeur fixe 90
- Heures : 13 medium blanc (ou blanc 30% si Fermé)
- Jour actuel : semi-bold (w600)
- Espace après : 54

### Boutons sociaux (téléphone, site web, Instagram)
- 3 boutons : 61×43, radius 12, fond D9D9D9 10%
- Icônes : 20, blanc
- Espace entre boutons : 4
- Espace avant : centré dans la Row
- Espace après : 33

### Bloc Concierge Edgar
- Largeur : 352, hauteur auto
- Fond : D9D9D9 20%, radius 8
- Padding : 16 horizontal, 20 vertical
- Texte : 12 regular blanc, hauteur de ligne 1.5
- "Contacte Edgar" : souligné
- Action : ouvre WhatsApp au +33 9 72 10 54 08 avec message pré-écrit :
  "Hello Edgar, j'ai besoin d'une table chez [nom du restaurant] que j'ai trouvé sur Butter, tu peux m'aider ?"

### Espace bas de page : 120

---

## PAGE GUIDES

### Header
- Padding : 20 horizontal, 73 top
- Titre "Guides" : 28 semi-bold (w600)
- Espace après titre : 24 (avant section coups de coeur)

### Section "Coups de coeur de la semaine"
- Taille titre : 15 bold
- Padding gauche titre : 20
- Espace titre → cartes : 15
- Hauteur du carrousel : 237
- Padding gauche du carrousel : 20
- Carte : RestaurantCard 139×237
- Espace entre cartes : 5
- Espace après section : 20

### Séparateur
- Largeur : 352, centré
- Hauteur : 0.5
- Couleur : #C7C7C7
- Espace après séparateur : 21

### Grille guides (2 colonnes)
- Padding horizontal : 20
- Hauteur d'une rangée : 194
- Espace entre les 2 colonnes : 11
- Espace entre les rangées : 24

### Guide Card
- Largeur : Expanded (flexible)
- Image : occupe toute la largeur, flexible en hauteur
- Border radius image : 3
- Icône bookmark : 14×19, blanc, en haut à droite (8 du haut, 8 de la droite)
- Bookmark rempli si guide enregistré, outline sinon
- Espace image → titre : 8
- Titre : 11 regular noir

---

## PAGE GUIDE DÉTAIL

### Header
- Bouton retour : 33x33, rond, fond #F1EFEB, icône keyboard_arrow_left 20, noir
- **Le bouton retour est À GAUCHE du titre "Guides" sur la même ligne**
- Position : 20 gauche, 73 top
- Espace bouton → titre : 12
- Titre "Guides" : 28 semi-bold (w600)
- Espace titre → nom du guide : 24

### Contenu
- Nom du guide : 20 bold, padding horizontal 20, Expanded(flex: 3) pour limiter la largeur
- Espace entre titre et bookmark : 24
- Icône bookmark : 22, noir, outline ou rempli selon isSaved
- Bookmark décalé vers le bas : padding top 4 (pour aligner le haut de l'icône avec le haut du titre)
- Espace nom → description : 12
- Description : 11 regular #4A4A4A, hauteur de ligne 1.5, padding horizontal 20
- Espace description → grille : 24

### Grille masonry restaurants
- Padding horizontal : 20
- Espace entre colonnes : 8
- Décalage colonne droite : 40
- Espace entre cartes : 12
- Carte restaurant : 177×267
- Clic sur carte → page restaurant détail

---

## FAVORIS

### Header
- Padding : 20 horizontal, 73 top
- Titre "Favoris" : 28 semi-bold (w600) noir
- Espace après titre : 27

### Barre de progression
- Largeur : 255
- Hauteur barre : 8
- Border radius : 10
- Couleur fond : #FEE189 à 20% opacité
- Couleur remplissage : #FEE189 à 100%
- Indicateur : emoji beurre 🧈 (taille 31 × 0.8 = ~25)
- Hauteur totale du bloc : 31
- Espace après barre : 11

### Sous-texte
- Style : Inter Regular 10, couleur #565656
- Texte : "Tu as testé X% de tes adresses enregistrées"

### Onglets de filtrage
- Dimensions par bouton : 78×30
- Border radius : 20
- Espace entre boutons : 8
- Texte : Inter 10 Semi bold
- État normal : fond #F1EFEB, texte noir
- État sélectionné : fond noir, texte blanc
- Onglets : All, Want to try, Have been, Guides
- Scroll horizontal, padding horizontal : 20
- Espace header → onglets : 22
- Espace onglets → contenu : 18

### Section Guides (dans favoris)
- Titre "Guides" : 15 bold
- Espace titre → cartes : 15
- Hauteur carrousel : 180
- Largeur carte guide : 172
- Espace entre cartes : 9
- Padding gauche : 20

### Séparateur
- Largeur : 352, centré
- Hauteur : 0.5
- Couleur : #C7C7C7
- Espace avant/après : 24

### Grille masonry favoris
- Padding horizontal : 20
- Espace entre colonnes : 8
- Décalage colonne droite : 40
- Espace entre cartes : 12
- Carte restaurant : 177×267
- Clic sur carte → page restaurant détail

### Message vide
- Padding : 20 horizontal, 40 vertical
- Taille texte : 12, couleur #565656, centré

---

## POP SAVE (Bottom Sheet)

- Fond : #FEFFFF
- Border radius haut : 16
- Poignée : 36×4, border radius 2, couleur #C7C7C7
- Ligne "Enregistré" : texte 18 bold + icône bookmark 22 noir (rempli si enregistré, outline sinon)
- Icône bookmark cliquable : tap → unsave + animation visuelle (setState) + fermeture après 350ms
- Lignes collection : padding 24h × 16v, texte 14 semi bold
- Sous-texte collection : 10 regular #565656
- Icône non sélectionnée : add 20 #C7C7C7
- Icône sélectionnée : check 20 noir
- Séparateur : #D9D9D9 0.5
- Pas de bouton "Retirer" — on unsave via l'icône bookmark du header

---

## COMPTE

### Header
- Icône réglages : settings, 22, noir → cliquable, navigue vers Réglages
- Position : 20 droite, 73 top
- Titre "Compte" : 28 semi-bold (w600), padding gauche 20
- Espace titre → onglets : 20

### Onglets (tab bar interne)
- Padding horizontal : 20
- 3 onglets texte : Profil, Tes recos, Feedback (index 0, 1, 2)
- 1 onglet icône : cloche notifications (index 3)
- Dimensions par onglet texte : 78×30
- Bouton cloche : 36×30
- Border radius : 20
- Espace entre onglets texte : 5
- Espace flexible (Spacer) entre Feedback et cloche
- État non sélectionné : fond #F1EFEB, texte/icône noir
- État sélectionné : fond noir, texte/icône blanc
- Texte : 11 semi bold
- Icône cloche : notification SVG, 16
- Espace après onglets : 28

### Layout global
- Structure : Column > Expanded(SingleChildScrollView) + bouton fixé en bas
- Bouton "Donne ton avis" fixé en bas avec padding bottom 100

### Profil (onglet 0)
- Photo de profil : 80×80, cercle
- Espace photo → nom : 14
- Nom : 18 bold
- Espace nom → membre depuis : 4
- "Membre depuis 2026" : 12 regular #565656
- Espace → bouton modifier : 18
- Bouton "Modifier mon profil" : 174×29, fond noir, border radius 20, texte Inter bold 11 blanc
- Espace → bouton premium : 12

### Bouton Premium (si membre)
- "Membre Butter+" : 174×29, fond #F5D57A (jaune beurre), border radius 20, texte Inter bold 11 noir
- Pas de gradient, pas de "Renouvellement le..."
- Simple bouton pill, même taille que "Modifier mon profil"

### Bouton "Devenir membre+" (si non-membre)
- 174×29, fond #FEE189 (jaune doré), border radius 20, texte Inter bold 11 noir

### Tes recos (onglet 1)
- Espace avant contenu : 40
- Titre : Inter bold 15, centré
- Espace titre → sous-titre : 16
- Sous-titre : Inter regular 12 #565656, centré
- Espace sous-titre → champs : 28
- Champs de saisie : largeur 260, corner radius 6, bordure #D1D5DB 1px
  - "Nom du restaurant" : hauteur 35, single-line, centrage vertical (isCollapsed + TextAlignVertical.center)
  - "Ville/arrondissement" : hauteur 35, single-line, centrage vertical
  - "Commentaires" : hauteur 77, multiline, alignement haut
  - Espace entre champs : 10
  - Placeholder : Inter regular 12 #AAAAAA
  - Padding horizontal : 14
- Espace champs → bouton Envoyer : 32
- Bouton "Envoyer" : 174×29, fond noir, border radius 20, texte Inter bold 11 blanc

### Feedback (onglet 2)
- Espace avant contenu : 40
- Titre : "On t'écoute et on lit tout !", Inter bold 15, centré
- Espace titre → textarea : 24
- Textarea : 260×200, corner radius 6, bordure #D1D5DB 1px
  - Placeholder : "Remarque, conseil, demande...", Inter regular 12 #AAAAAA
  - Padding : 14 horizontal, 14 vertical
  - Multiline, alignement haut (expands: true)
- Espace textarea → bouton : 32
- Bouton "Envoyer" : 174×29, fond noir, border radius 20
- Espace → lien : 20
- "contact@butterguide.com" : Inter regular 12, noir, souligné

### Notifications (onglet 3 - cloche)
- Affiche les notifications (même format que les bannières du profil)
- Notifications dismissables (croix pour fermer)
- Si toutes fermées : "Aucune notification", Inter regular 14 #565656, centré, margin top 60

#### Notification avec image (Event)
- Dimensions : 347×auto, fond #F1EFEB, corner radius 0
- Padding interne : 11
- Image : 104×130, border radius 6
- Titre : 13 bold + icône close 18
- Body : 10 regular #4A4A4A, hauteur de ligne 1.4
- Bouton CTA : padding 14h × 6v, border radius 15, bordure noire 1px, texte 10 semi bold

#### Notification avec input (Favorites)
- Dimensions : 347×142, fond #F1EFEB
- Padding : 14
- Titre : 13 bold, centré + icône close 18
- Body : 10 regular #4A4A4A, centré
- Input : hauteur 36, border radius 18, fond blanc
- Bouton envoyer : 26×26, cercle noir, icône arrow_upward 14 blanc

### Bouton "Donne ton avis sur l'app store" (fixé en bas)
- Dimensions : 214×36
- Fond : blanc
- Border radius : 8
- Drop shadow : X:1, Y:1, Blur:10, Color:#000000 15%
- Icône : up-right-arrow SVG, 14, noir
- Espace icône → texte : 8
- Texte : Inter medium 12 noir
- Padding bottom : 100
- **Action : ouvre https://apps.apple.com/fr/app/butter-guide-de-restaurants/id6749227938**

---

## RÉGLAGES

- Navigation : poussé depuis l'icône réglages du Compte (dans le Navigator de l'onglet = tab bar visible)
- Fond : #FEFFFF
- Padding horizontal : 20

### Header
- Bouton fermer (X) : 33×33, cercle, fond #F1EFEB, icône close 16 noir, aligné à droite
- Position : 38 top
- Espace bouton → titre : 8
- Titre "Réglages" : Inter bold 36, noir

### Sections
- Espace avant première section : 36
- Titre de section : Inter bold 16, noir
- Espace titre → premier item : 16
- Espace entre items : 14
- Espace entre sections : 36

### Items
- Padding gauche : 24
- Icône (optionnelle) : 18, noir (ou rouge si destructif)
- Espace icône → texte : 12
- Texte : Inter regular 14, noir (ou rouge si destructif)

### Contenu des sections
- **Préférences** : Notifications (icône notification SVG)
- **Achats** : Restaurer mes achats (pas d'icône)
- **Ressources** :
  - Contacter le support (email) → dialog avec options Copier / Envoyer un mail à contact@butterguide.com
  - Noter sur l'App Store (star) → https://apps.apple.com/fr/app/butter-guide-de-restaurants/id6749227938
  - Suivre Butter (linkedin) → https://www.linkedin.com/company/butterappli/
  - Suivre @butterguide (instagram-3) → https://www.instagram.com/butterguide?igsh=YWJydmVlemoyZ2s0
  - Suivre Butterguide (tik-tok) → https://www.tiktok.com/@butterguide?_r=1&_t=ZN-941HQLVRKsw
- **Actions** : Se déconnecter (icône logout), Supprimer le compte (icône bin, rouge)

### Dialog Contact Support
- Largeur : 300, padding 24, corner 16
- Fond : backgroundColor
- Titre : Inter 18 bold noir
- Email affiché : Inter 13 regular #565656
- 2 boutons :
  - "Copier" : fond #F1EFEB, texte Inter 12 semi-bold noir → copie dans presse-papier + snackbar "Adresse copiée !"
  - "Envoyer un mail" : fond noir, texte Inter 12 semi-bold blanc → ouvre mailto:contact@butterguide.com

---

## LIENS EXTERNES DE L'APP

- **Contact support** : contact@butterguide.com (dialog avec copier / ouvrir mail)
- **App Store** : https://apps.apple.com/fr/app/butter-guide-de-restaurants/id6749227938
- **LinkedIn** : https://www.linkedin.com/company/butterappli/
- **Instagram** : https://www.instagram.com/butterguide?igsh=YWJydmVlemoyZ2s0
- **TikTok** : https://www.tiktok.com/@butterguide?_r=1&_t=ZN-941HQLVRKsw
- **Contacte Edgar (WhatsApp)** : +33 9 72 10 54 08, message pré-écrit avec nom du resto
- **Share resto** : Share natif avec "J'ai trouvé ce restaurant sur Butter : [nom]"

---

## MODÈLE DE DONNÉES RESTAURANT

```
Restaurant {
  id, name, logoPath, arrondissement, cuisine, priceRange,
  photoLieu, photoPlat, hasReservation,
  description?, videoNote?, tags[], addresses[],
  horairesJour?, horairesHeures?, metroStations[], photos[],
  saveCount
}
```

### Données mock
- CRAVAN : Paris 16, Bar à cocktails, €€€, hasReservation: true, metro: [Passy], saveCount: 47
- DAME : 75017/75018, Français, €€€, tags: [Français, Convivial, Casher], metro: [Liège, Pigalle], saveCount: 124
- HALO : Paris 2, Français, €€€, metro: [Sentier, Grands Boulevards], saveCount: 31

---

## NOTES

- Toutes les dimensions sont en points (pt) basées sur iPhone 12 Pro (390×844)
- Le système responsive convertit automatiquement via `.w`, `.h`, `.sp` extensions
- `.w` = basé sur largeur (390), `.h` = basé sur hauteur (844), `.sp` = basé sur largeur (pour texte)
- **En réalité, .w, .h et .sp utilisent TOUS le même calcul basé sur la largeur**
- Police par défaut : Inter (sauf mention contraire comme Inria Sans)
- Les drop shadows utilisent le format : X, Y, Blur, Color avec opacité
- Singleton FavoritesManager gère l'état des favoris (restaurants + guides)
- Restaurant bookmark → toujours ouvre SaveBottomSheet (enregistre d'abord si pas encore enregistré)
- Unsave d'un restaurant → via l'icône bookmark dans le header du SaveBottomSheet
- Guide bookmark → toggle direct (pas de bottom sheet)
- Tout enregistrement va automatiquement dans "All"
- Sur le web, MediaQuery.padding.top = 0, donc padding top manuel de 38 minimum sur toutes les pages
- La FakeStatusBar est transparente : elle n'a pas de fond opaque, le contenu peut passer derrière
