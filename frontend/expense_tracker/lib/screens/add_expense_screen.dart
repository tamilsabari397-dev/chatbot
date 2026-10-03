import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/api_service.dart';


class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}


class _AddExpenseScreenState
    extends State<AddExpenseScreen> {

  final amountController =
      TextEditingController();

  final descriptionController =
      TextEditingController();


  String category = "Food";


  final categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Entertainment",
    "Other",
  ];


  bool saving = false;


  Future<void> saveExpense() async {

    final amount =
        double.tryParse(
      amountController.text,
    );


    if (amount == null || amount <= 0) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Enter a valid amount",
          ),
        ),
      );

      return;
    }


    if (descriptionController.text
        .trim()
        .isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Enter description",
          ),
        ),
      );

      return;
    }


    setState(() {
      saving = true;
    });


    final expense = Expense(

      amount: amount,

      category: category,

      description:
          descriptionController.text.trim(),

      date: DateTime.now(),
    );


    try {

      await ApiService.addExpense(
        expense,
      );

      if (!mounted) return;

      Navigator.pop(context);

    } catch (e) {

      setState(() {
        saving = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Add Expense",
        ),
      ),


      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(

              controller: amountController,

              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),

              decoration:
                  const InputDecoration(
                labelText: "Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 15),


            DropdownButtonFormField<String>(

              value: category,

              decoration:
                  const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),

              items: categories
                  .map(
                    (item) =>
                        DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),

              onChanged: (value) {

                setState(() {
                  category = value!;
                });
              },
            ),


            const SizedBox(height: 15),


            TextField(

              controller:
                  descriptionController,

              decoration:
                  const InputDecoration(
                labelText: "Description",
                hintText: "Example: Lunch",
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 25),


            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                onPressed:
                    saving ? null : saveExpense,

                child: saving

                    ? const CircularProgressIndicator()

                    : const Text(
                        "Add Expense",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}