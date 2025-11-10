import 'dart:io';
import 'package:ap_news/modules/custom_drawer/jointeam_controller.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CareerApplyPage extends StatefulWidget {
  const CareerApplyPage({super.key});

  @override
  State<CareerApplyPage> createState() => _CareerApplyPageState();
}

class _CareerApplyPageState extends State<CareerApplyPage> {
  final CareerApplyController controller = Get.put(CareerApplyController());

  final Color primaryRed = const Color(0xFFB00010);

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  String? selectedState = "Bihar";
  String? selectedDistrict;

  String? resumeFile;
  File? resumePickedFile;

  String? demoVideo;
  File? demoVideoPickedFile;

  List<String> districts = [
    "Patna",
    "Gaya",
    "Bhagalpur",
    "Muzaffarpur",
    "Darbhanga",
  ];

  // ✅ PICK RESUME
  Future<void> pickResume() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "doc", "docx"],
    );

    if (file != null) {
      setState(() {
        resumeFile = file.files.single.name;
        resumePickedFile = File(file.files.single.path!);
      });
    }
  }

  // ✅ PICK VIDEO
  Future<void> pickVideo() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (file != null) {
      setState(() {
        demoVideo = file.files.single.name;
        demoVideoPickedFile = File(file.files.single.path!);
      });
    }
  }

  // ✅ SUBMIT FORM HANDLER
  Future<void> submitForm() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        selectedDistrict == null ||
        resumePickedFile == null) {
      Get.snackbar("Error", "Please fill all required fields!",
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
      return;
    }

    final result = await controller.submitCareerForm(
      name: nameCtrl.text,
      email: emailCtrl.text,
      phone: phoneCtrl.text,
      district: selectedDistrict!,
      resumeFile: resumePickedFile,
      demoVideo: demoVideoPickedFile,
    );

    if (result["success"]) {
      Get.snackbar("Success", "Application Submitted!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Failed", result["message"],
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryRed,
        title: const Text("Join Our Team",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE BOX
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                    decoration: BoxDecoration(
                      color: primaryRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Start your career with AP News",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  buildLabel("Full Name *"),
                  buildInput(nameCtrl, "Enter your full name"),
                  SizedBox(height: 15.h),

                  buildLabel("Email *"),
                  buildInput(emailCtrl, "your.email@example.com"),
                  SizedBox(height: 15.h),

                  buildLabel("Phone No. *"),
                  buildInput(phoneCtrl, "+91 9876543210",
                      keyboard: TextInputType.phone),
                  SizedBox(height: 15.h),

                  // ✅ STATE + DISTRICT ROW
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel("State"),
                            dropdownBox(
                              value: selectedState,
                              items: ["Bihar"],
                              onChanged: (v) => setState(() => selectedState = v),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel("District *"),
                            dropdownBox(
                              value: selectedDistrict,
                              hint: "Select District",
                              items: districts,
                              onChanged: (v) =>
                                  setState(() => selectedDistrict = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  // ✅ Resume Upload
                  buildLabel("Upload Resume *"),
                  uploadButton(
                    text: resumeFile ?? "Click to upload your resume",
                    onTap: pickResume,
                  ),
                  const Text("PDF, DOC, DOCX (Max 5MB)",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),

                  SizedBox(height: 20.h),

                  buildLabel("Demo Video (Anchoring/Interview)"),
                  uploadButton(
                    text: demoVideo ?? "Upload demo video",
                    onTap: pickVideo,
                  ),
                  const Text("Your anchoring, interviewing or reporting video",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),

                  SizedBox(height: 30.h),

                  // ✅ Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primaryRed)),
                          child:
                              Text("Cancel", style: TextStyle(color: primaryRed)),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: submitForm,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryRed),
                          child: const Text("Submit Application",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),

            // ✅ LOADING OVERLAY
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      }),
    );
  }

  // ✅ WIDGET HELPERS

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget buildInput(TextEditingController ctrl, String hint,
      {TextInputType keyboard = TextInputType.text}) {
    return Container(
      decoration: boxDecoration(),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.black),
        
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget dropdownBox({
    required String? value,
    String? hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: boxDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: hint != null
              ? Text(hint, style: TextStyle(color: Colors.black))
              : null,
          items:
              items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget uploadButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(top: 6, bottom: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_file_outlined, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    );
  }
}
