import 'package:flutter/material.dart';

import '../models/expense.dart';


class ExpenseCard extends StatelessWidget {

  final Expense expense;

  final VoidCallback onDelete;


  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
  });


  IconData getIcon() {

    switch (expense.category) {

      case "Food":
        return Icons.restaurant;

      case "Travel":
        return Icons.directions_bus;

      case "Shopping":
        return Icons.shopping_cart;

      case "Bills":
        return Icons.receipt;

      case "Entertainment":
        return Icons.movie;

      default:
        return Icons.category;
    }
  }


  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),

      child: ListTile(

        leading: CircleAvatar(
          child: Icon(
            getIcon(),
          ),
        ),


        title: Text(
          expense.category,

          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),


        subtitle: Text(
          expense.description,
        ),


        trailing: Row(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            Text(
              "₹${expense.amount.toStringAsFixed(2)}",

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),


            IconButton(

              onPressed: onDelete,

              icon: const Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}