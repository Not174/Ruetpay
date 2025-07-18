import './mock_auth_service.dart'; // Corrected import path
import '../models/transactions.dart';

class MockTransactionService {
  /// Adds a transaction to the current user's transaction list.
  void addTransaction(String title, double amount) {
    final user = mockAuthService.currentUser; // Use the renamed instance
    if (user == null) return;

    final transaction = Transaction(
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    user.transactions.insert(0, transaction);
  }

  /// Returns all transactions of the current user.
  List<Transaction> getTransactions() {
    final user = mockAuthService.currentUser; // Use the renamed instance
    return user?.transactions ?? [];
  }

  /// Returns the latest [count] transactions for current user.
  List<Transaction> getRecentTransactions([int count = 3]) {
    final user = mockAuthService.currentUser; // Use the renamed instance
    if (user == null) return [];
    return user.transactions.take(count).toList();
  }
}

final transactionService = MockTransactionService();