import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:tt33/bloc/moods_bloc.dart';
import 'package:tt33/storages/models/mood.dart';
import 'package:tt33/storages/models/trigger.dart';
import 'package:tt33/ui_kit/colors.dart';
import 'package:tt33/ui_kit/text_styles.dart';
import 'package:tt33/ui_kit/widgets/app_elevated_button.dart';
import 'package:tt33/ui_kit/widgets/app_text_form_field.dart';
import 'package:tt33/utils/assets_paths.dart';
import 'package:tt33/utils/utils.dart';

import '../bloc/mood_bloc.dart';
import '../bloc/moods_state.dart';

class CreateMoodPageView extends StatefulWidget {
  const CreateMoodPageView({super.key});

  @override
  State<CreateMoodPageView> createState() => _CreateMoodPageViewState();
}

class _CreateMoodPageViewState extends State<CreateMoodPageView> {
  final reasonNameController = TextEditingController();
  final commentController = TextEditingController();
  late final Mood? initMood;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Object? args = ModalRoute.of(context)!.settings.arguments;
      if (args is int) {
        context.read<MoodBloc>().updateType(args);
        isEdit = false;
      }
      if (args is Mood) {
        print('MOOD FROM init --------------  ${args.id}');
        initMood = args;
        context.read<MoodBloc>().setMood(args);
        commentController.text = args.comment;
        isEdit = true;
      }
    });
  }

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    final now = DateUtils.dateOnly(DateTime.now());
    final formattedDate = DateFormat('EEEE, d MMMM').format(now);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 20,
              ),
              AppBar(formattedDate: formattedDate),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    BlocSelector<MoodBloc, Mood, MoodType>(
                      selector: (state) {
                        return state.type;
                      },
                      builder: (BuildContext context, MoodType state) {
                        print('SELECTOR BUILD--------------------------');
                        return SelectMoodRow(
                          index: state.index,
                          onIndexChanged: (index) {
                            context.read<MoodBloc>().updateType(index);
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Because:',
                          style: AppStyles.displaySmall.copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: reasonNameController,
                              hint: 'Start typing reasons why your mood is so...',
                              formatters: [LengthLimitingTextInputFormatter(20)],
                              onChanged: (text) {},
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          AddSmallButton(
                            onTap: () {
                              setState(() {
                                if (reasonNameController.text != '') {
                                  // reasonList.add(nameController.text);
                                  context.read<MoodBloc>().updateReasons(reasonNameController.text);
                                }
                                reasonNameController.clear();
                              });
                            },
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: BlocSelector<MoodBloc, Mood, List<String>>(
                          selector: (state) {
                            return state.reasons;
                          },
                          builder: (context, state) {
                            return Wrap(
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runSpacing: 4,
                              spacing: 4,
                              children: state.map((e) => CustomChip(text: e, onRemove: () {
                                context.read<MoodBloc>().removeReasons(e);
                              },)).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'My comment:',
                          style: AppStyles.displaySmall.copyWith(color: AppColors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    AppTextFormField(
                      controller: commentController,
                      hint: 'Start typing...',
                      onChanged: (text) {
                        context.read<MoodBloc>().updateComment(text);
                      },
                      minLines: 3,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
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
                        Text(
                          'Choose trigger list:',
                          style: AppStyles.displaySmall.copyWith(color: AppColors.white),
                        ),
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
                                Expanded(
                                  child: Text(
                                    'You don`t have any trigger list. You can create it on the main page',
                                    style: AppStyles.bodySmall,
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
              ),
              Spacer(),
              AppElevatedButton(
                buttonText: 'Save',
                height: 50,
                onTap: () async {
                  final mood = context.read<MoodBloc>().state;
                  if (mood.reasons.isEmpty) {
                    return;
                  }
                  if (isEdit) {
                    await context.read<MoodsBloc>().updateMood(mood, initMood!.id);
                  } else {
                    await context.read<MoodsBloc>().addMood(mood);
                  }

                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    super.key,
    required this.formattedDate,
  });

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                width: 24,
                height: 24,
                color: Colors.transparent,
                child: Icon(
                  CupertinoIcons.chevron_back,
                  color: AppColors.black,
                ))),
        Center(
            child: Text(
          formattedDate,
          style: AppStyles.displayMedium,
        )),
      ],
    );
  }
}

class SelectMoodRow extends StatelessWidget {
  const SelectMoodRow({
    super.key,
    required this.index,
    required this.onIndexChanged,
  });

  final int index;
  final void Function(int index) onIndexChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Today I have',
          style: AppStyles.displaySmall.copyWith(color: AppColors.white),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.moodsColors[index],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                AppIcons.moodsIcons[index],
                width: 16,
                height: 16,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                MoodType.values[index].name.capitalizeFirst(),
                style: AppStyles.displaySmall,
              ),
              SizedBox(
                width: 4,
              ),
              PullDownButton(
                menuOffset: 0,
                itemBuilder: (context) => List.generate(MoodType.values.length, (index) {
                  return PullDownMenuItem(
                    itemTheme: PullDownMenuItemTheme(textStyle: AppStyles.displaySmall),
                    onTap: () {
                      onIndexChanged(index);
                    },
                    title: MoodType.values[index].name.capitalizeFirst(),
                    iconWidget: SvgPicture.asset(AppIcons.moodsIcons[index]),
                  );
                }),
                buttonBuilder: (context, showMenu) => GestureDetector(
                  onTap: showMenu,
                  child: Container(
                      color: Colors.transparent,
                      width: 22,
                      height: 22,
                      child: Icon(
                        CupertinoIcons.chevron_down,
                        size: 16,
                        color: AppColors.black,
                      )),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          'mood',
          style: AppStyles.displaySmall.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.text,
    this.backColor = AppColors.white,
    this.textColor = AppColors.black,
    this.iconColor = AppColors.black, this.onRemove,
  });

  final Color backColor;
  final String text;
  final Color textColor;
  final Color iconColor;
  final void Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppStyles.bodySmall.copyWith(color: textColor),
          ),
          SizedBox(
            width: 4,
          ),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              color: Colors.transparent,
              child: Icon(
                Icons.close,
                size: 14,
                color: iconColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AddSmallButton extends StatelessWidget {
  const AddSmallButton({
    super.key,
    this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Icon(
          Icons.add,
          size: 20,
          color: AppColors.white,
        ),
      ),
    );
  }
}
