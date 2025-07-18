import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../services/course_service.dart';
import '../models/transactions.dart';
import '../app_colors.dart';
import '../widgets/custom_text_field.dart';

class CourseRegistrationFeeScreen extends StatefulWidget {
  const CourseRegistrationFeeScreen({super.key});

  @override
  State<CourseRegistrationFeeScreen> createState() => _CourseRegistrationFeeScreenState();
}

class _CourseRegistrationFeeScreenState extends State<CourseRegistrationFeeScreen> {
  final _regularCourseController = TextEditingController();
  final _sessionalCourseController = TextEditingController();
  String? _error;

  int get totalFee => courseService.calculateRegistrationFee();

  void _payRegistrationFee() {
    final user = mockAuthService.currentUser;
    if (user == null) {
      setState(() => _error = 'No user logged in');
      return;
    }

    if (totalFee <= 0) {
      setState(() => _error = 'Add courses first');
      return;
    }

    if (user.balance < totalFee) {
      setState(() => _error = 'Insufficient balance');
      return;
    }

    setState(() {
      user.balance -= totalFee;
      user.transactions.add(Transaction(
        title: 'Course Reg (${courseService.regularCourseCount}R ${courseService.sessionalCourseCount}S)',
        amount: -totalFee.toDouble(),
        date: DateTime.now(),
      ));
      courseService.markCoursesAsPaid(); // Mark courses as paid, making them available for exam fee
      _error = null;
    });

    Navigator.pop(context);
  }

  void _addRegularCourse() {
    if (_regularCourseController.text.isNotEmpty) {
      setState(() {
        courseService.addRegularCourse(_regularCourseController.text);
        _regularCourseController.clear();
      });
    }
  }

  void _addSessionalCourse() {
    if (_sessionalCourseController.text.isNotEmpty) {
      setState(() {
        courseService.addSessionalCourse(_sessionalCourseController.text);
        _sessionalCourseController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Regular Courses Section
            const Text('Regular Courses', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Add Regular Course Name',
                    controller: _regularCourseController,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addRegularCourse,
                  child: const Text('Add Course'),
                ),
              ],
            ),
            if (courseService.regularCourses.isNotEmpty)
              Column(
                children: [
                  const Text('Your Regular Courses:'),
                  ...courseService.regularCourses.map((course) => ListTile(
                    title: Text(course),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          courseService.removeRegularCourse(course);
                        });
                      },
                    ),
                  )).toList(),
                ],
              ),

            // Sessional Courses Section
            const SizedBox(height: 20),
            const Text('Sessional Courses', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Add Sessional Course Name',
                    controller: _sessionalCourseController,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addSessionalCourse,
                  child: const Text('Add Course'),
                ),
              ],
            ),
            if (courseService.sessionalCourses.isNotEmpty)
              Column(
                children: [
                  const Text('Your Sessional Courses:'),
                  ...courseService.sessionalCourses.map((course) => ListTile(
                    title: Text(course),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          courseService.removeSessionalCourse(course);
                        });
                      },
                    ),
                  )).toList(),
                ],
              ),

            // Fee Summary Section
            const SizedBox(height: 20),
            Card(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Registration Fee Summary', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Regular Courses: ${courseService.regularCourseCount}'),
                        Text('৳${courseService.regularCourseCount * 30}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sessional Courses: ${courseService.sessionalCourseCount}'),
                        Text('৳${courseService.sessionalCourseCount * 50}'),
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
            const SizedBox(height: 20),
            
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (totalFee > 0) ...[
              ElevatedButton(
                onPressed: _payRegistrationFee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Pay Registration Fee'),
              ),
              const SizedBox(height: 20),
            ],
            
            // Payment History Section
            if (courseService.registrationHistory.isNotEmpty) ...[
              const Divider(thickness: 2),
              const SizedBox(height: 16),
              Text(
                'Payment History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              ...courseService.registrationHistory.map((payment) => Card(
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