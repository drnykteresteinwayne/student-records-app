import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/student.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Read',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: StreamBuilder<List<Student>>(
        stream: firebaseService.getStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No students found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Go to Create tab to add students',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }

          final students = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFF2196F3),
                        child: Text(
                          student.name.isNotEmpty
                              ? student.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${student.studentId}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Email: ${student.email}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3F2FD),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    student.course,
                                    style: const TextStyle(
                                      color: Color(0xFF2196F3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Age: ${student.age}',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          _showEditDialog(context, student, firebaseService);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, Student student,
      FirebaseService firebaseService) {
    final nameController = TextEditingController(text: student.name);
    final idController = TextEditingController(text: student.studentId);
    final emailController = TextEditingController(text: student.email);
    final courseController = TextEditingController(text: student.course);
    final ageController = TextEditingController(text: student.age.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // NAME — locked
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Restricted Field'),
                        ],
                      ),
                      content: const Text(
                        'Student Name is a protected field and cannot be changed. '
                        'Please contact the system administrator to update this field.',
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: nameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon:
                          const Icon(Icons.lock, color: Colors.orange),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // STUDENT ID — locked
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Restricted Field'),
                        ],
                      ),
                      content: const Text(
                        'Student ID is a protected field and cannot be modified. '
                        'Please contact the system administrator to update this field.',
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: idController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Student ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon:
                          const Icon(Icons.lock, color: Colors.orange),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // EMAIL — editable
              _dialogField(emailController, 'Email'),
              const SizedBox(height: 12),
              // COURSE — editable
              _dialogField(courseController, 'Course/Degree'),
              const SizedBox(height: 12),
              // AGE — editable
              _dialogField(ageController, 'Age', isNumber: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await firebaseService.updateStudent(Student(
                id: student.id,
                name: nameController.text.trim(),
                studentId: idController.text.trim(),
                email: emailController.text.trim(),
                course: courseController.text.trim(),
                age: int.tryParse(ageController.text.trim()) ?? 0,
              ));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}