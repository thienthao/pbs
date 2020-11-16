import 'package:get_it/get_it.dart';
import 'package:customer_app_java_support/services/navigation_service.dart';
import 'package:customer_app_java_support/services/push_notification_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => PushNotificationService());
}