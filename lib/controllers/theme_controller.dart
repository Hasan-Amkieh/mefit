
import 'package:flutter/material.dart';

import '../main.dart';

enum ThemeType {
  dark, light
}

class ThemeController {

  static const primaryFontFamily = 'Outfit';
  static const secondaryFontFamily = 'Readex Pro';

  static getPrimaryColor() {
    if (Main.isDarkMode) {
        return const Color(0xFF4B39EF);
    }
    return const Color(0xFF4B39EF);
  }

  static getSecondaryColor() {
    if (Main.isDarkMode) {
        return const Color(0xFF39d2c0);
    } else {
      return const Color(0xFF39D2C0);
    }
  }

  static getTertiaryColor() {
    if (Main.isDarkMode) {
        return const Color(0xFFee8b60);
    }
    return const Color(0xFFee8b60);
  }

  static getAlternateColor() {
    if (Main.isDarkMode) {
        return const Color(0xFF262d34);
    }
    return const Color(0xFFe0e3e7);
  }

  static getPrimaryTextColor() {
    if (Main.isDarkMode) {
        return const Color(0xFFffffff);
    }
    return const Color(0xFF14181b);
  }

  static getSecondaryTextColor() {
    if (Main.isDarkMode) {
        return const Color(0xFF95a1ac);
    }
    return const Color(0xFF57636c);
  }

  static getPrimaryBackgroundColor() {
    if (Main.isDarkMode) {
        return const Color(0xFF1d2428);
    }
    return const Color(0xFFf1f4f8);
  }

  static getSecondaryBackgroundColor() {
    if (Main.isDarkMode) {
        return const Color(0xFF14181b);
    }
    return const Color(0xFFffffff);
  }

  static getAccent1Color() {
    if (Main.isDarkMode) {
        return const Color(0x4c4b39ef);
    }
    return const Color(0x4c4b39ef);
  }

  static getAccent2Color() {
    if (Main.isDarkMode) {
        return const Color(0x4d39d2c0);
    }
    return const Color(0x4d39d2c0);

  }

  static getAccent3Color() {
    if (Main.isDarkMode) {
        return const Color(0x4dee8b60);
    }
    return const Color(0x4dee8b60);
  }

  static getAccent4Color() {
    if (Main.isDarkMode) {
        return const Color(0xb2262d34);
    }
    return const Color(0xccffffff);
  }

  static getSuccessColor() {
    if (Main.isDarkMode) {
        return const Color(0xff249689);
    }
    return const Color(0xff249689);
  }

  static getErrorColor() {
    if (Main.isDarkMode) {
        return const Color(0xffff5963);
    }
    return const Color(0xffff5963);
  }

  static getWarningColor() {
    if (Main.isDarkMode) {
        return const Color(0xfff9cf58);
    }
    return const Color(0xfff9cf58);
  }

  static getInfoColor() {
    if (Main.isDarkMode) {
        return const Color(0xffffffff);
    }
    return const Color(0xffffffff);
  }

  static TextStyle getDisplayLargeFont() {
    return TextStyle(fontSize: 64, fontWeight: FontWeight.normal, color: ThemeController.getPrimaryTextColor(), fontFamily: primaryFontFamily);
  }

  static TextStyle getDisplayMediumFont() {
    return TextStyle(fontSize: 44, fontWeight: FontWeight.normal, color: ThemeController.getPrimaryTextColor(), fontFamily: primaryFontFamily);
  }

  static TextStyle getDisplaySmallFont() {
    return TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: ThemeController.getPrimaryTextColor(), fontFamily: primaryFontFamily);
  }

  static TextStyle getHeadlineLargeFont() {
    return TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: ThemeController.getPrimaryTextColor(), fontFamily: primaryFontFamily);
  }

  static TextStyle getHeadlineMediumFont() {
    return TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: ThemeController.getPrimaryTextColor(), fontFamily: primaryFontFamily);
  }

  static TextStyle getHeadlineSmallFont() {
    return TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: ThemeController.getPrimaryTextColor(), fontFamily: primaryFontFamily);
  }

  static TextStyle getTitleLargeFont() {
    return TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: ThemeController.getPrimaryTextColor(), fontFamily: primaryFontFamily);
  }

  static TextStyle getTitleMediumFont() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: ThemeController.getInfoColor(), fontFamily: secondaryFontFamily);
  }

  static TextStyle getTitleSmallFont() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ThemeController.getInfoColor(), fontFamily: secondaryFontFamily);
  }

  static TextStyle getLabelLargeFont() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: ThemeController.getSecondaryTextColor(), fontFamily: secondaryFontFamily);
  }

  static TextStyle getLabelMediumFont() {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: ThemeController.getSecondaryTextColor(), fontFamily: secondaryFontFamily);
  }

  static TextStyle getLabelSmallFont() {
    return TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: ThemeController.getSecondaryTextColor(), fontFamily: secondaryFontFamily);
  }

  static TextStyle getBodyLargeFont() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: ThemeController.getPrimaryTextColor(), fontFamily: secondaryFontFamily);
  }

  static TextStyle getBodyMediumFont() {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: ThemeController.getPrimaryTextColor(), fontFamily: secondaryFontFamily);
  }

  static TextStyle getBodySmallFont() {
    return TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: ThemeController.getPrimaryTextColor(), fontFamily: secondaryFontFamily);
  }

}
