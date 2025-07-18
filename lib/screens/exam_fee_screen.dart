import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../services/course_service.dart';
import '../models/transactions.dart';
import '../app_colors.dart';

class ExamFeeScreen extends StatefulWidget {
  const ExamFeeScreen({super.key});

  @override
  State<ExamFeeScreen> createState() => _ExamFeeScreenState();
}

class _ExamFeeScreenState extends State<ExamFeeScreen> {
  String? _error;

  int get totalFee => courseService.calculateExamFee();

  void _payExamFee() {
    final user = mockAuthService.currentUser;
    if (user == null) {
      setState(() => _error = 'No user logged in');
      return;
    }

    if (courseService.paidRegularCourseCount == 0 && courseService.paidSessionalCourseCount == 0) {
      setState(() => _error = 'No courses registered. Please register courses first.');
      return;
    }

    if (totalFee <= 0) {
      setState(() => _error = 'No exam fee to pay');
      return;
    }

    if (user.balance < totalFee) {
      setState(() => _error = 'Insufficient balance');
      return;
    }

    setState(() {
      user.balance -= totalFee;
      user.transactions.add(Transaction(
        title: 'Exam Fee (${courseService.paidRegularCourseCount}R ${courseService.paidSessionalCourseCount}S)',
        amount: -totalFee.toDouble(),
        date: DateTime.now(),
      ));
      // Record exam fee payment in course service
      courseService.recordExamFeePayment();
      _error = null;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Fee')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Information Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade700, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Exam Fee for Registered Courses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Courses you registered will automatically appear here for exam fee payment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue.shade600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Registered Regular Courses
            if (courseService.paidRegularCourses.isNotEmpty) ...[
              const Text('Regular Courses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ...courseService.paidRegularCourses.map((course) => Card(
                child: ListTile(
                  leading: Icon(Icons.book, color: AppColors.primaryBlue),
                  title: Text(course),
                  trailing: Text('৳30', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                ),
              )).toList(),
              const SizedBox(height: 16),
            ],

            // Registered Sessional Courses
            if (courseService.paidSessionalCourses.isNotEmpty) ...[
              const Text('Sessional Courses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ...courseService.paidSessionalCourses.map((course) => Card(
                child: ListTile(
                  leading: Icon(Icons.computer, color: AppColors.primaryBlue),
                  title: Text(course),
                  trailing: Text('৳50', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                ),
              )).toList(),
              const SizedBox(height: 16),
            ],

            // No courses message
            if (courseService.paidRegularCourseCount == 0 && courseService.paidSessionalCourseCount == 0)
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.warning, color: Colors.orange.shade700, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'No Courses Registered',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please register for courses first in the Course Registration section.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.orange.shade600),
                      ),
                    ],
                  ),
                ),
              ),

            // Fee Summary
            if (totalFee > 0) ...[
              Card(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Exam Fee Summary', 
                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Regular Courses: ${courseService.paidRegularCourseCount}'),
                          Text('৳${courseService.paidRegularCourseCount * 30}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sessional Courses: ${courseService.paidSessionalCourseCount}'),
                          Text('৳${courseService.paidSessionalCourseCount * 50}'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('৳$totalFee', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),

            if (totalFee > 0) ...[
              ElevatedButton(
                onPressed: _payExamFee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Pay Exam Fee'),
              ),
              const SizedBox(height: 20),
            ],

            // Payment History Section
            if (courseService.examFeeHistory.isNotEmpty) ...[
              const Divider(thickness: 2),
              const SizedBox(height: 16),
              Text(
                'Exam Fee Payment History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              ...courseService.examFeeHistory.map((payment) => Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            payment.type,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '৳${payment.amount}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${payment.date.day}/${payment.date.month}/${payment.date.year} at ${payment.date.hour}:${payment.date.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (payment.regularCourses.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Regular Courses (${payment.regularCourses.length}):',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        ...payment.regularCourses.map((course) => Padding(
                          padding: const EdgeInsets.only(left: 16, top: 2),
                          child: Text('• $course', style: const TextStyle(fontSize: 12)),
                        )).toList(),
                      ],
                      if (payment.sessionalCourses.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Sessional Courses (${payment.sessionalCourses.length}):',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        ...payment.sessionalCourses.map((course) => Padding(
                          padding: const EdgeInsets.only(left: 16, top: 2),
                          child: Text('• $course', style: const TextStyle(fontSize: 12)),
                        )).toList(),
                      ],
                    ],
                  ),
                ),
              )).toList(),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}