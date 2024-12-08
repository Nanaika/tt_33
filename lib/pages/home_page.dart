import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tt33/bloc/moods_bloc.dart';
import 'package:tt33/bloc/moods_state.dart';
import 'package:tt33/pages/home_page_view.dart';
import 'package:tt33/pages/practice_page_view.dart';
import 'package:tt33/pages/settings_page_view.dart';
import 'package:tt33/pages/statistic_page_view.dart';
import 'package:tt33/ui_kit/text_styles.dart';
import 'package:tt33/utils/assets_paths.dart';
import 'package:tt33/utils/constants.dart';

import '../ui_kit/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          BlocSelector<MoodsBloc, MoodsState, int>(
            selector: (state) { return state.page; },
            builder: (context, state) { return Positioned.fill(child: IndexedStack(
              index: state,
              children: [
                HomePageView(),
                StatisticPageView(),
                PracticePageView(),
                SettingsPageView(),
              ],
            )); },

          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                padding:
                    EdgeInsets.only(left: 44, right: 44, top: 10, bottom: 12 + MediaQuery.of(context).padding.bottom),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: BlocSelector<MoodsBloc, MoodsState, int>(
                  selector: (state) {
                    return state.page;
                  },
                  builder: (context, state) {
                    final bloc = context.read<MoodsBloc>();
                    final currentPage = bloc.state.page;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainBottomBarItem(
                          isActive: currentPage == 0,
                          assetPath: AppIcons.home,
                          textStyle: AppStyles.displaySmall,
                          text: 'Home',
                          onTap: () {
                            bloc.updatePage(0);
                          },
                        ),
                        MainBottomBarItem(
                          isActive: currentPage == 1,
                          assetPath: AppIcons.statistic,
                          textStyle: AppStyles.displaySmall,
                          text: 'Statistic',
                          onTap: () {
                            bloc.updatePage(1);
                          },
                        ),
                        MainBottomBarItem(
                          isActive: currentPage == 2,
                          assetPath: AppIcons.book,
                          textStyle: AppStyles.displaySmall,
                          text: 'Practice',
                          onTap: () {
                            bloc.updatePage(2);
                          },
                        ),
                        MainBottomBarItem(
                          isActive: currentPage == 3,
                          assetPath: AppIcons.settings,
                          textStyle: AppStyles.displaySmall,
                          text: 'Settings',
                          onTap: () {
                            bloc.updatePage(3);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}

class MainBottomBarItem extends StatelessWidget {
  const MainBottomBarItem({
    super.key,
    required this.assetPath,
    required this.textStyle,
    required this.text,
    this.isActive = false,
    this.onTap,
  });

  final String assetPath;
  final TextStyle textStyle;
  final String text;
  final bool isActive;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: isActive ? 0 : 1,
              duration: AppConstants.duration200,
              child: Column(
                children: [
                  SvgPicture.asset(
                    assetPath,
                    colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    text,
                    style: textStyle.copyWith(color: AppColors.white),
                  )
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isActive ? 1 : 0,
              duration: AppConstants.duration200,
              child: Column(
                children: [
                  SvgPicture.asset(
                    assetPath,
                    colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    text,
                    style: textStyle.copyWith(color: AppColors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
