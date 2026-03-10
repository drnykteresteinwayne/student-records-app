import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class FirebaseService {
  // Gets a reference to the 'students' collection in Firestore
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');

  // CREATE — adds a new student document to Firestore
  Future<void> addStudent(Student student) async {
    await _studentsCollection.add(student.toMap());
  }

  // READ — returns a live stream of all students from Firestore
  Stream<List<Student>> getStudents() {
    return _studentsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Student.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // UPDATE — finds the document by ID and updates its fields
  Future<void> updateStudent(Student student) async {
    await _studentsCollection.doc(student.id).update(student.toMap());
  }

  // DELETE — finds the document by ID and permanently removes it
  Future<void> deleteStudent(String id) async {
    await _studentsCollection.doc(id).delete();
  }
}