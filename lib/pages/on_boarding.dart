import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resize/resize.dart';

import '../main.dart';
import '../utils/constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: data.length,
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemBuilder: (context, index) => onBoardingContent(
                  image: data[index].image,
                  title: data[index].title,
                  description: data[index].description,
                ),
              ),
            ),
            Row(
              children: [
                ...List.generate(
                    data.length,
                    (index) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DotIndicator(isActive: index == _pageIndex),
                        )),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  child: _pageIndex < data.length - 1
                      ? ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            backgroundColor: Colors.white,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: DynamicColorTheme.of(context).color,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (prefs.getBool(Constants.firstTimeOpen)!) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/home", (route) => false);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.titleSmall,
                            // shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Start Using Pomodoro Timer',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: DynamicColorTheme.of(context).color,
                                ),
                          ),
                        ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isActive ? 1.8.mv : 0.6.mv,
      width: 0.6.mv,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white24,
          borderRadius: BorderRadius.circular(12)),
      duration: const Duration(
        milliseconds: 300,
      ),
    );
  }
}

class OnBoard {
  final String image, title, description;

  OnBoard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnBoard> data = [
  OnBoard(
    image: 'assets/images/pomodoro logo.svg',
    title: 'What is Pomodoro Technique?',
    description:
        'The Pomodoro Technique is a time management method that uses a timer to break down work into intervals, traditionally 25 minutes in length, separated by short breaks.',
  ),
  OnBoard(
    image: 'assets/images/work block.svg',
    title: 'Stay focused, do your work',
    description:
        'First select a task to complete in 25 minutes & work until it rings. Give your work undivided attention.',
  ),
  OnBoard(
    image: 'assets/images/break block.svg',
    title: 'Then take a break',
    description:
        'Take a short 5 minute break. Do some exercise, listen to music, or have some coffee to regain your energy',
  ),
];

// ignore: camel_case_types
class onBoardingContent extends StatefulWidget {
  const onBoardingContent({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  final String title;
  final String image;
  final String description;

  @override
  State<onBoardingContent> createState() => _onBoardingContentState();
}

class _onBoardingContentState extends State<onBoardingContent> {
  double width = ResizeUtil().deviceType == DeviceType.Mobile
      ? 250.w
      : ResizeUtil().deviceType == DeviceType.Tablet
          ? 175.w
          : 100.h;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        SvgPicture.asset(widget.image,
            // fit: BoxFit.scaleDown,
            height: width),
        SizedBox(
          height: 20.h,
        ),
        Container(
          width: isMobile ? 100.w : 200.w,
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Container(
          width: isMobile ? 100.w : 150.w,
          child: Text(
            widget.description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
