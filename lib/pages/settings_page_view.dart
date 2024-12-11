import 'package:flutter/material.dart';
import 'package:tt33/navigation/routes.dart';
import 'package:tt33/ui_kit/text_styles.dart';

import '../ui_kit/colors.dart';

class SettingsPageView extends StatelessWidget {
  const SettingsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20 + MediaQuery.of(context).padding.top,
                ),
                Row(
                  children: [
                    Text(
                      'Settings',
                      style: AppStyles.displayLarge,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
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
                            'Feedback',
                            style: AppStyles.displaySmall.copyWith(color: AppColors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      SettingsButton(
                        text: 'Contact us',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SettingsButton(
                        text: 'Send message',
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Text(
                            'About app',
                            style: AppStyles.displaySmall.copyWith(color: AppColors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      SettingsButton(
                        text: 'Share this app',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SettingsButton(
                        text: 'About us',
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.aboutUs, arguments: false);
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SettingsButton(
                        text: 'Rate us',
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'version 1.0.0',
                            style: AppStyles.bodySmall,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRoutes.aboutUs, arguments: true);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Text(
                                'Terms & Privacy',
                                style: AppStyles.bodySmall,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 100 + MediaQuery.of(context).padding.bottom,),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.text, this.onTap,
  });

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: AppStyles.bodyMedium,
            )
          ],
        ),
      ),
    );
  }
}
