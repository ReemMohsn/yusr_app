import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/providers/app_router_provider.dart';
import 'package:yusr/core/common/providers/localization.dart';
import 'package:yusr/core/constants/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/generated/l10n.dart';
import 'core/constants/app_route.dart';

class YusrApp extends ConsumerWidget {
  const YusrApp({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });

  final AppRouter appRouter;
  final String initialRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    final locale = ref.watch(localizationProvider);

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
        // supportedLocales: AppLocalizations.delegate.supportedLocales,
        locale: const Locale('ar'),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: initialRoute,
      ),
    );
  }
}
