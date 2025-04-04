import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomTimelineTile extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final int step;
  final int currentStep;
  final bool isLast;

  const CustomTimelineTile({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    required this.step,
    required this.currentStep,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isLast: isLast,
      isFirst: step == 0,
      indicatorStyle: IndicatorStyle(
        color: currentStep >= step ? Colors.green : Colors.grey,
        iconStyle: IconStyle(iconData: icon, color: Colors.white),
      ),
      beforeLineStyle: LineStyle(color: currentStep > step ? Colors.green : Colors.grey),
      endChild: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: currentStep >= step ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: currentStep >= step ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
