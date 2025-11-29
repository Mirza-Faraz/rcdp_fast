class AssetHelper {
  // Images
  static const String imagesPath = 'assets/images/';
  
  // Icons
  static const String iconsPath = 'assets/icons/';
  static const String appIcon = '${iconsPath}app_icon.png';
  
  // Logos
  static const String logosPath = 'assets/logos/';
  
  // Helper methods
  static String getImage(String name) => '$imagesPath$name';
  static String getIcon(String name) => '$iconsPath$name';
  static String getLogo(String name) => '$logosPath$name';
}
