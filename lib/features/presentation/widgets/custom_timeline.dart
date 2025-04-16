import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomTimelineTile extends StatefulWidget {
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
  State<CustomTimelineTile> createState() => _CustomTimelineTileState();
}

class _CustomTimelineTileState extends State<CustomTimelineTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400), // Faster blink
  )..repeat(reverse: true);

  _opacityAnim = Tween<double>(begin: 1.0, end: 0.3).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );
}
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator() {
    bool isActive = widget.step == widget.currentStep;
    bool isDone = widget.currentStep > widget.step;

    return isActive
        ? AnimatedBuilder(
            animation: _opacityAnim,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnim.value,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.green,
                  child: Icon(widget.icon, color: Colors.white, size: 18),
                ),
              );
            },
          )
        : CircleAvatar(
            radius: 16,
            backgroundColor: isDone ? Colors.green : Colors.grey,
            child: Icon(widget.icon, color: Colors.white, size: 18),
          );
  }

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isLast: widget.isLast,
      isFirst: widget.step == 0,
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        drawGap: true,
        indicator: _buildIndicator(),
      ),
      beforeLineStyle: LineStyle(
        color: widget.currentStep > widget.step ? Colors.green : Colors.grey,
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.currentStep >= widget.step
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.time,
              style: TextStyle(
                color: widget.currentStep >= widget.step
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
