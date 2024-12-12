import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tt33/ui_kit/widgets/app_elevated_button.dart';
import 'package:tt33/utils/constants.dart';

import '../ui_kit/colors.dart';
import '../ui_kit/text_styles.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final Stopwatch stopwatch = Stopwatch();
  late double totalSeconds;
  late double divideBy;
  late Timer uiUpdateTimer;

  @override
  void initState() {
    super.initState();
    uiUpdateTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (stopwatch.isRunning) {
        setState(() {
          if (stopwatch.elapsed.inSeconds > totalSeconds) {
            stopwatch.stop();
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    uiUpdateTimer.cancel();
    stopwatch.stop();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as (int, int);
    divideBy = args.$1 == 0 ? 60 : 600;
    totalSeconds = args.$1 == 0 ? 60 : 600;
  }

  String getRemainingTime() {
    final elapsed = stopwatch.elapsed.inSeconds;
    final remaining = (totalSeconds - elapsed).clamp(0, totalSeconds);
    final minutes = remaining ~/ 60;
    final seconds = remaining % 60;
    return '$minutes:${seconds.toInt().toString().padLeft(2, '0')}';
  }

  double getProgress() {
    final elapsed = stopwatch.elapsed.inSeconds;
    return ((totalSeconds - elapsed) / divideBy).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as (int, int);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SizedBox(
            height: 20 + MediaQuery.of(context).padding.top,
          ),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 24,
                    height: 24,
                    child: Icon(
                      CupertinoIcons.chevron_back,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Practice',
                  style: AppStyles.displayMedium,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          args.$1 == 0
                              ? AppConstants.breathingExercises[args.$2].$1
                              : AppConstants.meditationExercises[args.$2].$1,
                          style: AppStyles.displayMedium.copyWith(color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height / 3.5,
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            startDegreeOffset: -90,
                            sections: [
                              PieChartSectionData(
                                radius: 30,
                                value: (1 - getProgress()) * 100,
                                color: Colors.transparent,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                radius: 30,
                                value: getProgress() * 100,
                                color: AppColors.white,
                                showTitle: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getRemainingTime(),
                            style: AppStyles.displayLarge.copyWith(color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Text(
                        'Take each step for one minute',
                        style: AppStyles.bodyMedium.copyWith(color: AppColors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                                  args.$1 == 0
                                      ? AppConstants.breathingExercises[args.$2].$2
                                      : AppConstants.meditationExercises[args.$2].$2,
                                  style: AppStyles.bodyMedium.copyWith(color: AppColors.white),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppElevatedButton(
              backgroundColor: stopwatch.isRunning ? AppColors.red : AppColors.primary,
              buttonText: stopwatch.isRunning ? 'Stop' : 'Start',
              onTap: () {
                setState(() {
                  if (stopwatch.isRunning) {
                    stopwatch.stop();
                  } else {
                    stopwatch.start();
                  }
                });
              },
              height: 50,
            ),
          ),
          SizedBox(
            height: 25 + MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }
}