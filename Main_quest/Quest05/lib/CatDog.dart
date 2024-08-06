class CatDogClassifier {
  static const List<String> _catBreeds = [
    'Abyssinian', 'Bengal', 'Birman', 'Bombay', 'British', 'Egyptian',
    'Maine', 'Persian', 'Ragdoll', 'Russian', 'Siamese', 'Sphynx'
  ];

  static const List<String> _dogBreeds = [
    'American', 'Basset', 'Beagle', 'Boxer', 'Chihuahua', 'English',
    'German', 'Great', 'Havanese', 'Japanese', 'Keeshond', 'Leonberger',
    'Miniature', 'Newfoundland', 'Pomeranian', 'Pug', 'Saint', 'Samoyed',
    'Scottish', 'Shiba', 'Staffordshire', 'Wheaten', 'Yorkshire'
  ];

  static String classify(String label) {
    final normalizedLabel = label.toLowerCase().trim();

    if (_catBreeds.any((breed) => normalizedLabel.contains(breed.toLowerCase()))) {
      return '고양이';
    } else if (_dogBreeds.any((breed) => normalizedLabel.contains(breed.toLowerCase()))) {
      return '강아지';
    } else {
      return '기타';
    }
  }
}