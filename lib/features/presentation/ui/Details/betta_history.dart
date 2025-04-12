import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/repositories/betta_repository.dart';
import 'package:flutter/material.dart';
import 'package:caps_book/features/data/model/betta_model.dart';

class BettaListScreen extends StatelessWidget {
  const BettaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Betta Expenses"),
        backgroundColor: ColorStyle.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<BettaItem>>(
        future: BettaService.fetchBettaList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No betta data found"));
          }

          final bettaList = snapshot.data!;

          return ListView.builder(
            itemCount: bettaList.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final betta = bettaList[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("🧾 ", style: TextStyle(fontSize: 16)),
                            Text(
                              betta.bettaType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "₹ ${betta.amount}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Bottom row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("👤 ", style: TextStyle(fontSize: 16)),
                            Text(
                              betta.driverDetails.identity,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("📍 ", style: TextStyle(fontSize: 14)),
                            Text(
                              betta.bookingDetails?.startPlace ?? "N/A",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
