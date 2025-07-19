import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../services/mock_transaction_service.dart';
import '../widgets/transaction_title.dart';
import '../app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final user = mockAuthService.currentUser;
    final recentTransactions = transactionService.getRecentTransactions(5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RuetPay'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              mockAuthService.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Balance Card
            Card(
              color: AppColors.primaryBlue,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Current Balance',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '৳${user?.balance.toStringAsFixed(2) ?? "0.00"}',
                      style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              children: [
                _buildActionButton(Icons.attach_money, 'Deposit', '/deposit'),
                _buildActionButton(Icons.money_off, 'Withdraw', '/withdraw'),
                _buildActionButton(Icons.send, 'Transfer', '/transfer'),
                _buildActionButton(Icons.account_balance, 'Education Loan', '/loan'),
                _buildActionButton(Icons.school, 'Exam Fee', '/exam-fee'),
                _buildActionButton(Icons.app_registration, 'Course Reg.', '/course-registration'),
                _buildActionButton(Icons.list_alt, 'Transactions', '/transactions'),
                if (user?.isAdmin ?? false)
                  _buildActionButton(Icons.admin_panel_settings, 'Admin', '/admin-dashboard'),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Transactions
            const TransactionTitle(text: 'Recent Transactions'),
            const SizedBox(height: 8),
            recentTransactions.isEmpty
                ? const Center(child: Text('No transactions yet'))
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) {
                final tx = recentTransactions[index];
                return ListTile(
                  title: Text(tx.title),
                  trailing: Text(
                    '৳${tx.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: tx.amount >= 0 ? Colors.blue : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('${tx.date.toLocal()}'.split(' ')[0]),
                );
              },
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildActionButton(IconData icon, String label, String route) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, route); // Wait for the route to complete
        setState(() {}); // Refresh the dashboard when returning
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
            child: Icon(icon, color: AppColors.primaryBlue), // Restored to primaryBlue
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

}