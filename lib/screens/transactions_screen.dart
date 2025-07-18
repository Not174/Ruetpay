import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import 'package:intl/intl.dart';
import '../widgets/transaction_title.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  String formatTaka(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_BD', symbol: '৳');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final user = mockAuthService.currentUser;
    final transactions = user?.transactions ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TransactionTitle(text: 'Transaction History'),
            const SizedBox(height: 16),
            Expanded(
              child: transactions.isEmpty
                  ? const Center(child: Text('No transactions yet.'))
                  : ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return ListTile(
                    leading: Icon(
                      tx.amount >= 0 ? Icons.arrow_downward : Icons.arrow_upward,
                      color: tx.amount >= 0 ? Colors.blue : Colors.red,
                    ),
                    title: Text(tx.title),
                    subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                    trailing: Text(
                      formatTaka(tx.amount),
                      style: TextStyle(
                        color: tx.amount >= 0 ? Colors.blue : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}