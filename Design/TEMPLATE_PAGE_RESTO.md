# Template - Page Restaurant Détail

> Remplis les valeurs entre [crochets]. Laisse vide si identique à la valeur actuelle.

---

## STRUCTURE GÉNÉRALE

- Fond de la page : image -20% exposition
- Blur fond image : sigma [300]
- Tint par-dessus le blur : [couleur + opacité, ex: noir 30%]

---

## BOUTON RETOUR (fixe en haut)

- Position depuis le haut : [55] (jusqu'au haut de l'écran)
- Position depuis la gauche : [17]
- Dimensions : [40] × [40]
- Forme : [cercle]
- Fond : [FFFFFF + 20%]
- Icône : [flèche] taille [25x25], couleur [blanc]

---

## CAROUSEL DE PHOTOS

- Espace au-dessus : [105]
- Hauteur du carousel : [350]
- Border radius des photos : [15]
- Espace horizontal entre photos (padding) : [5]
- viewportFraction (% de largeur visible) : espace disponible après que la largeur de la photo soit 350
- Indicateur de photo (ex: "1/7") : position [en haut à droite de l'image], taille texte [12], couleur [blanc]

---

## NOM DU RESTAURANT

- Espace après le carousel : [33]
- Taille texte : [24]
- Poids : [semi-bold]
- Couleur : [blanc]

---

## SOUS-TITRE (arrondissement - prix)

- Espace après le nom : [16]
- Taille texte : [13]
- Poids : [regular]
- Couleur : [blanc, 70%]
- Format : ["75017, 75018 – €€€"]
- Séparateur : [tiret long]

---

## TAGS (Ouvert + tags cuisine)

- Espace après le sous-titre : [19]
- Espace entre les tags : [4]

### Tag "Ouvert"
- Largeur : [64]
- Hauteur : [21]
- Border radius : [30]
- Fond : [D4F2DA]
- Texte : taille [11], poids [medium], couleur [3C8D57]

### Tags cuisine (Français, Convivial, etc.)
- Largeur : [70]
- Hauteur : [21]
- Border radius : [30]
- Fond : [sans fond]
- Bordure : [blanc 50% 0.5]
- Texte : taille [11], poids [regular], couleur [blanc 70%]

---

## 4 BOUTONS D'ACTION (Réserver, La carte, Enregistrer, Partager)

- Espace après les tags : [25]
- Espace entre les boutons : [5]
- Alignement : je sais pas à quoi ça correspond

### Chaque bouton
- Largeur : [84]
- Hauteur : [50]
- Border radius : [12]

### Bouton "Réserver" (premier)
- Fond : [blanc]
- Bordure : [non]
- Icône : [réserver, 14x14]
- Texte : taille [11], poids [medium], couleur [noir]

### Boutons "La carte", "Enregistrer", "Partager"
- Fond : [D9D9D9 + 10%]
- Bordure : [non]
- Icône : taille [14x14], couleur [blanc]
- Espace icône → texte : [7]
- Texte : taille [11], poids [medium], couleur [blanc 60%]

---

## DESCRIPTION

- Espace après les boutons d'action : [27]
- Taille texte : [12]
- Poids : [regular]
- Couleur : [blanc 100%]

---

## NOTE VIDÉO

- Espace après la description : [23]
- Largeur : [352]
- Hauteur : [47]
- Fond : [D9D9D9 20%]
- Border radius : [8]
- Padding horizontal : [18]
- Texte : taille [12], poids [regular], couleur [blanc 100%]
- Icône ↗ en haut à droite : taille [14x14], couleur [blanc]

---

## SECTION ADRESSES

- Espace après la note vidéo : [27]

### Titre de section ("Adresses")
- Taille texte : [11]
- Poids : [medium]
- Couleur : [blanc 70%]

### Séparateur
- Espace titre → séparateur : [13]
- Épaisseur : [0.2]
- Couleur : [blanc 70%]
- Espace séparateur → contenu : [11]

### Adresses (texte)
- Taille texte : [13]
- Poids : [medium]
- Couleur : [blanc 70%]
- Souligné : [oui]
- Espace entre 2 adresses : [16]
- Espace après la dernière adresse : [0]

---

## SECTION METRO

- Espace avant : [38] (ou directement après adresses)

### Titre + séparateur : [même style que Adresses / autre]

### Stations
- Disposition : [Wrap / Row / autre]
- Espace entre les stations : [72]
- Taille texte station : [13]
- Poids : [medium]
- Couleur : [blanc 70%]

### Pastille de ligne
- Position par rapport au nom : [après]
- Espace nom ↔ pastille : [6]
- Forme : [cercle]
- Diamètre : [10]
- Couleur fond : [selon la ligne]
- Numéro : taille [9], poids [regular], couleur [blanc]

- Espace après section metro : [38]

---

## SECTION HORAIRES

### Titre + séparateur : [même style que les autres sections / autre]

### Première ligne (jour + heures + flèche)
- Jour : taille [13], poids [medium], couleur [blanc 70%], largeur fixe je sais pas
- Heures : taille [13], poids [medium], couleur [blanc 70%]
- Flèche : icône [flèche], taille [14x14], couleur [blanc 70%], position [bas]

### Jours dépliés
- Même style que première ligne : [oui]
- Jour actuel en gras (semi bold)
- Jour "Fermé" → couleur heures : je sais pas 

- Espace après section horaires : [54]

---

## BOUTONS SOCIAUX (Appeler, Site web, Instagram)

- Espace avant : [86]
- Disposition : [Row centered]
- Espace entre les boutons : [4]

### Chaque bouton
- Forme : [carré + corner radius 12]
- Dimensions : [61] × [43]
- Fond : [D9D9D9 10%]
- Bordure : [non]
- Icône : taille [20x23], couleur [blanc]
- Label texte : [non]

- Espace après : [33]

---

## BLOC CONCIERGE EDGAR

- Espace avant : [20]
- Largeur : [352]
- Hauteur : [fixe 70]
- Fond : [D9D9D9 20%]
- Border radius : [8]
- Padding horizontal : [16]
- Padding vertical : [20]
- Texte : taille [12], poids [regular], couleur [blanc]
- "Contacte Edgar" : [souligné oui]

- Espace après (bas de page) : c'est toi qui gères, de sorte à ce qu'arrivés tout en bas de l'écran, la tabbar ne cache aucune info. 

---

## DIALOG CHOIX MAPS (pop adresse)

garde le design actuel 

---

## NOTES

- pour les choses où j'ai mis "je sais pas", mets ce qui te semble le mieux et ensuite on verra
