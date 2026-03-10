import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/student.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  // Controllers capture what the user types in each field
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _courseController = TextEditingController();
  final _ageController = TextEditingController();

  bool _isLoading = false;

  // Called when the form is submitted
  Future<void> _addStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final student = Student(
          id: '',
          name: _nameController.text.trim(),
          studentId: _studentIdController.text.trim(),
          email: _emailController.text.trim(),
          course: _courseController.text.trim(),
          age: int.parse(_ageController.text.trim()),
        );
        await _firebaseService.addStudent(student);
        Navigator.pop(context); // Go back to dashboard after saving
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Full Name', Icons.person),
              const SizedBox(height: 12),
              _buildTextField(_studentIdController, 'Student ID', Icons.badge),
              const SizedBox(height: 12),
              _buildTextField(_emailController, 'Email', Icons.email, isEmail: true),
              const SizedBox(height: 12),
              _buildTextField(_courseController, 'Course', Icons.book),
              const SizedBox(height: 12),
              _buildTextField(_ageController, 'Age', Icons.cake, isNumber: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Student', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text field builder to avoid repeating code
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, {bool isEmail = false, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        return null;
      },
    );
  }
}