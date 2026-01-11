import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateManager {
  final BuildContext context;
  // This is a placeholder URL. Since "version.json" is created locally as per request,
  // we would normally point this to the raw content of that file on the server.
  // For this example to work in a real scenario, this URL must be the hosted path of version.json.
  final String versionCheckUrl =
      "https://raw.githubusercontent.com/aariznazirwani/masjidnoor/main/version.json";

  UpdateManager(this.context);

  Future<void> checkForUpdates() async {
    try {
      // In a real app, you would fetch from the remote server.
      // Since we just created the local file, we can't 'fetch' it via HTTP unless it is hosted.
      // However, the request implies setting up the architecture.

      // To simulate reading the local file for testing purposes if you were running a server:
      // final response = await http.get(Uri.parse(versionCheckUrl));

      // For now, I will simulate the response based on the file we created.
      // In production, uncomment the http call and remove this map.
      final Map<String, dynamic> versionData = {
        "latestVersion": "1.0.0", // Change this to test update logic
        "isMandatory": true,
        "updateUrl": "https://github.com/aariznazirwani/masjidnoor",
      };

      // Real implementation would be:
      // final response = await http.get(Uri.parse(versionCheckUrl));
      // if (response.statusCode != 200) return;
      // final versionData = json.decode(response.body);

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;
      final String latestVersion = versionData['latestVersion'];
      final bool isMandatory = versionData['isMandatory'];
      final String updateUrl = versionData['updateUrl'];

      if (_isUpdateAvailable(currentVersion, latestVersion)) {
        if (context.mounted) {
          _showUpdateDialog(isMandatory, updateUrl);
        }
      }
    } catch (e) {
      debugPrint("Error checking for updates: $e");
    }
  }

  bool _isUpdateAvailable(String current, String latest) {
    // Simple comparison logic
    // You might want to use a package like `pub_semver` for robust comparison
    List<String> currentParts = current.split('.');
    List<String> latestParts = latest.split('.');

    for (int i = 0; i < 3; i++) {
      int currentPart = int.parse(currentParts[i]);
      int latestPart = int.parse(latestParts[i]);
      if (latestPart > currentPart) return true;
      if (latestPart < currentPart) return false;
    }
    return false;
  }

  void _showUpdateDialog(bool isMandatory, String url) {
    showDialog(
      context: context,
      barrierDismissible: !isMandatory,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => !isMandatory,
          child: AlertDialog(
            title: const Text('Update Available'),
            content: Text(
              isMandatory
                  ? 'A critical update is available. You must update to continue using the app.'
                  : 'A new version of the app is available. Would you like to update?',
            ),
            actions: [
              if (!isMandatory)
                TextButton(
                  child: const Text('Later'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () {
                  _launchURL(url);
                  if (!isMandatory) {
                    Navigator.of(context).pop();
                  }
                  // If mandatory, we don't pop, keeping user on this screen.
                  // Ideally, we might exit app if they can't update, or just keep them here.
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
