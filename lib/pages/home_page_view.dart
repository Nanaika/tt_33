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

import '../storages/models/mood.dart';
import '../storages/models/trigger.dart';
import '../ui_kit/colors.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _selectedMoodType = -1;

  void setSelectedMoodType(int index) {
    setState(() {
      _selectedMoodType = index;
    });
  }

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
                  BlocSelector<MoodsBloc, MoodsState, Mood?>(
                    selector: (MoodsState state) {
                      return state.todayMood;
                    },
                    builder: (context, todayMood) {
                      return MoodsTileTable(
                        selectedItem: _selectedMoodType,
                        onHappyTap: () {
                          setSelectedMoodType(0);
                        },
                        onSadTap: () {
                          setSelectedMoodType(1);
                        },
                        onAngryTap: () {
                          setSelectedMoodType(2);
                        },
                        onAnxietyTap: () {
                          setSelectedMoodType(3);
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AppElevatedButton(
                    buttonText: 'Go next',
                    height: 50,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.createMood, arguments: _selectedMoodType);
                    },
                    isActive: _selectedMoodType != -1,
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
                                children: List.generate(state.length + state.length - 1, (index) {
                                  return index % 2 == 0
                                      ? Container(
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
                                        )
                                      : SizedBox(
                                          height: 4,
                                        );
                                }),
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

void saveMood(BuildContext context, MoodType type, List<String> reasons) {
  final mood =
      Mood(date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), type: type, reasons: reasons);
  context.read<MoodsBloc>().addMood(mood);
}

class MoodsTileTable extends StatelessWidget {
  const MoodsTileTable({
    super.key,
    this.onHappyTap,
    this.onSadTap,
    this.onAngryTap,
    this.onAnxietyTap,
    required this.selectedItem,
  });

  final int selectedItem;
  final void Function()? onHappyTap;
  final void Function()? onSadTap;
  final void Function()? onAngryTap;
  final void Function()? onAnxietyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: MoodTile(
              isActive: selectedItem == 0,
              assetPath: AppIcons.happy,
              text: 'Happy',
              color: AppColors.yellow,
              onTap: onHappyTap,
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: MoodTile(
              isActive: selectedItem == 1,
              assetPath: AppIcons.sad,
              text: 'Sad',
              color: AppColors.purple,
              onTap: onSadTap,
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
              isActive: selectedItem == 2,
              assetPath: AppIcons.angry,
              text: 'Angry',
              color: AppColors.red,
              onTap: onAngryTap,
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: MoodTile(
              isActive: selectedItem == 3,
              assetPath: AppIcons.anxiety,
              text: 'Anxiety',
              color: AppColors.green,
              onTap: onAnxietyTap,
            )),
          ],
        ),
      ],
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
    this.onTap,
  });

  final String assetPath;
  final String text;
  final Color color;
  final bool isActive;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

class WeekDayTile extends StatelessWidget {
  const WeekDayTile({
    super.key,
    required this.date,
    this.mood,
  });

  final Mood? mood;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String iconPath = '';
    if (mood != null) {
      iconPath = switch (mood!.type) {
        MoodType.happy => AppIcons.happy,
        MoodType.sad => AppIcons.sad,
        MoodType.angry => AppIcons.angry,
        MoodType.anxiety => AppIcons.anxiety,
      };
    }
    return Container(
      width: (MediaQuery.of(context).size.width - 26 - 48) / 7,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: mood != null
            ? switch (mood!.type) {
                MoodType.happy => AppColors.yellow,
                MoodType.sad => AppColors.purple,
                MoodType.angry => AppColors.red,
                MoodType.anxiety => AppColors.green,
              }
            : Colors.transparent,
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
          if (mood != null)
            SizedBox(
              height: 4,
            ),
          if (mood != null)
            SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
            )
        ],
      ),
    );
  }
}

bool checkDates(DateTime first, DateTime second) {
  return first.year == second.year && first.month == second.month && first.day == second.day;
}
