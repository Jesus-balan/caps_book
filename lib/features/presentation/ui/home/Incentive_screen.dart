import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class IncentiveScreen extends StatelessWidget {
  const IncentiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Incentives"),
          backgroundColor: ColorStyle.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/expenselist');
                        },
                        child: SummaryCard(
                          title: "Expense history",
                          value: "Expense",
                          icon: LucideIcons.wallet,
                          bottomColor: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                     Expanded(
                      child: GestureDetector(
                        onTap: () {
                         Navigator.pushNamed(context, '/bettalist');
                        },
                        child: SummaryCard(
                          title: "Betta History",
                          value: "Betta",
                          icon: LucideIcons.history,
                          bottomColor: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    
  }
}
