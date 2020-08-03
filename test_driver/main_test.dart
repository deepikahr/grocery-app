import 'package:flutter_driver/flutter_driver.dart';
import 'package:screenshots/screenshots.dart';
import 'package:test/test.dart';

void main() {
  group('SS-G1', () async {
    FlutterDriver driver;
    final config = Config();

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    // await LoginService.getLanguageJson('').then((value) async {
    test('Take screenshots', () async {
      // Map localizedValues = value['response_data']['json'];
      SerializableFinder store = find.text('Online Adres');
      await driver.waitFor(store);
      await screenshot(driver, config, '01_homepage');
      // await driver.waitFor(viewall);
      // await driver.tap(viewall);
      // await screenshot(driver, config, '01_viewall');
      // SerializableFinder savedItem = find.byType('SavedItems');
      // await driver.waitFor(savedItem);
      // await driver.tap(savedItem).then((value) async {
      //   SerializableFinder myCart = find.byType('MyCart');
      //   await driver.waitFor(myCart);
      //   await screenshot(driver, config, '02_saveditems');
      //   await driver.tap(myCart);
      //   await screenshot(driver, config, '03_mycart');
    }, timeout: Timeout(Duration(minutes: 5)));
  });
  // });
}
