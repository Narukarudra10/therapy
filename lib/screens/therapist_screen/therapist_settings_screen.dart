import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:therapy/models/therapist.dart';

import 'package:therapy/providers/therapist_provider.dart';
import 'package:therapy/screens/auth/login_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:therapy/screens/therapist_screen/update_phone_number.dart';

import '../../providers/auth_provider.dart';

class TherapistSettingsScreen extends StatefulWidget {
  const TherapistSettingsScreen({super.key});

  @override
  State<TherapistSettingsScreen> createState() =>
      _TherapistSettingsScreenState();
}

class _TherapistSettingsScreenState extends State<TherapistSettingsScreen> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initializeTherapistData();
  }

  Future<void> _initializeTherapistData() async {
    try {
      final provider = Provider.of<TherapistProvider>(context, listen: false);
      await provider.initializeTherapist();

      if (mounted) {
        setState(() {
          if (provider.therapist?.name != null) {
            controller.text = provider.therapist!.name!;
          }
        });
      }
    } catch (e) {
      print('Error initializing therapist data: $e');
    }
  }

  final TextEditingController controller = TextEditingController();
  void saveProfile(BuildContext context) async {
    try {
      final provider = Provider.of<TherapistProvider>(context, listen: false);
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final therapist = Therapist(
        name: controller.text.toString(),
        phoneNumber: currentUser.phoneNumber,
        email: provider.therapist?.email,
        gender: provider.therapist?.gender,
        dateOfBirth: provider.therapist?.dateOfBirth,
        city: provider.therapist?.city ?? 'Bhilwara',
      );

      await provider.saveTherapistData(therapist);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final therapistProvider = Provider.of<TherapistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        titleTextStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF171C22)),
        elevation: 0,
        shape: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBFD1E3), width: 0.3)),
        scrolledUnderElevation: 0,
        actions: [
          InkWell(
            onTap: () {
              saveProfile(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromARGB(255, 65, 184, 119),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue[200],
                      backgroundImage: therapistProvider.selectedImage != null
                          ? FileImage(therapistProvider.selectedImage!)
                          : therapistProvider.profileImageUrl != null
                              ? NetworkImage(therapistProvider.profileImageUrl!)
                                  as ImageProvider
                              : const AssetImage("assets/profile.png")
                                  as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Full Name',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 135, 141, 186),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 232, 233, 241),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 232, 233, 241),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 232, 233, 241),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Mobile Number',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 135, 141, 186),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '*',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 255, 43, 43),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                initialValue: therapistProvider.therapist?.phoneNumber ??
                    _auth.currentUser?.phoneNumber ??
                    '',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 232, 233, 241),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 232, 233, 241),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 232, 233, 241),
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdatePhoneNumber()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset("assets/edit.svg"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'City',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 135, 141, 186),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: 'Bhilwara',
                icon: Icon(Icons.keyboard_arrow_down_outlined),
                iconEnabledColor: const Color(0xFF171C22),
                iconDisabledColor: const Color(0xFF171C22),
                dropdownColor: const Color.fromARGB(255, 243, 243, 253),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 232, 233, 241),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 232, 233, 241),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 232, 233, 241),
                    ),
                  ),
                ),
                items: ['Bhilwara', 'Jaipur'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: FittedBox(child: Text(value)),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 32),
              InkWell(
                onTap: () {
                  authProvider.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Logout',
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.red,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final therapistProvider =
            Provider.of<TherapistProvider>(context, listen: false);
        therapistProvider.setImage(File(pickedFile.path));

        if (therapistProvider.therapist != null) {
          await therapistProvider
              .saveTherapistData(therapistProvider.therapist!);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
