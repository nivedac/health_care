import '../models/employee_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_model.dart';

class EmployeeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'employees';

  Future<List<EmployeeModel>> getEmployees() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => EmployeeModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  Future<EmployeeModel?> getEmployeeById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return EmployeeModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  Future<EmployeeModel> addEmployee(EmployeeModel employee) async {
    final docRef = await _firestore.collection(_collection).add(employee.toJson());
    return employee.copyWith(id: docRef.id);
  }

  Future<EmployeeModel> updateEmployee(EmployeeModel employee) async {
    await _firestore.collection(_collection).doc(employee.id).update(employee.toJson());
    return employee;
  }

  Future<EmployeeModel> activateEmployee(String id, bool isActive) async {
    await _firestore.collection(_collection).doc(id).update({'isActive': isActive});
    final doc = await _firestore.collection(_collection).doc(id).get();
    return EmployeeModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<void> deleteEmployee(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}

