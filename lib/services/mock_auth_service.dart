import '../models/user.dart';

class MockAuthService {
  final Map<String, User> _users = {}; // Stores users by normalized email
  User? _currentUser; // Currently logged-in user

  // Payment status (temporary in-memory)
  bool hasPaidExamFee = false;
  bool hasPaidRegistrationFee = false;

  MockAuthService() {
    // Create default admin user
    const adminEmail = 'admin@example.com';
    _users[adminEmail] = User(
      name: 'Admin',
      email: adminEmail,
      password: 'admin123',
      accountNumber: 'AC000000000',
      accountType: 'Admin',
      studentRoll: 'ADMIN001', // Added student roll for admin
      balance: 999999,
      isAdmin: true,
    );
  }

  /// Returns the currently logged-in user
  User? get currentUser => _currentUser;

  /// Registers a new user
  bool register({
    required String name,
    required String email,
    required String password,
    required String studentRoll, // Changed from initialBalance to studentRoll
    required String accountType,
    String? accountNumber,
    bool isAdmin = false,
  }) {
    final normalizedEmail = _normalizeEmail(email);

    if (_users.containsKey(normalizedEmail)) {
      return false; // Email already exists
    }

    _users[normalizedEmail] = User(
      name: name,
      email: normalizedEmail,
      password: password,
      accountNumber: accountNumber ?? _generateAccountNumber(),
      accountType: accountType,
      studentRoll: studentRoll, // Using student roll instead of initial balance
      balance: 0, // All new accounts start with 0 balance
      isAdmin: isAdmin,
    );

    return true;
  }

  /// Logs in a user
  User? login({
    required String email,
    required String password,
  }) {
    final normalizedEmail = _normalizeEmail(email);
    final user = _users[normalizedEmail];

    if (user != null && user.password == password) {
      _currentUser = user;
      return user;
    }

    return null;
  }

  /// Logs out the current user
  void logout() {
    _currentUser = null;
    hasPaidExamFee = false;
    hasPaidRegistrationFee = false;
  }

  /// Retrieves a user by email
  User? getUser(String email) {
    return _users[_normalizeEmail(email)];
  }

  /// Returns all registered users
  List<User> getAllUsers() => _users.values.toList();

  /// Pay Exam Fee
  void payExamFee() {
    hasPaidExamFee = true;
  }

  /// Pay Registration Fee
  void payRegistrationFee() {
    hasPaidRegistrationFee = true;
  }

  /// Normalize email
  String _normalizeEmail(String email) => email.trim().toLowerCase();

  /// Dummy account number generator
  String _generateAccountNumber() {
    return 'AC${DateTime.now().millisecondsSinceEpoch.toString().substring(4, 13)}';
  }
}

final mockAuthService = MockAuthService();
