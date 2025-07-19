import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../services/mock_loan_services.dart';
import '../app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  void _logout(BuildContext context) {
    mockAuthService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _approveLoan(String loanId) {
    final result = loanService.approveLoan(loanId);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.blue)
    );
    setState(() {});
  }

  void _rejectLoan(String loanId) {
    final result = loanService.rejectLoan(loanId);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.red)
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = mockAuthService.currentUser;
    final pendingLoans = loanService.getPendingLoans();
    final allUsers = mockAuthService.getAllUsers();

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Dashboard')),
        body: const Center(child: Text('No admin logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
                tooltip: 'View pending education loans',
              ),
              if (pendingLoans.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      pendingLoans.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Admin Info Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Admin',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue, // Restored to primaryBlue
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Email: ${user.email}'),
                    Text('Total Users: ${allUsers.length}'),
                    Text('Pending Education Loans: ${pendingLoans.length}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pending Loans Section
            if (pendingLoans.isNotEmpty) ...[
              const Text(
                'Pending Education Loan Applications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ...pendingLoans.map((loan) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '৳${loan.amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Chip(
                            label: const Text('Pending'),
                            backgroundColor: Colors.blue.shade100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('User: ${loan.user.name} (${loan.user.email})'),
                      Text('Account: ${loan.user.accountNumber}'),
                      Text('Current Balance: ৳${loan.user.balance.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      Text('Reason: ${loan.reason}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => _rejectLoan(loan.id),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Reject'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => _approveLoan(loan.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white, // Restored to white text on blue background
                            ),
                            child: const Text('Approve'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )).toList(),
              const SizedBox(height: 20),
            ],

            // User Accounts Section
            const Text(
              'User Accounts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ...allUsers.map((user) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(child: Text(user.name[0])),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text('৳${user.balance.toStringAsFixed(2)}'),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}