import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tt33/bloc/moods_bloc.dart';
import 'package:tt33/bloc/moods_state.dart';
import 'package:tt33/storages/models/mood.dart';
import 'package:tt33/utils/assets_paths.dart';
import 'package:tt33/utils/constants.dart';

import '../ui_kit/colors.dart';
import '../ui_kit/text_styles.dart';

class StatisticPageView extends StatefulWidget {
  const StatisticPageView({super.key});

  @override
  State<StatisticPageView> createState() => _StatisticPageViewState();
}

class _StatisticPageViewState extends State<StatisticPageView> {
  int dateRange = 0;

  late DateTime weekStart;

  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateUtils.dateOnly(DateTime.now());
    weekStart = now.subtract(Duration(days: now.weekday - 1));
    // formattedWeekStart = DateFormat('dd MMM yyyy').format(start);
    // formattedWeekEnd = DateFormat('dd MMM yyyy').format(end);
    selectedMonth = now;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20 + MediaQuery.of(context).padding.top,
              ),
              Row(
                children: [
                  Text(
                    'Statistics',
                    style: AppStyles.displayLarge,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (dateRange == 1)
                MonthSelector(
                  date: selectedMonth,
                  onChanged: (date) {
                    setState(() {
                      selectedMonth = date;
                    });
                  },
                ),
              if (dateRange == 0)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          weekStart = weekStart.subtract(Duration(days: 7));
                        });
                      },
                      child: Container(
                          color: Colors.transparent,
                          child: Icon(
                            CupertinoIcons.chevron_back,
                            size: 18,
                          )),
                    ),
                    Expanded(child: Builder(builder: (context) {
                      final formattedWeekStart = DateFormat('dd MMM yyyy').format(weekStart);
                      final formattedWeekEnd =
                          DateFormat('dd MMM yyyy').format(weekStart.add(Duration(days: weekStart.weekday + 5)));
                      return Text(
                        '${formattedWeekStart} - ${formattedWeekEnd}',
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyMedium,
                      );
                    })),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          weekStart = weekStart.add(Duration(days: 7));
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          CupertinoIcons.chevron_forward,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
              SizedBox(
                height: 10,
              ),
              WeeklyMonthlyButtons(
                onChanged: (index) {
                  setState(() {
                    dateRange = index;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              StatisticBlock(
                isWeekly: dateRange == 0,
                month: selectedMonth,
                weekStart: weekStart,
              ),
              SizedBox(
                height: 100 + MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatisticBlock extends StatelessWidget {
  const StatisticBlock({
    super.key,
    required this.month,
    required this.weekStart,
    required this.isWeekly,
  });

  final DateTime month;
  final DateTime weekStart;
  final bool isWeekly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'My emotion stats',
                  style: AppStyles.displaySmall.copyWith(color: AppColors.white),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            BlocSelector<MoodsBloc, MoodsState, List<Mood>>(
              selector: (state) {
                return state.moods;
              },
              builder: (context, state) {
                return MoodsChart(
                  month: month,
                  weekStart: weekStart,
                  moods: state,
                  isWeekly: isWeekly,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MoodsChart extends StatelessWidget {
  const MoodsChart({
    super.key,
    required this.moods,
    required this.month,
    required this.weekStart,
    this.isWeekly = true,
  });

  final bool isWeekly;
  final DateTime month;
  final DateTime weekStart;
  final List<Mood> moods;

  @override
  Widget build(BuildContext context) {
    List<Mood> countedMoods;

    List<int> typeCounters = [0, 0, 0, 0];

    if (isWeekly) {
      final weekEnd = weekStart.add(Duration(days: 6));

      countedMoods = moods
          .where((mood) =>
              mood.date.isAfter(weekStart.subtract(Duration(days: 1))) &&
              mood.date.isBefore(weekEnd.add(Duration(days: 1))))
          .toList();

      typeCounters[0] = countedMoods.where((mood) => mood.type == MoodType.happy).length;
      typeCounters[1] = countedMoods.where((mood) => mood.type == MoodType.sad).length;
      typeCounters[2] = countedMoods.where((mood) => mood.type == MoodType.angry).length;
      typeCounters[3] = countedMoods.where((mood) => mood.type == MoodType.anxiety).length;
    } else {
      countedMoods = moods.where((mood) => mood.date.month == month.month && mood.date.year == month.year).toList();

      typeCounters[0] = countedMoods.where((mood) => mood.type == MoodType.happy).length;
      typeCounters[1] = countedMoods.where((mood) => mood.type == MoodType.sad).length;
      typeCounters[2] = countedMoods.where((mood) => mood.type == MoodType.angry).length;
      typeCounters[3] = countedMoods.where((mood) => mood.type == MoodType.anxiety).length;
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.5,
              child: PieChart(
                PieChartData(
                  sections: List.generate(MoodType.values.length, (index) {
                    return PieChartSectionData(
                        color: AppColors.moodsColors[index],
                        value: typeCounters[index].toDouble(),
                        showTitle: false,
                        radius: 30);
                  }),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    countedMoods.length.toString(),
                    style: AppStyles.displayMedium.copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'marked\nemotions',
                    style: AppStyles.bodyMedium.copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: List.generate(MoodType.values.length + MoodType.values.length - 1, (index) {
            if (index % 2 != 0) {
              return SizedBox(
                height: 8,
              );
            }
            return Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.moodsIcons[index ~/ 2],
                    colorFilter: ColorFilter.mode(AppColors.moodsColors[index ~/ 2], BlendMode.srcIn),
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${typeCounters[index ~/ 2]} days',
                        style: AppStyles.bodyMedium.copyWith(color: AppColors.moodsColors[index ~/ 2]),
                      ),
                      Text(
                        AppConstants.moodTypeFullName[index ~/ 2],
                        style: AppStyles.bodySmall,
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class WeeklyMonthlyButtons extends StatefulWidget {
  const WeeklyMonthlyButtons({
    super.key,
    required this.onChanged,
  });

  final void Function(int index) onChanged;

  @override
  State<WeeklyMonthlyButtons> createState() => _WeeklyMonthlyButtonsState();
}

class _WeeklyMonthlyButtonsState extends State<WeeklyMonthlyButtons> {
  int active = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                active = 0;
                widget.onChanged(0);
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: active == 0 ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  border: Border.all(color: AppColors.black, width: active == 0 ? 0 : 0.5)),
              child: Text(
                'Weekly',
                style: AppStyles.bodyMedium.copyWith(color: active == 0 ? AppColors.white : AppColors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                active = 1;
                widget.onChanged(1);
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: active == 1 ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                  border: Border.all(color: AppColors.black, width: active == 1 ? 0 : 0.5)),
              child: Text(
                'Monthly',
                style: AppStyles.bodyMedium.copyWith(color: active == 1 ? AppColors.white : AppColors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.onChanged,
    required this.date,
  });

  final void Function(DateTime date) onChanged;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                scrollable: false,
                backgroundColor: AppColors.white,
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: CupertinoDatePicker(
                    backgroundColor: AppColors.white,
                    initialDateTime: date,
                    mode: CupertinoDatePickerMode.monthYear,
                    onDateTimeChanged: (DateTime value) {
                      onChanged(value);
                    },
                  ),
                ),
              );
            });
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Text(
              DateFormat('MMMM ').format(date),
              style: AppStyles.bodyMedium,
            ),
            Text(
              DateFormat('yyyy').format(date),
              style: AppStyles.bodyMedium,
            ),
            SizedBox(
              width: 8,
            ),
            Icon(
              CupertinoIcons.chevron_down,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
