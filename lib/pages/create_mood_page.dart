import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tt33/bloc/moods_bloc.dart';
import 'package:tt33/storages/models/mood.dart';
import 'package:tt33/storages/models/trigger.dart';
import 'package:tt33/ui_kit/colors.dart';
import 'package:tt33/ui_kit/text_styles.dart';
import 'package:tt33/ui_kit/widgets/app_elevated_button.dart';
import 'package:tt33/ui_kit/widgets/app_text_form_field.dart';
import 'package:tt33/utils/assets_paths.dart';
import 'package:tt33/utils/utils.dart';

import '../bloc/moods_state.dart';

class CreateMoodPage extends StatefulWidget {
  const CreateMoodPage({super.key});

  @override
  State<CreateMoodPage> createState() => _CreateMoodPageState();
}

class _CreateMoodPageState extends State<CreateMoodPage> {
  final listNameController = TextEditingController();
  final nameController = TextEditingController();
  final commentController = TextEditingController();
  final List<String> triggerList = [];

  @override
  Widget build(BuildContext context) {
    final int index = ModalRoute.of(context)!.settings.arguments as int;
    final now = DateTime.now();
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
              Stack(
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
                    SelectMoodRow(index: index),
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
                              controller: nameController,
                              hint: 'Start typing reasons why your mood is so...',
                              formatters: [LengthLimitingTextInputFormatter(10)],
                              onChanged: (text) {},
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          AddSmallButton(
                            onTap: () {
                              setState(() {
                                if (nameController.text != '') {
                                  triggerList.add(nameController.text);
                                }
                                nameController.clear();
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
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runSpacing: 4,
                          spacing: 4,
                          children: triggerList.map((e) => Chip(text: e)).toList(),
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
                      onChanged: (text) {},
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
                  //TODO
                  if (listNameController.text.isEmpty || listNameController.text == '') {
                    print('TEST-------------------------');
                    return;
                  }
                  if (triggerList.isEmpty) {
                    return;
                  }
                  final name = listNameController.text;
                  final comment = commentController.text;
                  final triggers = triggerList;
                  final trigger = Trigger(name: name, triggers: triggers, comment: comment);
                  await context.read<MoodsBloc>().addTrigger(trigger);
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

class SelectMoodRow extends StatelessWidget {
  const SelectMoodRow({
    super.key,
    required this.index,
  });

  final int index;

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
        GestureDetector(
          onTap: () {},
          onTapDown: (details) {
            showMenu(
                elevation: 0,
                color: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                context: context,
                position: RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy,
                    details.globalPosition.dx, details.globalPosition.dy),
                items: [
                  PopupMenuItem(
                      child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.moodsIcons[0]),
                      Text('111'),
                    ],
                  )),
                  PopupMenuItem(child: Text('222')),
                ]);
          },
          child: Container(
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
                Icon(
                  CupertinoIcons.chevron_down,
                  size: 16,
                )
              ],
            ),
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

class Chip extends StatelessWidget {
  const Chip({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppStyles.bodySmall,
          ),
          SizedBox(
            width: 4,
          ),
          Icon(
            Icons.close,
            size: 14,
            color: AppColors.black,
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
