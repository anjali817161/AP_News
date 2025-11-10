import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../../services/api_endpoints.dart';

class CareerApplyController extends GetxController {
  var isLoading = false.obs;

  Future<Map<String, dynamic>> submitCareerForm({
    required String name,
    required String email,
    required String phone,
    required String district,
    File? resumeFile,
    File? demoVideo,
  }) async {
    try {
      isLoading.value = true;

      var url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.Joinnow);

      var request = http.MultipartRequest("POST", url);

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['district'] = district;

      // ✅ Resume
      if (resumeFile != null) {
        final mimeType = lookupMimeType(resumeFile.path) ?? "application/pdf";
        final mime = mimeType.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            "resume",
            resumeFile.path,
            contentType: MediaType(mime[0], mime[1]),
          ),
        );
      }

      // ✅ Demo Video
      if (demoVideo != null) {
        final mimeType = lookupMimeType(demoVideo.path) ?? "video/mp4";
        final mime = mimeType.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            "demoVideo",
            demoVideo.path,
            contentType: MediaType(mime[0], mime[1]),
          ),
        );
      }

      var response = await request.send();
      var body = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        
        return {
          "success": true,
          "data": body,
        };
      } else {
        return {
          "success": false,
          "message": body,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    } finally {
      isLoading.value = false;
    }
  }
}
