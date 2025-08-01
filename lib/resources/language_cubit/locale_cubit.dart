import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Optional

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static String currentLanguage = 'en'; // default

  LocaleCubit() : super(const LocaleState(locale: Locale('en'))) {
    _loadLocale();
  }

  // Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    currentLanguage = languageCode; // 👈 Save it statically
    emit(LocaleState(locale: Locale(languageCode)));
  }

  // Change the locale and save it
  Future<void> changeLocale(Locale locale) async {
    currentLanguage = locale.languageCode; // 👈 Save it statically
    emit(LocaleState(locale: locale));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }
}

