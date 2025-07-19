import './mock_auth_service.dart';
import '../models/loan.dart';
import '../models/user.dart';
import '../models/transactions.dart';

class MockLoanService {
  final List<Loan> _loans = [];

  /// Submit a loan request (status: pending)
  String applyLoan(double amount, String reason) {
    final user = mockAuthService.currentUser;
    if (user == null) return 'No user logged in';
    if (amount <= 0) return 'Enter a valid loan amount';
    if (reason.isEmpty) return 'Please enter a reason';

    final loan = Loan(
      amount: amount,
      reason: reason,
      user: user,
    );

    _loans.add(loan);
    user.loans.add(loan);
    return 'Loan request submitted for ৳${amount.toStringAsFixed(2)}';
  }

  /// Get all loans (for admin)
  List<Loan> getAllLoans() => _loans;

  /// Get loans specific to current user
  List<Loan> getUserLoans() {
    final user = mockAuthService.currentUser;
    return _loans.where((loan) => loan.user == user).toList();
  }

  /// Get pending loans (for admin)
  List<Loan> getPendingLoans() {
    return _loans.where((loan) => loan.status == LoanStatus.pending).toList();
  }

  /// Approve a loan
  String approveLoan(String loanId) {
    final loan = _loans.firstWhere((l) => l.id == loanId, orElse: () => Loan(
      amount: 0,
      user: User.empty(),
      reason: '',
    ));

    if (loan.amount == 0) return 'Loan not found';
    if (loan.status != LoanStatus.pending) return 'Loan already processed';

    loan.status = LoanStatus.approved;
    loan.user.balance += loan.amount;

    // Add transaction record
    loan.user.transactions.add(Transaction(
      title: 'Loan Approved',
      amount: loan.amount,
      date: DateTime.now(),
    ));

    return 'Loan approved! ৳${loan.amount.toStringAsFixed(2)} added to account';
  }

  /// Reject a loan
  String rejectLoan(String loanId) {
    final loan = _loans.firstWhere((l) => l.id == loanId, orElse: () => Loan(
      amount: 0,
      user: User.empty(),
      reason: '',
    ));

    if (loan.amount == 0) return 'Loan not found';
    if (loan.status != LoanStatus.pending) return 'Loan already processed';

    loan.status = LoanStatus.rejected;
    return 'Loan rejected';
  }

  /// Repay part or full loan
  String repayLoan(String loanId, double amount) {
    final user = mockAuthService.currentUser;
    if (user == null) return 'No user logged in';

    final loan = _loans.firstWhere((l) => l.id == loanId, orElse: () => Loan(
      amount: 0,
      user: User.empty(),
      reason: '',
    ));

    if (loan.amount == 0) return 'Loan not found';
    if (loan.status != LoanStatus.approved) return 'Loan not approved';
    if (loan.remaining <= 0) return 'Loan already repaid';
    if (amount <= 0) return 'Enter valid amount';
    if (amount > user.balance) return 'Insufficient balance';

    final repayAmount = amount > loan.remaining ? loan.remaining : amount;

    user.balance -= repayAmount;
    loan.remaining -= repayAmount;

    // Add transaction record
    user.transactions.add(Transaction(
      title: 'Loan Repayment',
      amount: -repayAmount,
      date: DateTime.now(),
    ));

    return 'Repaid ৳${repayAmount.toStringAsFixed(2)}. Remaining: ৳${loan.remaining.toStringAsFixed(2)}';
  }
}

final loanService = MockLoanService();