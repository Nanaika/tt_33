import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:tt33/bloc/moods_bloc.dart';
import 'package:tt33/pages/about_us_page.dart';
import 'package:tt33/pages/create_mood_page.dart';
import 'package:tt33/pages/create_trigger_list_page.dart';
import 'package:tt33/pages/exercise_page.dart';
import 'package:tt33/pages/home_page.dart';
import 'package:tt33/pages/onboarding_page.dart';
import 'package:tt33/pages/splash_page.dart';
import 'package:tt33/remote_config.dart';
import 'package:tt33/storages/isar.dart';
import 'package:tt33/storages/shared_preferences.dart';
import 'package:tt33/ui_kit/colors.dart';
import 'package:tt33/ui_kit/text_styles.dart';

import 'navigation/routes.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color.fromARGB(1, 1, 1, 1),
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark));

  await RemoteConfigService.init();
  await AppSharedPreferences.init();
  await AppIsarDatabase.init();

  final isFirstRun = AppSharedPreferences.getIsFirstRun() ?? true;
  if (isFirstRun) await AppSharedPreferences.setNotFirstRun();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    AppInfo(
      data: await AppInfoData.get(),
      child: MyApp(isFirstRun: isFirstRun),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstRun});

  final bool isFirstRun;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => MoodsBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          extensions: [
            PullDownButtonTheme(
                routeTheme: PullDownMenuRouteTheme(
                  backgroundColor: AppColors.white,
                ),
                itemTheme: PullDownMenuItemTheme(
                  destructiveColor: Colors.red,
                ),
                dividerTheme: PullDownMenuDividerTheme(
                  dividerColor: AppColors.black,
                ),
                titleTheme: PullDownMenuTitleTheme(
                  style: AppStyles.displaySmall,
                )),
          ],
        ),
        onUnknownRoute: (settings) => CupertinoPageRoute(
          builder: (context) => const HomePage(),
        ),
        onGenerateRoute: (settings) => switch (settings.name) {
          AppRoutes.onBoarding => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const OnBoardingPage(),
            ),
          AppRoutes.home => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const HomePage(),
            ),
          AppRoutes.createTriggerList => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const CreateTriggerListPage(),
            ),
          AppRoutes.createMood => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const CreateMoodPage(),
            ),
          AppRoutes.aboutUs => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const AboutUsPage(),
            ),
          AppRoutes.exercisePage => CupertinoPageRoute(
            settings: settings,
            builder: (context) => const ExercisePage(),
          ),
          _ => null,
        },
        home: SplashPage(
          isFirstRun: isFirstRun,
        ),
      ),
    );
  }
}
