// ignore_for_file: public_member_api_docs, sort_constructors_first
class OnBoard {
  String title;
  String desc;
  String image;
  OnBoard({
    required this.title,
    required this.desc,
    required this.image,
  });
}

final List<OnBoard> data = [
  OnBoard(
    image: 'assets/images/pomodoro_logo.svg',
    title: 'What is Pomodoro Technique?',
    desc:
        'The Pomodoro Technique is a time management method that uses a timer to break down work into intervals, traditionally 25 minutes in length, separated by short breaks.',
  ),
  OnBoard(
    image: 'assets/images/work_block.svg',
    title: 'Stay focused, do your work',
    desc:
        'First select a task to complete in 25 minutes & work until it rings. Give your work undivided attention.',
  ),
  OnBoard(
    image: 'assets/images/break_block.svg',
    title: 'Then take a break',
    desc:
        'Take a short 5 minute break. Do some exercise, listen to music, or have some coffee to regain your energy',
  ),
];
