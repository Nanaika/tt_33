import 'package:flutter/material.dart';
import 'package:tt33/ui_kit/text_styles.dart';
import 'package:tt33/ui_kit/widgets/app_elevated_button.dart';

import '../navigation/routes.dart';
import '../ui_kit/colors.dart';
import '../utils/assets_paths.dart';
import '../utils/constants.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  Future<void> _nextPage() async {
    if (_currentPage == 2) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      setState(() => _currentPage++);
      await _controller.nextPage(
        duration: AppConstants.duration200,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppImages.onBoardingBack,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                PageView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'MOOD',
                            style: AppStyles.displayLarge.copyWith(fontSize: 40),
                          ),
                          Text(
                            'MONITOR',
                            style: AppStyles.displayLarge.copyWith(fontSize: 20, letterSpacing: 5),
                          ),
                          Text(
                            'APP',
                            style: AppStyles.displayLarge.copyWith(fontSize: 64, letterSpacing: 2.5, height: 1),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Monitor your mood and improve your quality of life with MoodMonitor, your personal assistant in managing emotions.',
                              style: AppStyles.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Start controlling your mood and work on improving your emotional state today!',
                              style: AppStyles.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 45 + 42 + MediaQuery.of(context).padding.bottom,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Dot(isActive: _currentPage == 0,),
                        SizedBox(width: 6,),
                        Dot(isActive: _currentPage == 1,),
                        SizedBox(width: 6,),
                        Dot(isActive: _currentPage == 2,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Positioned(
                  bottom: 45 + MediaQuery.of(context).padding.bottom,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 172,
                        child: AppElevatedButton(
                            buttonText: _currentPage != 2 ? 'Next' : 'Get started',
                            backgroundColor: AppColors.background,
                            textColor: AppColors.black,
                            onTap: () {
                              _nextPage();
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({
    super.key, required this.isActive,
  });
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all()
          ),
        ),
        AnimatedContainer(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ), duration: AppConstants.duration200,
        ),
      ],
    );
  }
}
