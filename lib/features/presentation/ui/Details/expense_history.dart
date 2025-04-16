import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/model/expense_model.dart';
import 'package:caps_book/features/data/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late Future<ExpenseResponse> futureExpenses;

  @override
  void initState() {
    super.initState();
    futureExpenses = ExpenseService.fetchExpenses();
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
        backgroundColor: ColorStyle.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<ExpenseResponse>(
        future: futureExpenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong. Please try again."),
            );
          } else if (!snapshot.hasData ||
              snapshot.data?.data?.results == null ||
              snapshot.data!.data!.results!.isEmpty) {
            return const Center(child: Text("No expense data found"));
          }
          final results = snapshot.data!.data.results;

          return ListView.builder(
            itemCount: results.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final expense = results[index];
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
                              expense.subcategory,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "₹ ${expense.amount}",
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
                            const Text("💳 ", style: TextStyle(fontSize: 16)),
                            Text(
                              expense.paymentMethod,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("⏰ ", style: TextStyle(fontSize: 14)),
                            Text(
                              formatDate(expense.createdAt),
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
