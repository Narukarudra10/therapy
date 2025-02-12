import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAnnouncement extends StatefulWidget {
  const AddAnnouncement({super.key});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  String selectedAnnouncement = 'Active';
  bool showPatientSelection = false;
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Add Announcement"),
        titleTextStyle: GoogleFonts.inter(
          color: Color.fromARGB(255, 23, 28, 34),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          InkWell(
            onTap: () {},
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
                    // Adjust max width as needed
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Announcement to",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF878DBA),
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                iconEnabledColor: const Color(0xFF171C22),
                iconDisabledColor: const Color(0xFF171C22),
                dropdownColor: const Color.fromARGB(255, 243, 243, 253),
                value: selectedAnnouncement,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 46, 44, 52),
                ),
                icon: Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
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
                items: ['Specific', 'Active']
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(
                          role,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 46, 44, 52),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnnouncement = value!;
                    showPatientSelection = value == 'Specific';
                  });
                },
              ),
              if (showPatientSelection) ...[
                SizedBox(height: 16),
                Text(
                  "Select Patient",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF878DBA),
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  iconEnabledColor: const Color(0xFF171C22),
                  iconDisabledColor: const Color(0xFF171C22),
                  dropdownColor: const Color.fromARGB(255, 243, 243, 253),
                  value: 'Ankit',
                  // Default value
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 46, 44, 52),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down),
                  decoration: InputDecoration(
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
                  items: ['Ankit', 'Shweta', 'Aman']
                      .map(
                        (patient) => DropdownMenuItem(
                          value: patient,
                          child: Text(
                            patient,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 46, 44, 52),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {},
                ),
              ],
              SizedBox(height: 16),
              Text(
                "Message",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF878DBA),
                ),
              ),
              SizedBox(height: 8),
              Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: 6,
                  controller: controller,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 46, 44, 52),
                  ),
                  decoration: InputDecoration(
                    hintText: "Write here",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF2E2C34),
                    ),
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your message";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              customListTile(Icons.notifications_active_rounded,
                  "Push Notification", true, (y) {}),
              SizedBox(height: 8),
              customListTile(Icons.sms_rounded, "SMS", true, (y) {}),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customListTile(
    IconData icon, String title, bool value, void Function(bool?)? onChanged) {
  return ListTile(
    tileColor: Color(0xFFF9FAFB),
    leading: Icon(
      icon,
      size: 24,
      color: Color(0xFF292D32),
    ),
    title: Text(title),
    titleTextStyle: GoogleFonts.sora(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF110A3F),
    ),
    trailing: Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: Color(0xFF41B877),
    ),
  );
}
