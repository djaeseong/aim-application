import 'package:aim_application/core/shared_preference.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dl = GetIt.instance;

Future<void> registerServices() async {
  /// Register Shared Preferences
  final sharedPreference = await SharedPreferences.getInstance();
  dl
    ..registerLazySingleton(() => SharedPreference(sharedPreference))
    // ..registerLazySingleton(() => FirebaseCrashlytics.instance)
    // ..registerLazySingleton(NotificationController.new)
    // ..registerLazySingleton(SecureStorage.new)
    // ..registerLazySingleton(() => FirebaseRemoteConfig.instance)
    ..registerLazySingleton(() => sharedPreference);

  // ..registerLazySingleton(() => const FlutterAppAuth())
  // ..registerLazySingleton(() => KeycloakService(dl<FlutterAppAuth>(), dl<SharedPreference>(), null))
  // ..registerLazySingleton(() => LangchainService(dl<SharedPreference>(), dl<SecureStorage>(), null))
  // ..registerLazySingleton(AuthDioClient.new)
  // ..registerLazySingleton(() => AuthDioClient().openapi)
  // ..registerLazySingleton(XSprintCrashlytics.new)
  // ..registerLazySingleton(AppsFlyerService.new);
}
