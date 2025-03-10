import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/patient.dart';

class SuperPatientProvider extends ChangeNotifier {
  final List<Patient> _patients = [];
  Patient? _selectedPatient;
  bool _isLoading = false;
  String _error = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Patient> get patients => _patients;

  Patient? get selectedPatient => _selectedPatient;

  bool get isLoading => _isLoading;

  String get error => _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? errorMessage) {
    _error = errorMessage ?? '';
    notifyListeners();
  }

  Future<void> fetchPatients() async {
    setLoading(true);
    setError(null);
    try {
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> addPatient(Patient patient) async {
    setLoading(true);
    setError(null);
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .add(patient.toMap());
      fetchPatients();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updatePatient(Patient patient) async {
    setLoading(true);
    setError(null);
    try {} catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  final List<String> _allergies = [
    'Cheese',
    'Curd',
    'Egg',
    'Garlic',
    'Gluten',
    'Lemon',
    'Meat',
    'Milk',
    'Nuts',
    'Oats',
    'Other Fruits',
    'Peanut',
    'Peppers',
    'Preserved Foods',
    'Shellfish/Fish',
    'Soya',
  ];

  List<bool> _selectedAllergies = [];

  List<String> get allergies => _allergies;

  List<bool> get selectedAllergies => _selectedAllergies;

  SuperPatientProvider() {
    _selectedAllergies = List.generate(_allergies.length, (_) => false);
  }

  void addAllergy(String newAllergy) {
    _allergies.add(newAllergy);
    _selectedAllergies.add(true);
    notifyListeners();
  }

  void toggleSelection(int index) {
    _selectedAllergies[index] = !_selectedAllergies[index];
    notifyListeners();
  }

  List<String> getSelectedAllergies() {
    return _selectedAllergies
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => _allergies[entry.key])
        .toList();
  }

  String _bloodGroup = '';

  String get bloodGroup => _bloodGroup;

  final List<Map<String, dynamic>> _medicalRecords = [];
  final List<Map<String, dynamic>> _prescriptions = [];

  List<Map<String, dynamic>> get medicalRecords => _medicalRecords;

  List<Map<String, dynamic>> get prescriptions => _prescriptions;

  void updateBloodGroup(String newBloodGroup) {
    _bloodGroup = newBloodGroup;
    notifyListeners();
  }

  void deleteAllergy(String allergy) {
    int index = _allergies.indexOf(allergy);
    if (index != -1) {
      _selectedAllergies.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> pickImage(ImageSource source, bool isPrescription) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      String imageName = image.name;
      String imageTime =
          DateFormat('dd-MM-yyyy • hh:mm a').format(DateTime.now());
      String imagePath = image.path;

      // Upload image to Firebase Storage
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('patient_medical_records/$imageName');
      final UploadTask uploadTask = storageRef.putFile(File(imagePath));

      final TaskSnapshot downloadUrl = await uploadTask;
      final String imageUrl = await downloadUrl.ref.getDownloadURL();

      if (isPrescription) {
        _prescriptions.add({
          'title': imageName,
          'date': imageTime,
          'imagePath': imageUrl,
        });
      } else {
        _medicalRecords.add({
          'title': imageName,
          'date': imageTime,
          'imagePath': imageUrl,
        });
      }
      notifyListeners();
    }
  }

  void deleteRecord(Map<String, dynamic> record) {
    _medicalRecords.remove(record);
    notifyListeners();
  }

  void deletePrescription(Map<String, dynamic> prescription) {
    _prescriptions.remove(prescription);
    notifyListeners();
  }

  void saveData() {
    // Implement the logic to save data to a database or persistent storage
    // For example, you might save to shared preferences, a local database, or a remote server
    print(
        'Data saved: $bloodGroup, $selectedAllergies, $medicalRecords, $prescriptions');
  }

  // OTP Verification Method
  Future<void> verifyOTP(String verificationId, String smsCode) async {
    setLoading(true);
    setError(null);
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign the user in (or link) with the credential
      await _auth.signInWithCredential(credential);

      // Fetch patients data after successful OTP verification
      await fetchPatients();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
