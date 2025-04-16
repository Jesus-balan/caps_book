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
          actions: [
          IconButton(
            onPressed: () {},
            iconSize: screenWidth * 0.065,
            icon: const Icon(Icons.notifications, color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            iconSize: screenWidth * 0.065,
            icon: const Icon(Icons.person, color: Colors.white,),
          ),
        ],
        ),
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
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
                          bottomColor: ColorStyle.accentColor,
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
                          bottomColor: ColorStyle.accentColor,
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
