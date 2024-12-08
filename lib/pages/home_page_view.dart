import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tt33/bloc/moods_bloc.dart';
import 'package:tt33/bloc/moods_state.dart';
import 'package:tt33/navigation/routes.dart';
import 'package:tt33/ui_kit/text_styles.dart';
import 'package:tt33/ui_kit/widgets/app_elevated_button.dart';
import 'package:tt33/utils/assets_paths.dart';

import '../storages/models/trigger.dart';
import '../ui_kit/colors.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    List<DateTime> dates = List.generate(7, (index) {
      if (index < 3) {
        return now.subtract(Duration(days: 3 - index)); // 3 дня назад
      } else if (index == 3) {
        return now; // Сегодня
      } else {
        return now.add(Duration(days: index - 3)); // 3 дня вперед
      }
    });
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0 + MediaQuery.of(context).padding.top),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(7, (index) {
                    return WeekDayTile(date: dates[index]);
                  }),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Today, I am',
                        style: AppStyles.displayMedium,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: MoodTile(
                            assetPath: AppIcons.happy,
                            text: 'Happy',
                            color: AppColors.yellow,
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: MoodTile(
                            assetPath: AppIcons.sad,
                            text: 'Sad',
                            color: AppColors.purple,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: MoodTile(
                            assetPath: AppIcons.angry,
                            text: 'Angry',
                            color: AppColors.red,
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: MoodTile(
                            assetPath: AppIcons.anxiety,
                            text: 'Anxiety',
                            color: AppColors.green,
                          )),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AppElevatedButton(
                    buttonText: 'Go next',
                    height: 50,
                    onTap: () {},
                    isActive: false,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My trigger list',
                              style: AppStyles.displayMedium.copyWith(color: AppColors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(AppRoutes.createTriggerList);
                              },
                              child: Icon(
                                Icons.add,
                                color: AppColors.white,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        BlocSelector<MoodsBloc, MoodsState, List<Trigger>>(
                          selector: (MoodsState state) {
                            return state.triggers;
                          },
                          builder: (context, state) {
                            if (state.isEmpty) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'You don`t have any trigger list.',
                                      style: AppStyles.bodySmall,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(AppRoutes.createTriggerList);
                                      },
                                      child: Text(
                                        ' Let`s create it!',
                                        style: AppStyles.bodySmall.copyWith(color: AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                children: List.generate(
                                    state.length + state.length - 1,
                                    (index) {
                                      return index % 2 == 0 ?
                                     Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              state[index ~/ 2].name,
                                              style: AppStyles.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ) : SizedBox(height: 4,);
                                    } ),
                              );
                            }
                          },
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 100 + MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }
}

class MoodTile extends StatelessWidget {
  const MoodTile({
    super.key,
    required this.assetPath,
    required this.text,
    required this.color,
    this.isActive = false,
  });

  final String assetPath;
  final String text;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: isActive ? color : color.withOpacity(0.65),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            colorFilter: isActive
                ? ColorFilter.mode(AppColors.black, BlendMode.srcIn)
                : ColorFilter.mode(AppColors.black.withOpacity(0.65), BlendMode.srcIn),
          ),
          Text(
            text,
            style: isActive
                ? AppStyles.displayLarge
                : AppStyles.displayLarge.copyWith(
                    color: AppColors.black.withOpacity(0.65),
                  ),
          )
        ],
      ),
    );
  }
}

class WeekDayTile extends StatelessWidget {
  const WeekDayTile({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      width: (MediaQuery.of(context).size.width - 26 - 48) / 7,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: checkDates(date, now) ? AppColors.black : Colors.transparent),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            date.day.toString(),
            style: AppStyles.displaySmall,
          ),
          Text(
            DateFormat.E().format(date).toUpperCase(),
            style: AppStyles.displaySmall,
          ),
        ],
      ),
    );
  }
}

bool checkDates(DateTime first, DateTime second) {
  return first.year == second.year && first.month == second.month && first.day == second.day;
}
