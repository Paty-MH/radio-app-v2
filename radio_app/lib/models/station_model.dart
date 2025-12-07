// This Station model represents a radio station with its name, acronym, broadcast URL, slogan, image, and social media links.
class Station {
  final String name;
  final String acronym;
  final String url;
  final String slogan;
  final String imageAsset;
  final Map<String, String> socialLinks;

  const Station({
    required this.name,
    required this.acronym,
    required this.url,
    required this.slogan,
    required this.imageAsset,
    this.socialLinks = const {},
  });
}
