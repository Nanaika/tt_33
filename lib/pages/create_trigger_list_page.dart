import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt33/bloc/moods_bloc.dart';
import 'package:tt33/storages/models/trigger.dart';
import 'package:tt33/ui_kit/colors.dart';
import 'package:tt33/ui_kit/text_styles.dart';
import 'package:tt33/ui_kit/widgets/app_elevated_button.dart';
import 'package:tt33/ui_kit/widgets/app_text_form_field.dart';

class CreateTriggerListPage extends StatefulWidget {
  const CreateTriggerListPage({super.key});

  @override
  State<CreateTriggerListPage> createState() => _CreateTriggerListPageState();
}

class _CreateTriggerListPageState extends State<CreateTriggerListPage> {
  final listNameController = TextEditingController();
  final nameController = TextEditingController();
  final commentController = TextEditingController();
  final List<String> triggerList = [];

  @override
  Widget build(BuildContext context) {
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
                    'My trigger list',
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
                    Row(
                      children: [
                        Text(
                          'Name of the list',
                          style: AppStyles.displaySmall.copyWith(color: AppColors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    AppTextFormField(hint: 'Trigger list name', onChanged: (text) {}, controller: listNameController,),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Write down the triggers:',
                          style: AppStyles.displaySmall.copyWith(color: AppColors.white),
                        )
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
                              hint: 'Trigger name',
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
