import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  
  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textDark,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textDark,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textDark,
  );
  
  // Button
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
  );
  
  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
