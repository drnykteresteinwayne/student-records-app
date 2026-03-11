import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/student.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _degreeController = TextEditingController();
  final _ageController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _idController.text.isEmpty ||
        _degreeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _firebaseService.addStudent(Student(
        id: '',
        name: _nameController.text.trim(),
        studentId: _idController.text.trim(),
        email: _emailController.text.trim(),
        course: _degreeController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 0,
      ));
      _nameController.clear();
      _idController.clear();
      _emailController.clear();
      _degreeController.clear();
      _ageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _degreeController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Create',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildField(_nameController, 'Name'),
            const SizedBox(height: 16),
            _buildField(_idController, 'Id'),
            const SizedBox(height: 16),
            _buildField(_emailController, 'Email'),
            const SizedBox(height: 16),
            _buildField(_degreeController, 'Degree'),
            const SizedBox(height: 16),
            _buildField(_ageController, 'Age', isNumber: true),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 48, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType:
          isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => controller.clear(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFF2196F3), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}