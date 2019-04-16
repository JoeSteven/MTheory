import 'package:flutter/material.dart';
import 'package:remove/i18n/translations.dart';

typedef void LocaleChangeCallback(Locale locale);
class LocaleUtil {

  // Support languages list
  final List<String> supportedLanguages = ['en','zh'];
  BuildContext context;

  // Support Locales list
  Iterable<Locale> supportedLocales() => supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  // Callback for manual locale changed
  LocaleChangeCallback onLocaleChanged;

  Locale locale;
  String languageCode;

  static final LocaleUtil _localeUtil = new LocaleUtil._internal();

  factory LocaleUtil() {
    return _localeUtil;
  }

  LocaleUtil._internal();

  /// 获取当前系统语言
  String getLanguageCode() {
    if(languageCode == null) {
      return "en";
    }
    return languageCode;
  }

  String getString(String key) {
    return Translations.of(context).text(key);
  }
}

LocaleUtil localeUtil = new LocaleUtil();