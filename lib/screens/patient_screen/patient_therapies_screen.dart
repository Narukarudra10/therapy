import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:therapy/screens/patient_screen/view_therapist.dart';
import 'package:therapy/widgets/custom_appbar.dart';

import '../../providers/patient_provider.dart';
import '../../providers/super_center_provider.dart';

class PatientTherapiesScreen extends StatefulWidget {
  const PatientTherapiesScreen({
    super.key,
  });

  @override
  State<PatientTherapiesScreen> createState() => _PatientTherapiesScreenState();
}

class _PatientTherapiesScreenState extends State<PatientTherapiesScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SuperCenterProvider>(context);
    final owner = controller.owner;
    final String image = 'assets/center_profile.png';

    return Consumer<PatientProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: CustomAppBar(
            userName: provider.patient?.name ?? "User",
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 16, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Therapy Centers",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF180829),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color.fromARGB(255, 235, 246, 237),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: Image.asset(
                                image,
                                width: 100,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      'Gardens Galleria Par',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromARGB(
                                            255, 8, 12, 62),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: true,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      owner.location ?? '',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromARGB(
                                            255, 149, 160, 172),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: true,
                                    ),
                                  ),
                                  const SizedBox(height: 11),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewTherapist(
                                            imageUrl: image,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View Center",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color(0xFF41B877),
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xFF41B877),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
