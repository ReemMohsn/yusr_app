import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';

class OnboardingRepository {
  List<OnboardingModel> getOnboardingPages() {
    return [
      // 1. Welcome Screen
      OnboardingModel(
        icon: Icons.mosque_rounded, 
        titleBuilder: (locale) => locale.onboarding_title_1,
        descriptionBuilder: (locale) => locale.onboarding_desc_1,
      ),
      // 2. Smart Guidance & Tracking
      OnboardingModel(
        icon: Icons.explore_rounded, 
        titleBuilder: (locale) => locale.onboarding_title_2,
        descriptionBuilder: (locale) => locale.onboarding_desc_2,
      ),
      // 3. Smart Tawaf Counter
      OnboardingModel(
        icon: Icons.timer_rounded,
        titleBuilder: (locale) => locale.onboarding_title_3,
        descriptionBuilder: (locale) => locale.onboarding_desc_3,
      ),
      // 4. Hajj Guide & Days
      OnboardingModel(
        icon: Icons.calendar_month_rounded, 
        titleBuilder: (locale) => locale.onboarding_title_4,
        descriptionBuilder: (locale) => locale.onboarding_desc_4,
      ),
      // 5. AI Mufti
      OnboardingModel(
        icon: Icons.auto_awesome_rounded, 
        titleBuilder: (locale) => locale.onboarding_title_5,
        descriptionBuilder: (locale) => locale.onboarding_desc_5,
      ),
      // 6. Notifications & Alerts
      OnboardingModel(
        icon: Icons.notifications_rounded, 
        titleBuilder: (locale) => locale.onboarding_title_6,
        descriptionBuilder: (locale) => locale.onboarding_desc_6,
      ),
    ];
  }
}