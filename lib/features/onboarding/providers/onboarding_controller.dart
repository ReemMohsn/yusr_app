import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/features/onboarding/data/models/onboarding_model.dart';
import 'package:yusr/features/onboarding/data/repositories/onboarding_repository.dart'; // تأكد من مطابقة المسار لديك

part 'onboarding_controller.g.dart';

class OnboardingState {
  final int currentIndex;
  final List<OnboardingModel> pages;

  OnboardingState({required this.currentIndex, required this.pages});

  int get totalPages => pages.length;
  bool get isLastPage => currentIndex == totalPages - 1;

  OnboardingState copyWith({
    int? currentIndex,
    List<OnboardingModel>? pages,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      pages: pages ?? this.pages,
    );
  }
}

@riverpod
class OnboardingController extends _$OnboardingController {
  late final PageController pageController;

  @override
  OnboardingState build() {
    pageController = PageController();
    
    ref.onDispose(() {
      pageController.dispose();
    });

    return OnboardingState(
      currentIndex: 0,
      pages: OnboardingRepository().getOnboardingPages(),
    );
  }

  void updateIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void nextPage(BuildContext context) {
    if (state.isLastPage) {
      completeAndNavigate(context);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_onboarding_completed', true);
    
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoute.mainHomeView);
    }
  }
}