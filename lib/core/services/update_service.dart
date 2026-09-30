// import 'dart:io';

// import 'package:desktop_updater/desktop_updater.dart';
// import 'package:path_provider/path_provider.dart';

// class UpdateService {
//   late final DesktopUpdaterController _controller;

//   bool _initialized = false;

//   Future<void> initialize() async {
//     if (_initialized) return;

//     final recoveryStore = await _createRecoveryStore();

//     _controller = DesktopUpdaterController(
//       appArchiveUrl: Uri.parse(
//         'https://YOUR-UPDATE-HOST/app-archive.json',
//       ),

//       expectedPackageId: 'your_flutter_app_name',

//       trustedReleasePublicKeys: const {
//         'YOUR-KEY-ID': 'YOUR-PUBLIC-KEY',
//       },

//       recoveryStore: recoveryStore,
//     );

//     _initialized = true;
//   }

//   Future<void> checkForUpdates() async {
//     try {
//       if (!_initialized) {
//         await initialize();
//       }

//       final result = await _controller.checkForUpdate();

//       if (result == null) {
//         print('No update available.');
//         return;
//       }

//       print('Update available!');
//       print('Version: ${result.version}');

//       // Later:
//       // Show your Flutter update dialog here.
//     } catch (e) {
//       // Update failure should NOT prevent
//       // your local production application from starting.
//       print('Update check failed: $e');
//     }
//   }

//   Future<void> downloadAndInstall() async {
//     try {
//       if (!_initialized) {
//         await initialize();
//       }

//       await _controller.downloadAndInstall();
//     } catch (e) {
//       print('Update installation failed: $e');
//     }
//   }

//   Future<UpdateRecoveryStore> _createRecoveryStore() async {
//     final directory = await getApplicationSupportDirectory();

//     final recoveryFile = File(
//       '${directory.path}${Platform.pathSeparator}update_recovery.json',
//     );

//     return JsonFileUpdateRecoveryStore(recoveryFile);
//   }

//   DesktopUpdaterController get controller => _controller;
// }