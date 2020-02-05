import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'constant.dart' show languages;

class MyLocalizations {
  final Map<String, Map<String, String>> localizedValues;
  MyLocalizations(this.locale, this.localizedValues);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  String get hello {
    return localizedValues[locale.languageCode]['hello'];
  }

  String get welcome {
    return localizedValues[locale.languageCode]['welcome'];
  }

  String get signIn {
    return localizedValues[locale.languageCode]['signIn'];
  }

  String get signUp {
    return localizedValues[locale.languageCode]['signUp'];
  }

  String get signInToKools {
    return localizedValues[locale.languageCode]['signInToKools'];
  }

  String get welcomeToKools {
    return localizedValues[locale.languageCode]['welcomeToKools'];
  }

  String get enterToContinue {
    return localizedValues[locale.languageCode]['enterToContinue'];
  }

  String get letsGetStarted {
    return localizedValues[locale.languageCode]['letsGetStarted'];
  }

  String get enterYourFirstName {
    return localizedValues[locale.languageCode]['enterYourFirstName'];
  }

  String get enterYourLastName {
    return localizedValues[locale.languageCode]['enterYourLastName'];
  }

  String get enterYourEmail {
    return localizedValues[locale.languageCode]['enterYourEmail'];
  }

  String get enterYourContactNumber {
    return localizedValues[locale.languageCode]['enterYourContactNumber'];
  }

  String get enterPassword {
    return localizedValues[locale.languageCode]['enterPassword'];
  }

  String get forgotPassword {
    return localizedValues[locale.languageCode]['forgotPassword'];
  }

  String get pleaseEnterValidEmail {
    return localizedValues[locale.languageCode]['pleaseEnterValidEmail'];
  }

  String get pleaseEnterValidPassword {
    return localizedValues[locale.languageCode]['pleaseEnterValidPassword'];
  }

  String get pleaseEnterValidName {
    return localizedValues[locale.languageCode]['pleaseEnterValidName'];
  }

  String get pleaseEnterValidMobileNumber {
    return localizedValues[locale.languageCode]['pleaseEnterValidMobileNumber'];
  }

  String get whatsYourEmail {
    return localizedValues[locale.languageCode]['whatsYourEmail'];
  }

  String get verify {
    return localizedValues[locale.languageCode]['verify'];
  }

  String get verifyYourEmail {
    return localizedValues[locale.languageCode]['verifyYourEmail'];
  }

  String get codeSentTo {
    return localizedValues[locale.languageCode]['codeSentTo'];
  }

  String get resend {
    return localizedValues[locale.languageCode]['resend'];
  }

  String get error {
    return localizedValues[locale.languageCode]['error'];
  }

  String get resetPassword {
    return localizedValues[locale.languageCode]['resetPassword'];
  }

  String get resetYourPassword {
    return localizedValues[locale.languageCode]['resetYourPassword'];
  }

  String get enterNewPassword {
    return localizedValues[locale.languageCode]['enterNewPassword'];
  }

  String get thankYou {
    return localizedValues[locale.languageCode]['thankYou'];
  }

  String get loginSuccessful {
    return localizedValues[locale.languageCode]['loginSuccessful'];
  }

  String get allCategories {
    return localizedValues[locale.languageCode]['allCategories'];
  }

  String get viewAll {
    return localizedValues[locale.languageCode]['viewAll'];
  }

  String get selectLanguage {
    return localizedValues[locale.languageCode]['selectLanguage'];
  }

  String get changePassword {
    return localizedValues[locale.languageCode]['changePassword'];
  }

  String get savedCards {
    return localizedValues[locale.languageCode]['savedCards'];
  }

  String get deliveryAddress {
    return localizedValues[locale.languageCode]['deliveryAddress'];
  }

  String get logout {
    return localizedValues[locale.languageCode]['logout'];
  }

  String get wantToLogout {
    return localizedValues[locale.languageCode]['wantToLogout'];
  }

  String get cancel {
    return localizedValues[locale.languageCode]['cancel'];
  }

  String get changeProfilePicture {
    return localizedValues[locale.languageCode]['changeProfilePicture'];
  }

  String get chooseFromPhotos {
    return localizedValues[locale.languageCode]['chooseFromPhotos'];
  }

  String get takePhoto {
    return localizedValues[locale.languageCode]['takePhoto'];
  }

  String get removePhoto {
    return localizedValues[locale.languageCode]['removePhoto'];
  }

  String get please {
    return localizedValues[locale.languageCode]['please'];
  }

  String get unitPrice {
    return localizedValues[locale.languageCode]['unitPrice'];
  }

  String get discount {
    return localizedValues[locale.languageCode]['discount'];
  }

  String get subTotal {
    return localizedValues[locale.languageCode]['subTotal'];
  }

  String get deliveryCharges {
    return localizedValues[locale.languageCode]['deliveryCharges'];
  }

  String get grandTotal {
    return localizedValues[locale.languageCode]['grandTotal'];
  }

  String get clearCart {
    return localizedValues[locale.languageCode]['clearCart'];
  }

  String get checkOut {
    return localizedValues[locale.languageCode]['checkOut'];
  }

  String get removeItem {
    return localizedValues[locale.languageCode]['removeItem'];
  }

  String get wantToRemove {
    return localizedValues[locale.languageCode]['wantToRemove'];
  }

  String get no {
    return localizedValues[locale.languageCode]['no'];
  }

  String get yes {
    return localizedValues[locale.languageCode]['yes'];
  }

  String get items {
    return localizedValues[locale.languageCode]['items'];
  }

  String get orderHistory {
    return localizedValues[locale.languageCode]['orderHistory'];
  }

  String get trackOrders {
    return localizedValues[locale.languageCode]['trackOrders'];
  }

  String get storeLocator {
    return localizedValues[locale.languageCode]['storeLocator'];
  }

  String get termsConditions {
    return localizedValues[locale.languageCode]['termsConditions'];
  }

  String get help {
    return localizedValues[locale.languageCode]['help'];
  }

  String get gotQuestion {
    return localizedValues[locale.languageCode]['gotQuestion'];
  }

  String get unfavorite {
    return localizedValues[locale.languageCode]['unfavorite'];
  }

  String get wantToUnfavorite {
    return localizedValues[locale.languageCode]['wantToUnfavorite'];
  }

  String get quantity {
    return localizedValues[locale.languageCode]['quantity'];
  }

  String get buyNow {
    return localizedValues[locale.languageCode]['buyNow'];
  }

  String get addToCart {
    return localizedValues[locale.languageCode]['addToCart'];
  }

  String get homeDelivery {
    return localizedValues[locale.languageCode]['homeDelivery'];
  }

  String get setDeliveryArea {
    return localizedValues[locale.languageCode]['setDeliveryArea'];
  }

  String get pickUp {
    return localizedValues[locale.languageCode]['pickUp'];
  }

  String get setPickUpBranch {
    return localizedValues[locale.languageCode]['setPickUpBranch'];
  }

  String get priceChangesForPickup {
    return localizedValues[locale.languageCode]['priceChangesForPickup'];
  }

  String get delivery {
    return localizedValues[locale.languageCode]['delivery'];
  }

  String get setDeliveryType {
    return localizedValues[locale.languageCode]['setDeliveryType'];
  }

  String get withinDelivery {
    return localizedValues[locale.languageCode]['withinDelivery'];
  }

  String get onlyFromOutlets {
    return localizedValues[locale.languageCode]['onlyFromOutlets'];
  }

  String get search {
    return localizedValues[locale.languageCode]['search'];
  }

  String get typeToSearch {
    return localizedValues[locale.languageCode]['typeToSearch'];
  }

  String get noResultsFound {
    return localizedValues[locale.languageCode]['noResultsFound'];
  }

  String get resourceNotAvailable {
    return localizedValues[locale.languageCode]['resourceNotAvailable'];
  }

  String get payNow {
    return localizedValues[locale.languageCode]['payNow'];
  }

  String get orderSuccessful {
    return localizedValues[locale.languageCode]['orderSuccessful'];
  }

  String get checkout {
    return localizedValues[locale.languageCode]['checkout'];
  }

  String get cartSummary {
    return localizedValues[locale.languageCode]['cartSummary'];
  }

  String get promotionDiscounts {
    return localizedValues[locale.languageCode]['promotionDiscounts'];
  }

  String get addCoupon {
    return localizedValues[locale.languageCode]['addCoupon'];
  }

  String get couponApplied {
    return localizedValues[locale.languageCode]['couponApplied'];
  }

  String get apply {
    return localizedValues[locale.languageCode]['apply'];
  }

  String get recipientDetails {
    return localizedValues[locale.languageCode]['recipientDetails'];
  }

  String get deliveryInformation {
    return localizedValues[locale.languageCode]['deliveryInformation'];
  }

  String get addAddress {
    return localizedValues[locale.languageCode]['addAddress'];
  }

  String get noAddressFound {
    return localizedValues[locale.languageCode]['noAddressFound'];
  }

  String get areYouSure {
    return localizedValues[locale.languageCode]['areYouSure'];
  }

  String get wantToDeleteAddress {
    return localizedValues[locale.languageCode]['wantToDeleteAddress'];
  }

  String get deliveryDate {
    return localizedValues[locale.languageCode]['deliveryDate'];
  }

  String get deliveryDateWithin {
    return localizedValues[locale.languageCode]['deliveryDateWithin'];
  }

  String get deliveryInstructions {
    return localizedValues[locale.languageCode]['deliveryInstructions'];
  }

  String get callReceiveDelivery {
    return localizedValues[locale.languageCode]['callReceiveDelivery'];
  }

  String get paymentMethod {
    return localizedValues[locale.languageCode]['paymentMethod'];
  }

  String get cashOnDelivery {
    return localizedValues[locale.languageCode]['cashOnDelivery'];
  }

  String get creditDebit {
    return localizedValues[locale.languageCode]['creditDebit'];
  }

  String get enterRecipientName {
    return localizedValues[locale.languageCode]['enterRecipientName'];
  }

  String get enterRecipientContactNumber {
    return localizedValues[locale.languageCode]['enterRecipientContactNumber'];
  }

  String get cardNumber {
    return localizedValues[locale.languageCode]['cardNumber'];
  }

  String get monthYear {
    return localizedValues[locale.languageCode]['monthYear'];
  }

  String get addCard {
    return localizedValues[locale.languageCode]['addCard'];
  }

  String get removeCard {
    return localizedValues[locale.languageCode]['removeCard'];
  }

  String get wantToRemoveCard {
    return localizedValues[locale.languageCode]['wantToRemoveCard'];
  }

  String get currency {
    return localizedValues[locale.languageCode]['currency'];
  }

  String get upcoming {
    return localizedValues[locale.languageCode]['upcoming'];
  }

  String get completed {
    return localizedValues[locale.languageCode]['completed'];
  }

  String get cancelled {
    return localizedValues[locale.languageCode]['cancelled'];
  }

  String get allStores {
    return localizedValues[locale.languageCode]['allStores'];
  }

  String get nearBy {
    return localizedValues[locale.languageCode]['nearBy'];
  }

  String get getDirections {
    return localizedValues[locale.languageCode]['getDirections'];
  }

  String get rateProduct {
    return localizedValues[locale.languageCode]['rateProduct'];
  }

  String get orderDetails {
    return localizedValues[locale.languageCode]['orderDetails'];
  }

  String get writeDescription {
    return localizedValues[locale.languageCode]['writeDescription'];
  }

  String get yourQuestion {
    return localizedValues[locale.languageCode]['yourQuestion'];
  }

  String get askQuestion {
    return localizedValues[locale.languageCode]['askQuestion'];
  }

  String get typeQuestion {
    return localizedValues[locale.languageCode]['typeQuestion'];
  }

  String get cardHolderName {
    return localizedValues[locale.languageCode]['cardHolderName'];
  }

  String get cardNumberDigits {
    return localizedValues[locale.languageCode]['cardNumber'];
  }

  String get month {
    return localizedValues[locale.languageCode]['month'];
  }

  String get year {
    return localizedValues[locale.languageCode]['year'];
  }

  String get monthShouldBe {
    return localizedValues[locale.languageCode]['monthShouldBe'];
  }

  String get yearShouldBe {
    return localizedValues[locale.languageCode]['yearShouldBe'];
  }

  String get cvvNumber {
    return localizedValues[locale.languageCode]['cvvNumber'];
  }

  String get cvvShouldBe {
    return localizedValues[locale.languageCode]['cvvShouldBe'];
  }

  String get enterCorrectInfo {
    return localizedValues[locale.languageCode]['enterCorrectInfo'];
  }

  String get invalidDetails {
    return localizedValues[locale.languageCode]['invalidDetails'];
  }

  String get oldPassword {
    return localizedValues[locale.languageCode]['oldPassword'];
  }

  String get enterOldPassword {
    return localizedValues[locale.languageCode]['enterOldPassword'];
  }

  String get newPassword {
    return localizedValues[locale.languageCode]['newPassword'];
  }

  String get confirmPassword {
    return localizedValues[locale.languageCode]['confirmPassword'];
  }

  String get enterConfirmPassword {
    return localizedValues[locale.languageCode]['enterConfirmPassword'];
  }

  String get addressAdded {
    return localizedValues[locale.languageCode]['addressAdded'];
  }

  String get enterFlat {
    return localizedValues[locale.languageCode]['enterFlat'];
  }

  String get enterFlatName {
    return localizedValues[locale.languageCode]['enterFlatName'];
  }

  String get enterStreetName {
    return localizedValues[locale.languageCode]['enterStreetName'];
  }

  String get enterLocality {
    return localizedValues[locale.languageCode]['enterLocality'];
  }

  String get enterCity {
    return localizedValues[locale.languageCode]['enterCity'];
  }

  String get enterPincode {
    return localizedValues[locale.languageCode]['enterPincode'];
  }

  String get register {
    return localizedValues[locale.languageCode]['register'];
  }

  String get nexusMobile {
    return localizedValues[locale.languageCode]['nexusMobile'];
  }

  String get nexusMobileRegister {
    return localizedValues[locale.languageCode]['nexusMobileRegister'];
  }

  String get nicPassportNumber {
    return localizedValues[locale.languageCode]['nicPassportNumber'];
  }

  String get nicPassportName {
    return localizedValues[locale.languageCode]['nicPassportName'];
  }

  String get address {
    return localizedValues[locale.languageCode]['address'];
  }

  String get information {
    return localizedValues[locale.languageCode]['information'];
  }

  String get pleaseAdd {
    return localizedValues[locale.languageCode]['pleaseAdd'];
  }

  String get instructions {
    return localizedValues[locale.languageCode]['instructions'];
  }

  String get wouldYouAdd {
    return localizedValues[locale.languageCode]['wouldYouAdd'];
  }

  String get selectPaymentMethod {
    return localizedValues[locale.languageCode]['selectPaymentMethod'];
  }

  String get dateTime {
    return localizedValues[locale.languageCode]['dateTime'];
  }

  String get selectAddress {
    return localizedValues[locale.languageCode]['selectAddress'];
  }

  String get gotQuestion1 {
    return localizedValues[locale.languageCode]['gotQuestion1'];
  }

  String get gotQuestion2 {
    return localizedValues[locale.languageCode]['gotQuestion2'];
  }

  String get gotQuestion3 {
    return localizedValues[locale.languageCode]['gotQuestion3'];
  }

  String get gotQuestionAnswer1 {
    return localizedValues[locale.languageCode]['gotQuestionAnswer1'];
  }

  String get gotQuestionAnswer2 {
    return localizedValues[locale.languageCode]['gotQuestionAnswer2'];
  }

  String get gotQuestionAnswer3 {
    return localizedValues[locale.languageCode]['gotQuestionAnswer3'];
  }

  String get moreDetails {
    return localizedValues[locale.languageCode]['moreDetails'];
  }

  String get helpQuestion1 {
    return localizedValues[locale.languageCode]['helpQuestion1'];
  }

  String get helpQuestion2 {
    return localizedValues[locale.languageCode]['helpQuestion2'];
  }

  String get helpQuestion3 {
    return localizedValues[locale.languageCode]['helpQuestion3'];
  }

  String get helpQuestion4 {
    return localizedValues[locale.languageCode]['helpQuestion4'];
  }

  String get helpQuestion5 {
    return localizedValues[locale.languageCode]['helpQuestion5'];
  }

  String get helpQuestionAnswer1 {
    return localizedValues[locale.languageCode]['helpQuestionAnswer1'];
  }

  String get helpQuestionAnswer2 {
    return localizedValues[locale.languageCode]['helpQuestionAnswer2'];
  }

  String get helpQuestionAnswer3 {
    return localizedValues[locale.languageCode]['helpQuestionAnswer3'];
  }

  String get helpQuestionAnswer4 {
    return localizedValues[locale.languageCode]['helpQuestionAnswer4'];
  }

  String get helpQuestionAnswer5 {
    return localizedValues[locale.languageCode]['helpQuestionAnswer5'];
  }

  String get productTerms {
    return localizedValues[locale.languageCode]['productTerms'];
  }

  String get productTermsDetails {
    return localizedValues[locale.languageCode]['productTermsDetails'];
  }

  String get productTitle1 {
    return localizedValues[locale.languageCode]['productTitle1'];
  }

  String get productDetails1 {
    return localizedValues[locale.languageCode]['productDetails1'];
  }

  String get productTitle2 {
    return localizedValues[locale.languageCode]['productTitle2'];
  }

  String get productDetails2 {
    return localizedValues[locale.languageCode]['productDetails2'];
  }

  String get terms {
    return localizedValues[locale.languageCode]['terms'];
  }

  String get category {
    return localizedValues[locale.languageCode]['category'];
  }

  greetTo(name) {
    return localizedValues[locale.languageCode]['greetTo']
        .replaceAll('{{name}}', name);
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  Map<String, Map<String, String>> localizedValues;

  MyLocalizationsDelegate(this.localizedValues);

  @override
  bool isSupported(Locale locale) => languages.contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(
        MyLocalizations(locale, localizedValues));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
