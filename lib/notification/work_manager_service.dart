import 'package:flutter_application_1/notification/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  void registerMyTask() async {
    await Workmanager().registerPeriodicTask(
      'id1',
      "show simple notification",
      frequency: const Duration(minutes: 15),
    );
  }

  Future<void> init() async {
    await Workmanager().initialize(actionTask, isInDebugMode: true);

    /// register my task
    registerMyTask();
  }

  void cancelTask(String id) {
    Workmanager().cancelByUniqueName(id);
  }
}

@pragma('vm:entry-point')
void actionTask() {
  // show notification
  Workmanager().executeTask((taskName, inputData) {
    LocalNotificationService.showDailyScheduledNotification();
    return Future.value(true);
  });
}
