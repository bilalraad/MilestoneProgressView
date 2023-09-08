library milestone_progress;

import 'package:flutter/material.dart';

typedef MilestoneProgressBuilder = Widget Function(
  BuildContext context,
  String text,
  Color color,
);

class MilestoneProgress extends StatelessWidget {
  final double width;
  final double maxIconSize;
  final int totalMilestones;
  final int completedMilestone;
  final IconData completedIconData;
  final IconData nonCompletedIconData;
  final Color completedIconColor;
  final Color incompleteIconColor;
  final List<String>? titles;

  MilestoneProgress({
    this.maxIconSize = 24,
    required this.width,
    required this.totalMilestones,
    required this.completedMilestone,
    this.completedIconData = Icons.check_circle,
    this.nonCompletedIconData = Icons.adjust,
    this.completedIconColor = Colors.green,
    this.incompleteIconColor = Colors.grey,
    this.titles,
  }) : assert(totalMilestones == (titles?.length ?? totalMilestones));

  factory MilestoneProgress.weight({
    required double width,
    required List<int> milestones,
    required int weight,
    double maxIconSize = 24,
    IconData completedIconData = Icons.check_circle,
    IconData nonCompletedIconData = Icons.adjust,
    Color completedIconColor = Colors.green,
    Color incompleteIconColor = Colors.grey,
    List<String>? titles,
  }) {
    return MilestoneProgress(
      totalMilestones: milestones.length,
      width: width,
      completedMilestone: countCompletedMilestones(milestones, weight),
      completedIconColor: completedIconColor,
      completedIconData: completedIconData,
      nonCompletedIconData: nonCompletedIconData,
      incompleteIconColor: incompleteIconColor,
      maxIconSize: maxIconSize,
      titles: titles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: getTitleWithMilestone(
          width,
          totalMilestones,
          completedMilestone,
          completedIconData,
          nonCompletedIconData,
          completedIconColor,
          incompleteIconColor,
          maxIconSize,
          titles),
    );
  }
}

List<Widget> getTitleWithMilestone(
  double width,
  int totalPoints,
  int checkedPoints,
  IconData completedIconData,
  IconData nonCompletedIconData,
  Color completedIconColor,
  Color incompleteIconColor,
  double mxIconSize,
  List<String>? titles,
) {
  List<Widget> list = [];
  double iconSizeTemp = width / (1.5 * totalPoints);
  double lineSizeTemp = width / (3 * totalPoints);
  double maxIconSize = mxIconSize;
  double maxLineSize = mxIconSize / 2;

  // checks and adjusts icon size acc to max width
  double iconSize = iconSizeTemp > maxIconSize ? maxIconSize : iconSizeTemp;
  double lineSize = lineSizeTemp > maxLineSize ? maxLineSize : lineSizeTemp;

  for (int i = 0; i < (2 * totalPoints) - 1; i++) {
    final index = (2 * checkedPoints) - 1;
    if (i % 2 == 0) {
      list.add(
        Column(
          children: [
            Icon(
              i <= index ? completedIconData : nonCompletedIconData,
              size: iconSize,
              color: i <= index ? completedIconColor : incompleteIconColor,
            ),
            if (titles != null)
              SizedBox(
                height: 20,
                child: Text(titles[i ~/ 2]),
              )
          ],
        ),
      );
    } else {
      list.add(
        Container(
          height: 1,
          width: lineSize,
          margin: titles != null ? EdgeInsets.only(bottom: 15) : null,
          color: i < index ? completedIconColor : incompleteIconColor,
        ),
      );
    }
  }
  return list;
}

int countCompletedMilestones(List<int> milestones, int value) {
  int count = 0;
  for (int milestone in milestones) {
    if (milestone <= value) {
      count++;
    }
  }
  return count;
}
