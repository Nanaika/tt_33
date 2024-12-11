import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tt33/ui_kit/text_styles.dart';

import '../ui_kit/colors.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});


  @override
  Widget build(BuildContext context) {

    final isTerms = ModalRoute.of(context)?.settings.arguments as bool;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
            child: Stack(
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
                  isTerms? 'Terms & Privacy' : 'About us',
                  style: AppStyles.displayMedium,
                ))
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      isTerms ? terms : aboutUs,
                      style: AppStyles.bodyMedium,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

const String aboutUs = '''The prohibited or acceptable use clause in your terms of use agreement outlines all rules your users must follow when accessing your services.
Here is where you can list and ban behaviors and activities like:
Obscene, crude, or violent posts
False or misleading content
Breaking the law
Spamming or scamming the service or other users
Hacking or tampering with your website or app
Violating copyright laws
Harassing other users
Stalking other users
If your website or app gives users a lot of control and freedom while using your services, consider putting multiple use clauses within your terms of use.  The prohibited or acceptable use clause in your terms of use agreement outlines all rules your users must follow when accessing your services.
Here is where you can list and ban behaviors and activities like:
Obscene, crude, or violent posts
False or misleading content
Breaking the law
Spamming or scamming the service or other users
Hacking or tampering with your website or app
Violating copyright laws
Harassing other users
Stalking other users
If your website or app gives users a lot of control and freedom while using your services, consider putting multiple use clauses within your terms of use.

The prohibited or acceptable use clause in your terms of use agreement outlines all rules your users must follow when accessing your services.
Here is where you can list and ban behaviors and activities like:
Obscene, crude, or violent posts
False or misleading content
Breaking the law
Spamming or scamming the service or other users
Hacking or tampering with your website or app
Violating copyright laws
Harassing other users
Stalking other users
If your website or app gives users a lot of control and freedom while using your services, consider putting multiple use clauses within your terms of use. ''';

const String terms =
    '''The prohibited or acceptable use clause in your terms of use agreement outlines all rules your users must follow when accessing your services.
Here is where you can list and ban behaviors and activities like:
Obscene, crude, or violent posts
False or misleading content
Breaking the law
Spamming or scamming the service or other users
Hacking or tampering with your website or app
Violating copyright laws
Harassing other users
Stalking other users
If your website or app gives users a lot of control and freedom while using your services, consider putting multiple use clauses within your terms of use.  The prohibited or acceptable use clause in your terms of use agreement outlines all rules your users must follow when accessing your services.
Here is where you can list and ban behaviors and activities like:
Obscene, crude, or violent posts
False or misleading content
Breaking the law
Spamming or scamming the service or other users
Hacking or tampering with your website or app
Violating copyright laws
Harassing other users
Stalking other users
If your website or app gives users a lot of control and freedom while using your services, consider putting multiple use clauses within your terms of use.

The prohibited or acceptable use clause in your terms of use agreement outlines all rules your users must follow when accessing your services.
Here is where you can list and ban behaviors and activities like:
Obscene, crude, or violent posts
False or misleading content
Breaking the law
Spamming or scamming the service or other users
Hacking or tampering with your website or app
Violating copyright laws
Harassing other users
Stalking other users
If your website or app gives users a lot of control and freedom while using your services, consider putting multiple use clauses within your terms of use. 
''';
