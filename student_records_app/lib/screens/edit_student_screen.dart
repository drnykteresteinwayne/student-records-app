import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/student.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student; // The existing student passed from dashboard

  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  late TextEditingController _nameController;
  late TextEditingController _studentIdController;
  late TextEditingController _emailController;
  late TextEditingController _courseController;
  late TextEditingController _ageController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with the existing student's data
    _nameController = TextEditingController(text: widget.student.name);
    _studentIdController = TextEditingController(text: widget.student.studentId);
    _emailController = TextEditingController(text: widget.student.email);
    _courseController = TextEditingController(text: widget.student.course);
    _ageController = TextEditingController(text: widget.student.age.toString());
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final updatedStudent = Student(
          id: widget.student.id, // Keep the same Firestore document ID
          name: _nameController.text.trim(),
          studentId: _studentIdController.text.trim(),
          email: _emailController.text.trim(),
          course: _courseController.text.trim(),
          age: int.parse(_ageController.text.trim()),
        );
        await _firebaseService.updateStudent(updatedStudent);
        Navigator.pop(context); // Go back to dashboard after updating
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
        title: const Text('Edit Student'),
        backgroundColor: Colors.orange,
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
                onPressed: _isLoading ? null : _updateStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Student', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  @override
  void dispose() {
    // Clean up controllers when screen is removed
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
