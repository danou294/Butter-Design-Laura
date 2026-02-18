class Restaurant {
  final String id;
  final String name;
  final String logoPath;
  final String arrondissement;
  final String cuisine;
  final String priceRange;
  final String photoLieu;
  final String photoPlat;
  final bool hasReservation;
  // Champs détail
  final String? description;
  final String? videoNote;
  final List<String> tags;
  final List<String> addresses;
  final String? horairesJour;
  final String? horairesHeures;
  final List<String> metroStations;
  final List<String> photos;
  final int saveCount;

  Restaurant({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.arrondissement,
    required this.cuisine,
    required this.priceRange,
    required this.photoLieu,
    required this.photoPlat,
    this.hasReservation = false,
    this.description,
    this.videoNote,
    this.tags = const [],
    this.addresses = const [],
    this.horairesJour,
    this.horairesHeures,
    this.metroStations = const [],
    this.photos = const [],
    this.saveCount = 0,
  });
}

// Données mock pour le développement
class MockData {
  static List<Restaurant> get recommendedRestaurants => [
    Restaurant(
      id: '1',
      name: 'CRAVAN',
      logoPath: 'assets/logos/cravan.png',
      arrondissement: 'Paris 16',
      cuisine: 'Bar à cocktails',
      priceRange: '€€€',
      photoLieu: 'assets/photos/cravan_lieu.jpg',
      photoPlat: 'assets/photos/cravan_plat.jpg',
      hasReservation: true,
      description: 'Bar à cocktails emblématique du 16ème. Ambiance feutrée et mixologie créative.',
      tags: ['Français', 'Cocktails', 'Intimiste'],
      addresses: ['17 rue Bois le Vent, 75016'],
      horairesJour: 'Lundi',
      horairesHeures: '18:00 - 02:00',
      metroStations: ['Passy'],
      saveCount: 47,
      photos: [
        'https://images.unsplash.com/photo-1470337458703-46ad1756a187?w=800',
        'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=800',
      ],
    ),
    Restaurant(
      id: '2',
      name: 'DAME',
      logoPath: 'assets/logos/dame.png',
      arrondissement: '75017, 75018',
      cuisine: 'Français',
      priceRange: '€€€',
      photoLieu: 'assets/photos/dame_lieu.jpg',
      photoPlat: 'assets/photos/dame_plat.jpg',
      hasReservation: true,
      saveCount: 124,
      description: 'Brasserie emblématique de Paris.\nCuisine raffinée et atmosphère conviviale.',
      videoNote: 'On a testé ce spot en vidéo, retrouve la ',
      tags: ['Français', 'Convivial', 'Casher'],
      addresses: ['17 rue des Dames, 75017', '18 rue des Dames, 75018'],
      horairesJour: 'Lundi',
      horairesHeures: '19:00 - 23:00',
      metroStations: ['Liège', 'Pigalle'],
      photos: [
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
        'https://images.unsplash.com/photo-1550966871-3ed3cdb51f3a?w=800',
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      ],
    ),
    Restaurant(
      id: '3',
      name: 'HALO',
      logoPath: 'assets/logos/halo.png',
      arrondissement: 'Paris 2',
      cuisine: 'Français',
      priceRange: '€€€',
      photoLieu: 'assets/photos/halo_lieu.jpg',
      photoPlat: 'assets/photos/halo_plat.jpg',
      hasReservation: true,
      saveCount: 31,
      description: 'Restaurant moderne au cœur du 2ème arrondissement.',
      tags: ['Français', 'Moderne'],
      addresses: ['12 rue Montorgueil, 75002'],
      horairesJour: 'Lundi',
      horairesHeures: '12:00 - 23:00',
      metroStations: ['Sentier', 'Grands Boulevards'],
      photos: [
        'https://images.unsplash.com/photo-1559329007-40df8a9345d8?w=800',
      ],
    ),
  ];

  static List<String> get cities => [
    'Paris',
    'Marrakech',
    'Londres',
    'Mykonos',
  ];

  static List<Map<String, String>> get quickFilters => [
    {'title': 'Date intimiste', 'subtitle': 'dans l\'ouest'},
    {'title': 'Brunch sans résa', 'subtitle': 'dans le marais'},
    {'title': 'Déj rapide', 'subtitle': 'rive gauche'},
  ];
}
