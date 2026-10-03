import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/api_service.dart';
import '../widgets/expense_card.dart';
import 'add_expense_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  List<Expense> expenses = [];

  bool loading = true;


  @override
  void initState() {
    super.initState();

    loadExpenses();
  }


  Future<void> loadExpenses() async {

    try {

      final data =
          await ApiService.getExpenses();

      setState(() {
        expenses = data;
        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }


  double get total {

    double result = 0;

    for (final expense in expenses) {
      result += expense.amount;
    }

    return result;
  }


  Future<void> deleteExpense(int id) async {

    await ApiService.deleteExpense(id);

    loadExpenses();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Daily Expenses",
        ),
      ),


      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : Column(

              children: [

                const SizedBox(height: 20),


                // Total card

                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      children: [

                        const Text(
                          "Total Expenses",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "₹${total.toStringAsFixed(2)}",

                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 15),


                Expanded(

                  child: expenses.isEmpty

                      ? const Center(
                          child: Text(
                            "No expenses yet",
                          ),
                        )

                      : ListView.builder(

                          itemCount: expenses.length,

                          itemBuilder:
                              (context, index) {

                            final expense =
                                expenses[index];

                            return ExpenseCard(

                              expense: expense,

                              onDelete: () {
                                deleteExpense(
                                  expense.id!,
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),


      floatingActionButton:
          FloatingActionButton(

        onPressed: () async {

          await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  const AddExpenseScreen(),
            ),
          );

          loadExpenses();
        },

        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}