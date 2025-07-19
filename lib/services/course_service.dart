class CourseService {
  static final CourseService _instance = CourseService._internal();
  factory CourseService() => _instance;
  CourseService._internal();

  final List<String> _regularCourses = [];
  final List<String> _sessionalCourses = [];
  final List<String> _paidRegularCourses = [];
  final List<String> _paidSessionalCourses = [];
  
  // Payment history tracking
  final List<PaymentHistory> _registrationHistory = [];
  final List<PaymentHistory> _examFeeHistory = [];

  // Getters for courses being added (not yet paid)
  List<String> get regularCourses => List.unmodifiable(_regularCourses);
  List<String> get sessionalCourses => List.unmodifiable(_sessionalCourses);
  
  // Getters for courses that have been paid for (available for exam fee)
  List<String> get paidRegularCourses => List.unmodifiable(_paidRegularCourses);
  List<String> get paidSessionalCourses => List.unmodifiable(_paidSessionalCourses);
  
  // Getters for payment history
  List<PaymentHistory> get registrationHistory => List.unmodifiable(_registrationHistory);
  List<PaymentHistory> get examFeeHistory => List.unmodifiable(_examFeeHistory);

  // Add courses to pending list
  void addRegularCourse(String courseName) {
    if (courseName.isNotEmpty && !_regularCourses.contains(courseName)) {
      _regularCourses.add(courseName);
    }
  }

  void addSessionalCourse(String courseName) {
    if (courseName.isNotEmpty && !_sessionalCourses.contains(courseName)) {
      _sessionalCourses.add(courseName);
    }
  }

  // Remove courses from pending list
  void removeRegularCourse(String courseName) {
    _regularCourses.remove(courseName);
  }

  void removeSessionalCourse(String courseName) {
    _sessionalCourses.remove(courseName);
  }

  // Mark courses as paid (move to paid list and clear pending)
  void markCoursesAsPaid() {
    // Add to payment history
    _registrationHistory.add(PaymentHistory(
      regularCourses: List.from(_regularCourses),
      sessionalCourses: List.from(_sessionalCourses),
      amount: calculateRegistrationFee(),
      date: DateTime.now(),
      type: 'Registration Fee',
    ));
    
    _paidRegularCourses.addAll(_regularCourses);
    _paidSessionalCourses.addAll(_sessionalCourses);
    _regularCourses.clear();
    _sessionalCourses.clear();
  }

  // Record exam fee payment
  void recordExamFeePayment() {
    _examFeeHistory.add(PaymentHistory(
      regularCourses: List.from(_paidRegularCourses),
      sessionalCourses: List.from(_paidSessionalCourses),
      amount: calculateExamFee(),
      date: DateTime.now(),
      type: 'Exam Fee',
    ));
  }

  // Clear all courses (useful for testing or user logout)
  void clearAllCourses() {
    _regularCourses.clear();
    _sessionalCourses.clear();
    _paidRegularCourses.clear();
    _paidSessionalCourses.clear();
    _registrationHistory.clear();
    _examFeeHistory.clear();
  }

  // Get course counts for registration (pending courses)
  int get regularCourseCount => _regularCourses.length;
  int get sessionalCourseCount => _sessionalCourses.length;
  
  // Get course counts for exam fee (paid courses)
  int get paidRegularCourseCount => _paidRegularCourses.length;
  int get paidSessionalCourseCount => _paidSessionalCourses.length;

  // Calculate fees
  int calculateRegistrationFee() {
    return (regularCourseCount * 30) + (sessionalCourseCount * 50);
  }

  int calculateExamFee() {
    return (paidRegularCourseCount * 30) + (paidSessionalCourseCount * 50);
  }
}

// Payment history model
class PaymentHistory {
  final List<String> regularCourses;
  final List<String> sessionalCourses;
  final int amount;
  final DateTime date;
  final String type;

  PaymentHistory({
    required this.regularCourses,
    required this.sessionalCourses,
    required this.amount,
    required this.date,
    required this.type,
  });
}

// Global instance
final courseService = CourseService();
