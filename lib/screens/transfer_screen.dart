import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../models/transactions.dart';
import '../app_colors.dart';
import '../widgets/custom_text_field.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  String _message = '';

  void _performTransfer() {
    final user = mockAuthService.currentUser;
    if (user == null) {
      setState(() => _message = 'No user logged in');
      return;
    }

    final accountNumber = _accountController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (accountNumber.isEmpty) {
      setState(() => _message = 'Enter account number');
      return;
    }

    if (amount <= 0) {
      setState(() => _message = 'Enter valid amount');
      return;
    }

    if (user.balance < amount) {
      setState(() => _message = 'Insufficient balance');
      return;
    }

    // In a real app, you would verify the account number exists
    setState(() {
      user.balance -= amount;
      user.transactions.add(Transaction(
        title: 'Transfer to A/C: $accountNumber',
        amount: -amount,
        date: DateTime.now(),
      ));
      _message = 'Transferred ৳${amount.toStringAsFixed(2)} to $accountNumber';
      _accountController.clear();
      _amountController.clear();
    });
    Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Money'),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Current Balance: ৳${mockAuthService.currentUser?.balance.toStringAsFixed(2) ?? "0.00"}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Recipient Account Number',
              controller: _accountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performTransfer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white, // Restored to white text on blue background
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Transfer'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains('Transferred') ? Colors.blue : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}