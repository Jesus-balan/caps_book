import 'dart:convert';
import 'dart:io';

import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

Future<void> uploadAndUpdateProfileImage(File imageFile) async {
  final token = await HiveService().getToken();

  final uploadUrl = Uri.parse("https://cabs.zenvicsoft.com/access/profile/photo/");
  final updateUrl = Uri.parse("https://cabs.zenvicsoft.com/driver/driver/update/");

  try {
    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final multipartFile = await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
      contentType: MediaType.parse(mimeType),
    );

    final uploadRequest = http.MultipartRequest("POST", uploadUrl)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(multipartFile);

    final uploadResponse = await uploadRequest.send();
    final responseBody = await uploadResponse.stream.bytesToString();
    final jsonResponse = json.decode(responseBody);

    if (uploadResponse.statusCode == 200 || uploadResponse.statusCode == 201) {
      final imageId = jsonResponse['data']['id'];

      await http.patch(
        updateUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({"image": imageId}),
      );
    }
    // Silently fail otherwise — or handle gracefully in UI layer
  } catch (_) {
    // Optional: Handle error in UI layer if needed
  }
}
