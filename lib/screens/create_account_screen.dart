import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../widgets/custom_text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentRollController = TextEditingController(); // Changed from balance to student roll

  String _message = '';
  String _selectedAccountType = 'Student Account'; // Changed default to Student Account

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final studentRoll = _studentRollController.text.trim(); // Changed from initialBalance

    final success = mockAuthService.register(
      name: name,
      email: email,
      password: password,
      studentRoll: studentRoll, // Using student roll instead of initial balance
      accountType: _selectedAccountType, // Pass selected type here
    );

    if (success) {
      setState(() {
        _message = 'Account created! Please login.';
      });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      setState(() {
        _message = 'Email already exists. Try logging in.';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _studentRollController.dispose(); // Changed from balance to student roll
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: 'Name',
                controller: _nameController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Student Roll',
                controller: _studentRollController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your student roll';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedAccountType,
                decoration: const InputDecoration(
                  labelText: 'Account Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Student Account', child: Text('Student Account')),
                  DropdownMenuItem(value: 'Savings Account', child: Text('Savings Account')),
                  DropdownMenuItem(value: 'Current Account', child: Text('Current Account')),
                  DropdownMenuItem(value: 'Fixed Deposit Account', child: Text('Fixed Deposit Account')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value!;
                  });
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white, // This sets the text color to white
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 20),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('created') ? Colors.blue : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
