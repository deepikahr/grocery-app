// import 'package:sentry/sentry.dart';

// final SentryClient sentry = new SentryClient(
//     dsn: "https://61bcefa6518f4429b7a7c0121519d231@sentry.io/1800138");

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ReportError {
  Future<Null> reportError(dynamic error, dynamic stackTrace) async {
    // print('Caught error: $error');
    // final SentryResponse response = await sentry.captureException(
    //   exception: error,
    //   stackTrace: stackTrace,
    // );
    // if (response.isSuccessful) {
    //   print('Success! Event ID: ${response.eventId}');
    // } else {
    //   print('Failed to report to Sentry.io: ${response.error}');
    // }

   ///We are using Firebase Crashlytics
    await FirebaseCrashlytics.instance.recordError(error, stackTrace);


  }
}
