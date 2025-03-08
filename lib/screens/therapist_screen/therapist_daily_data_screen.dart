import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:therapy/screens/therapist_screen/add_record_screen.dart';
import 'package:therapy/providers/therapist_provider.dart';
import 'package:therapy/widgets/custom_add_button.dart';

class TherapistDailyDataScreen extends StatefulWidget {
  const TherapistDailyDataScreen({super.key});

  @override
  State<TherapistDailyDataScreen> createState() =>
      _TherapistDailyDataScreenState();
}

class _TherapistDailyDataScreenState extends State<TherapistDailyDataScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final therapistProvider =
        Provider.of<TherapistProvider>(context, listen: false);
    await therapistProvider.initializeTherapist(); // Initialize therapist data
    await _loadRecords();
  }

  Future<void> _loadRecords() async {
    final therapistProvider =
        Provider.of<TherapistProvider>(context, listen: false);
    await therapistProvider.loadTodayRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TherapistProvider>(
      builder: (context, therapistProvider, child) {
        final records = therapistProvider.todayRecords;
        final therapistName = therapistProvider.therapist?.name;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    SvgPicture.asset(
                      "assets/logoG.svg",
                      width: 17,
                    ),
                    Text(
                      "Therapy",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 6, 57, 24),
                      ),
                    ),
                  ],
                ),
                Text(
                  therapistName != null && therapistName.isNotEmpty
                      ? "Welcome $therapistName"
                      : "Welcome Therapist",
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 81, 92, 104),
                  ),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                child: CircleAvatar(
                  backgroundImage: therapistProvider.profileImageUrl != null
                      ? NetworkImage(therapistProvider.profileImageUrl!)
                          as ImageProvider
                      : const AssetImage("assets/profile.png") as ImageProvider,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF41B877),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      alignment: Alignment.centerLeft,
                      children: [
                        Positioned(
                          right: 290,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4FC283),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(100),
                                        bottomLeft: Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4FC283),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(100),
                                        bottomRight: Radius.circular(100),
                                      ),
                                    ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4FC283),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(100),
                                        bottomRight: Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4FC283),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(100),
                                        bottomLeft: Radius.circular(100),
                                      ),
                                    ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 17, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    color: Colors.white,
                                    size: 42,
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "12-05-2023",
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "Happy Holi",
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                "Holiday",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Today's Record",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(255, 24, 8, 41),
                          ),
                          softWrap: true,
                        ),
                      ),
                      CustomAddButton(
                        title: "Add Record",
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRecordScreen(),
                            ),
                          );
                          _loadRecords();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (records.isEmpty)
                    Center(
                      child: Text(
                        "No records for today",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color.fromARGB(255, 235, 246, 237),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record['patientName'].toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF080C3E),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      (record['therapyTypes'] as List<dynamic>)
                                          .map<Widget>(
                                            (therapy) => TherapyTag(
                                                text: therapy.toString()),
                                          )
                                          .toList(),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  'Date',
                                  '${record['date'].toDate().day}-${record['date'].toDate().month}-${record['date'].toDate().year} ${record['time']}',
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow('Given by', record['givenBy']),
                              ],
                            ),
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

Widget _buildInfoRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: Color.fromARGB(255, 55, 61, 69),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(width: 8),
      Flexible(
        flex: 2,
        child: Text(
          value,
          style: GoogleFonts.inter(
            color: Color.fromARGB(255, 147, 158, 170),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}

class TherapyTag extends StatelessWidget {
  final String text;

  const TherapyTag({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 233, 233, 233),
        borderRadius: BorderRadius.circular(20),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: Color.fromARGB(255, 46, 44, 52),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
