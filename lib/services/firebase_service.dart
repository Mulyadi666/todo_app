import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  // Create
  Future<void> createTask(
      String title, String description, DateTime dueDate) async {
    try {
      await tasks.add({
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating task: $e');
    }
  }

  // Read
  Stream<List<Map<String, dynamic>>> readTasks() {
    return tasks.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            ...data,
          };
        }).toList());
  }

  // Update
  Future<void> updateTask(
      String id, String title, String description, DateTime dueDate) async {
    try {
      await tasks.doc(id).update({
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
      });
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  // Delete
  Future<void> deleteTask(String id) async {
    try {
      await tasks.doc(id).delete();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
