import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tt33/navigation/routes.dart';
import 'package:tt33/ui_kit/colors.dart';
import 'package:tt33/ui_kit/text_styles.dart';
import 'package:tt33/utils/constants.dart';

class PracticePageView extends StatelessWidget {
  const PracticePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20 + MediaQuery.of(context).padding.top,
            ),
            Row(
              children: [
                Text(
                  'Exercises',
                  style: AppStyles.displayLarge,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          'Breathing exercises',
                          style: AppStyles.displaySmall,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: List.generate(
                          AppConstants.breathingExercises.length + AppConstants.breathingExercises.length - 1, (index) {
                        if (index % 2 != 0) {
                          return SizedBox(
                            height: 10,
                          );
                        }
                        return ExerciseBlock(
                          name: AppConstants.breathingExercises[index ~/ 2].$1,
                          steps: AppConstants.breathingExercises[index ~/ 2].$2,
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.exercisePage, arguments: (0, index ~/ 2));
                          },
                        );
                      }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Meditation exercises',
                          style: AppStyles.displaySmall,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: List.generate(
                          AppConstants.meditationExercises.length + AppConstants.meditationExercises.length - 1,
                          (index) {
                        if (index % 2 != 0) {
                          return SizedBox(
                            height: 10,
                          );
                        }
                        return ExerciseBlock(
                          name: AppConstants.meditationExercises[index ~/ 2].$1,
                          steps: AppConstants.meditationExercises[index ~/ 2].$2,
                          isPractice: false,
                          onTap: () {
                            print('INDEX--------------${index}');
                            Navigator.of(context).pushNamed(AppRoutes.exercisePage, arguments: (1, index ~/ 2));
                          },
                        );
                      }),
                    ),
                    SizedBox(
                      height: 100 + MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseBlock extends StatefulWidget {
  const ExerciseBlock({
    super.key,
    required this.name,
    required this.steps,
    this.isPractice = true,
    this.onTap,
  });

  final String name;
  final String steps;
  final bool isPractice;
  final void Function()? onTap;

  @override
  State<ExerciseBlock> createState() => _ExerciseBlockState();
}

class _ExerciseBlockState extends State<ExerciseBlock> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.name,
                  style: AppStyles.displaySmall.copyWith(color: AppColors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  width: 24,
                  height: 24,
                  child: Icon(
                    !isOpen ? CupertinoIcons.chevron_forward : CupertinoIcons.chevron_down,
                    size: 20,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),

          if (isOpen == true)
            Column(
              children: [
                SizedBox(height: 10,),
                Text(
                  widget.steps,
                  style: AppStyles.bodyMedium.copyWith(color: AppColors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      widget.isPractice ? 'Start practice' : 'Start meditation',
                      style: AppStyles.displayMedium.copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
