import 'user.dart';

enum LoanStatus {
  pending,
  approved,
  rejected,
}

class Loan {
  final String id;
  final double amount;
  final String reason;
  final User user;
  final DateTime applicationDate;
  LoanStatus status;
  double remaining; // Track remaining amount to repay

  Loan({
    required this.amount,
    required this.user,
    required this.reason,
    this.status = LoanStatus.pending,
  })  : id = DateTime.now().microsecondsSinceEpoch.toString(),
        applicationDate = DateTime.now(),
        remaining = amount; // Initialize remaining with full amount
}