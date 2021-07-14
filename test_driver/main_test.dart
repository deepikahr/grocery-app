// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:screenshots/capture_screen.dart';
// import 'package:test/test.dart';

// void main() {
//   group('SS-G1', () {
//     FlutterDriver driver;
//     final config = {}; //Config();

//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });

//     tearDownAll(() async {
//       if (driver != null) await driver.close();
//     });

//     test('Take screenshots', () async {
//       SerializableFinder viewAllButton = find.byValueKey('view-all-categories');
//       await driver.waitFor(viewAllButton);
//       await screenshot(driver, config, '01_homepage');
//       await driver.tap(viewAllButton);
//       SerializableFinder firstCategory = find.byValueKey('0-first-category');
//       await driver.waitFor(firstCategory);
//       await screenshot(driver, config, '02_categories');
//       await driver.tap(firstCategory);
//       await screenshot(driver, config, '03_products');
//       SerializableFinder firstProduct = find.byValueKey('0-first-product');
//       await driver.waitFor(firstProduct);
//       await driver.tap(firstProduct);
//       await screenshot(driver, config, '04_product_details');
//     }, timeout: Timeout(Duration(minutes: 15)));
//   });
// }
