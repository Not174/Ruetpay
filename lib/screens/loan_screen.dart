import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../services/mock_loan_services.dart';
import '../models/loan.dart';
import '../widgets/custom_text_field.dart';
import '../app_colors.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  String _message = '';
  String _repayMessage = '';
  final _repayAmountController = TextEditingController();

  void _applyLoan() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final reason = _reasonController.text.trim();

    final result = loanService.applyLoan(amount, reason);
    setState(() {
      _message = result;
      if (result.contains('submitted')) {
        _amountController.clear();
        _reasonController.clear();
      }
    });
  }

  void _repayLoan(Loan loan) {
    final amount = double.tryParse(_repayAmountController.text) ?? 0;
    final result = loanService.repayLoan(loan.id, amount);
    setState(() {
      _repayMessage = result;
      if (result.contains('Repaid')) {
        _repayAmountController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = mockAuthService.currentUser;
    final loans = loanService.getUserLoans();

    return Scaffold(
      appBar: AppBar(title: const Text('Education Loans')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Current Balance: ৳${user?.balance.toStringAsFixed(2) ?? "0.00"}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Loan Application Form
            CustomTextField(
              label: 'Education Loan Amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Reason for Education Loan',
              controller: _reasonController,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _applyLoan,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white, // Restored to white text on blue background
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Request Education Loan'),
            ),
            const SizedBox(height: 16),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color: _message.contains('submitted') ? Colors.blue : Colors.red,
                ),
              ),

            const SizedBox(height: 24),
            const Text(
              'My Education Loans',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: loans.isEmpty
                  ? const Center(child: Text('No education loan applications'))
                  : ListView.builder(
                itemCount: loans.length,
                itemBuilder: (context, index) {
                  final loan = loans[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text('৳${loan.amount.toStringAsFixed(2)}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: ${loan.status.toString().split('.').last}'),
                                Text('Remaining: ৳${loan.remaining.toStringAsFixed(2)}'),
                              ],
                            ),
                            trailing: Chip(
                              label: Text(
                                loan.status.toString().split('.').last,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: loan.status == LoanStatus.approved
                                  ? Colors.blue
                                  : loan.status == LoanStatus.rejected
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                          ),
                          if (loan.status == LoanStatus.approved && loan.remaining > 0) ...[
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    label: 'Repayment Amount',
                                    controller: _repayAmountController,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () => _repayLoan(loan),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryBlue,
                                      foregroundColor: Colors.white, // Restored to white text on blue background
                                      minimumSize: const Size(double.infinity, 40),
                                    ),
                                    child: const Text('Repay Loan'),
                                  ),
                                  if (_repayMessage.isNotEmpty)
                                    Text(
                                      _repayMessage,
                                      style: TextStyle(
                                        color: _repayMessage.contains('Repaid') ? Colors.blue : Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
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