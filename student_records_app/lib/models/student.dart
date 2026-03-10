class Student {
  final String id;        // Firestore document ID (auto-generated)
  final String name;
  final String studentId;
  final String email;
  final String course;
  final int age;

  Student({
    required this.id,
    required this.name,
    required this.studentId,
    required this.email,
    required this.course,
    required this.age,
  });

  // Converts Firestore document → Student object (for reading)
  factory Student.fromMap(String id, Map<String, dynamic> data) {
    return Student(
      id: id,
      name: data['name'] ?? '',
      studentId: data['studentId'] ?? '',
      email: data['email'] ?? '',
      course: data['course'] ?? '',
      age: data['age'] ?? 0,
    );
  }

  // Converts Student object → Firestore document (for writing)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'studentId': studentId,
      'email': email,
      'course': course,
      'age': age,
    };
  }
}