// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:auto_updater/auto_updater.dart';

class UpdaterService {

    UpdaterService.InternalPoint();
    static final UpdaterService instanceInternalPoint = UpdaterService.InternalPoint();
    static const String _feedURL = 'https://raw.githubusercontent.com/joshieponix/pqms_control_panel/refs/heads/dev/appcast.xml';
    static const int _intervalTime =  3600;
    
     // Inititalize auto updater
     Future<void> initialize() async {
        try {
          // Set feed url
          await autoUpdater.setFeedURL(_feedURL);
          
          // Set background schedule
          await autoUpdater.setScheduledCheckInterval(_intervalTime);

          // Check for updates for Background
          await _checkForUpdatesManual();

        } catch (e) {
          debugPrint(e.toString());
        }
     }


     Future<void> _checkForUpdatesManual() async {
        try {
            await autoUpdater.checkForUpdates(inBackground: true);
        } catch (e) {
            debugPrint(e.toString());
        }
     }

    

}