class CatDogClassifier {
  // 새로운 고양이 품종 목록
  static const List<String> _catBreeds = [
    'Abyssinian',
    'Bengal',
    'Birman',
    'Bombay',
    'British Shorthair',
    'Egyptian Mau',
    'Maine Coon',
    'Persian',
    'Ragdoll',
    'Russian Blue',
    'Siamese',
    'Sphynx',
  ];

  // 새로운 개 품종 목록
  static const List<String> _dogBreeds = [
    'american bulldog',
    'american pit bull terrier',
    'basset hound',
    'beagle',
    'boxer',
    'chihuahua',
    'english cocker spaniel',
    'english setter',
    'german shorthaired',
    'great pyrenees',
    'havanese',
    'japanese chin',
    'keeshond',
    'leonberger',
    'miniature pinscher',
    'newfoundland',
    'pomeranian',
    'pug',
    'saint bernard',
    'samoyed',
    'scottish terrier',
    'shiba inu',
    'staffordshire bull terrier',
    'wheaten terrier',
    'yorkshire terrier',
  ];

  // 주어진 레이블이 고양이 품종인지 개 품종인지 판별
  static String classify(String label) {
    // 레이블을 소문자로 변환하여 비교
    final lowerLabel = label.toLowerCase();

    // 고양이 품종인지 확인
    if (_catBreeds.any((breed) => lowerLabel.contains(breed.toLowerCase()))) {
      return 'cat';
    }

    // 개 품종인지 확인
    if (_dogBreeds.any((breed) => lowerLabel.contains(breed.toLowerCase()))) {
      return 'dog';
    }

    // 고양이와 개 품종이 아닌 경우
    return 'etc';
  }
}