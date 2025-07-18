import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';  // Ensure correct import
import '../models/transactions.dart';
import '../widgets/custom_text_field.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  void _withdraw() {
    final user = mockAuthService.currentUser;
    if (user == null) {
      setState(() => _message = 'No user logged in');
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0;
    final password = _passwordController.text.trim();

    // Validate inputs
    if (amount <= 0) {
      setState(() => _message = 'Enter valid amount');
      return;
    }

    if (password.isEmpty) {
      setState(() => _message = 'Password is required for withdrawal');
      return;
    }

    // Check password
    if (user.password != password) {
      setState(() => _message = 'Incorrect password');
      return;
    }

    if (user.balance < amount) {
      setState(() => _message = 'Insufficient funds');
      return;
    }

    setState(() {
      user.balance -= amount;
      user.transactions.add(Transaction(
        title: 'Withdrawal',
        amount: -amount,
        date: DateTime.now(),
      ));
      _message = 'Withdrew ৳${amount.toStringAsFixed(2)}';
      _amountController.clear();
      _passwordController.clear();
    });

    // ✅ Return to dashboard and trigger refresh
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw Money')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Security Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Password required for security verification',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Current Balance: ৳${mockAuthService.currentUser?.balance.toStringAsFixed(2) ?? "0.00"}',  // Use renamed instance
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _withdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Withdraw'),
            ),
            const SizedBox(height: 20),
            Text(_message, style: TextStyle(
              color: _message.contains('Withdrew') ? Colors.blue : Colors.red,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
      ),
    );
  }
}