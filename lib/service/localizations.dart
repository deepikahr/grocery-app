import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/constants.dart';

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

  String get payByCard {
    return localizedValues[locale.languageCode]['payByCard'];
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

  String get home {
    return localizedValues[locale.languageCode]['home'];
  }

  String get cart {
    return localizedValues[locale.languageCode]['cart'];
  }

  String get myOrders {
    return localizedValues[locale.languageCode]['myOrders'];
  }

  String get favourites {
    return localizedValues[locale.languageCode]['favourites'];
  }

  String get profile {
    return localizedValues[locale.languageCode]['profile'];
  }

  String get aboutUs {
    return localizedValues[locale.languageCode]['aboutUs'];
  }

  String get login {
    return localizedValues[locale.languageCode]['login'];
  }

  String get restaurantsNearYou {
    return localizedValues[locale.languageCode]['restaurantsNearYou'];
  }

  String get topRatedRestaurants {
    return localizedValues[locale.languageCode]['topRatedRestaurants'];
  }

  String get newlyArrivedRestaurants {
    return localizedValues[locale.languageCode]['newlyArrivedRestaurants'];
  }

  String get reviews {
    return localizedValues[locale.languageCode]['reviews'];
  }

  String get branches {
    return localizedValues[locale.languageCode]['branches'];
  }

  String get selectLanguages {
    return localizedValues[locale.languageCode]['selectLanguages'];
  }

  String get shortDescription {
    return localizedValues[locale.languageCode]['shortDescription'];
  }

  String get emailId {
    return localizedValues[locale.languageCode]['emailId'];
  }

  String get fullName {
    return localizedValues[locale.languageCode]['fullName'];
  }

  String get mobileNumber {
    return localizedValues[locale.languageCode]['mobileNumber'];
  }

  String get subUrban {
    return localizedValues[locale.languageCode]['subUrban'];
  }

  String get state {
    return localizedValues[locale.languageCode]['state'];
  }

  String get country {
    return localizedValues[locale.languageCode]['country'];
  }

  String get postalCode {
    return localizedValues[locale.languageCode]['postalCode'];
  }

  String get save {
    return localizedValues[locale.languageCode]['save'];
  }

  String get yourEmail {
    return localizedValues[locale.languageCode]['yourEmail'];
  }

  String get yourPassword {
    return localizedValues[locale.languageCode]['yourPassword'];
  }

  String get loginToYourAccount {
    return localizedValues[locale.languageCode]['loginToYourAccount'];
  }

  String get dontHaveAccountYet {
    return localizedValues[locale.languageCode]['dontHaveAccountYet'];
  }

  String get signInNow {
    return localizedValues[locale.languageCode]['signInNow'];
  }

  String get password {
    return localizedValues[locale.languageCode]['password'];
  }

  String get acceptTerms {
    return localizedValues[locale.languageCode]['acceptTerms'];
  }

  String get registerNow {
    return localizedValues[locale.languageCode]['registerNow'];
  }

  String get resetPasswordOtp {
    return localizedValues[locale.languageCode]['resetPasswordOtp'];
  }

  String get resetMessage {
    return localizedValues[locale.languageCode]['resetMessage'];
  }

  String get verifyOtp {
    return localizedValues[locale.languageCode]['verifyOtp'];
  }

  String get otpErrorMessage {
    return localizedValues[locale.languageCode]['otpErrorMessage'];
  }

  String get otpMessage {
    return localizedValues[locale.languageCode]['otpMessage'];
  }

  String get createPassword {
    return localizedValues[locale.languageCode]['createPassword'];
  }

  String get createPasswordMessage {
    return localizedValues[locale.languageCode]['createPasswordMessage'];
  }

  String get connectionError {
    return localizedValues[locale.languageCode]['connectionError'];
  }

  String get favoritesListEmpty {
    return localizedValues[locale.languageCode]['favoritesListEmpty'];
  }

  String get removedFavoriteItem {
    return localizedValues[locale.languageCode]['removedFavoriteItem'];
  }

  String get cartEmpty {
    return localizedValues[locale.languageCode]['cartEmpty'];
  }

  String get history {
    return localizedValues[locale.languageCode]['history'];
  }

  String get noCompletedOrders {
    return localizedValues[locale.languageCode]['noCompletedOrders'];
  }

  String get orders {
    return localizedValues[locale.languageCode]['orders'];
  }

  String get status {
    return localizedValues[locale.languageCode]['status'];
  }

  String get view {
    return localizedValues[locale.languageCode]['view'];
  }

  String get track {
    return localizedValues[locale.languageCode]['track'];
  }

  String get total {
    return localizedValues[locale.languageCode]['total'];
  }

  String get paymentMode {
    return localizedValues[locale.languageCode]['paymentMode'];
  }

  String get chargesIncluding {
    return localizedValues[locale.languageCode]['chargesIncluding'];
  }

  String get trackOrder {
    return localizedValues[locale.languageCode]['trackOrder'];
  }

  String get orderProgress {
    return localizedValues[locale.languageCode]['orderProgress'];
  }

  String get daysAgo {
    return localizedValues[locale.languageCode]['daysAgo'];
  }

  String get weeksAgo {
    return localizedValues[locale.languageCode]['weeksAgo'];
  }

  String get dayAgo {
    return localizedValues[locale.languageCode]['dayAgo'];
  }

  String get weekAgo {
    return localizedValues[locale.languageCode]['weekAgo'];
  }

  String get usersReview {
    return localizedValues[locale.languageCode]['usersReview'];
  }

  String get outletsDelivering {
    return localizedValues[locale.languageCode]['outletsDelivering'];
  }

  String get noLocationsFound {
    return localizedValues[locale.languageCode]['noLocationsFound'];
  }

  String get noProducts {
    return localizedValues[locale.languageCode]['noProducts'];
  }

  String get goToCart {
    return localizedValues[locale.languageCode]['goToCart'];
  }

  String get location {
    return localizedValues[locale.languageCode]['location'];
  }

  String get open {
    return localizedValues[locale.languageCode]['open'];
  }

  String get freeDeliveryAbove {
    return localizedValues[locale.languageCode]['freeDeliveryAbove'];
  }

  String get deliveryChargesOnly {
    return localizedValues[locale.languageCode]['deliveryChargesOnly'];
  }

  String get freeDeliveryAvailable {
    return localizedValues[locale.languageCode]['freeDeliveryAvailable'];
  }

  String get size {
    return localizedValues[locale.languageCode]['size'];
  }

  String get price {
    return localizedValues[locale.languageCode]['price'];
  }

  String get selectSize {
    return localizedValues[locale.languageCode]['selectSize'];
  }

  String get completeOrder {
    return localizedValues[locale.languageCode]['completeOrder'];
  }

  String get addNote {
    return localizedValues[locale.languageCode]['addNote'];
  }

  String get applyCoupon {
    return localizedValues[locale.languageCode]['applyCoupon'];
  }

  String get cookNote {
    return localizedValues[locale.languageCode]['cookNote'];
  }

  String get note {
    return localizedValues[locale.languageCode]['note'];
  }

  String get add {
    return localizedValues[locale.languageCode]['add'];
  }

  String get pleaseEnter {
    return localizedValues[locale.languageCode]['pleaseEnter'];
  }

  String get coupon {
    return localizedValues[locale.languageCode]['coupon'];
  }

  String get noCoupon {
    return localizedValues[locale.languageCode]['noCoupon'];
  }

  String get noResource {
    return localizedValues[locale.languageCode]['noResource'];
  }

  String get noCuisines {
    return localizedValues[locale.languageCode]['noCuisines'];
  }

  String get reviewOrder {
    return localizedValues[locale.languageCode]['reviewOrder'];
  }

  String get date {
    return localizedValues[locale.languageCode]['date'];
  }

  String get totalOrder {
    return localizedValues[locale.languageCode]['totalOrder'];
  }

  String get contactInformation {
    return localizedValues[locale.languageCode]['contactInformation'];
  }

  String get addressInformation {
    return localizedValues[locale.languageCode]['addressInformation'];
  }

  String get orderSummary {
    return localizedValues[locale.languageCode]['orderSummary'];
  }

  String get totalIncluding {
    return localizedValues[locale.languageCode]['totalIncluding'];
  }

  String get placeOrderNow {
    return localizedValues[locale.languageCode]['placeOrderNow'];
  }

  String get selectDateTime {
    return localizedValues[locale.languageCode]['selectDateTime'];
  }

  String get selectAddressFirst {
    return localizedValues[locale.languageCode]['selectAddressFirst'];
  }

  String get errorMessage {
    return localizedValues[locale.languageCode]['errorMessage'];
  }

  String get deliveryNotAvailable {
    return localizedValues[locale.languageCode]['deliveryNotAvailable'];
  }

  String get notDeliverToThisPostcode {
    return localizedValues[locale.languageCode]['notDeliverToThisPostcode'];
  }

  String get deliverToThisPostcode {
    return localizedValues[locale.languageCode]['deliverToThisPostcode'];
  }

  String get dineIn {
    return localizedValues[locale.languageCode]['dineIn'];
  }

  String get orderPlaced {
    return localizedValues[locale.languageCode]['orderPlaced'];
  }

  String get thankYouMessage {
    return localizedValues[locale.languageCode]['thankYouMessage'];
  }

  String get backTo {
    return localizedValues[locale.languageCode]['backTo'];
  }

  String get rateYourOrder {
    return localizedValues[locale.languageCode]['rateYourOrder'];
  }

  String get wereGlad {
    return localizedValues[locale.languageCode]['wereGlad'];
  }

  String get rateIt {
    return localizedValues[locale.languageCode]['rateIt'];
  }

  String get feedbackImportant {
    return localizedValues[locale.languageCode]['feedbackImportant'];
  }

  String get submit {
    return localizedValues[locale.languageCode]['submit'];
  }

  String get writeReview {
    return localizedValues[locale.languageCode]['writeReview'];
  }

  String get whereToDeliver {
    return localizedValues[locale.languageCode]['whereToDeliver'];
  }

  String get byCreating {
    return localizedValues[locale.languageCode]['byCreating'];
  }

  String get enterYour {
    return localizedValues[locale.languageCode]['enterYour'];
  }

  String get city {
    return localizedValues[locale.languageCode]['city'];
  }

  String get item {
    return localizedValues[locale.languageCode]['item'];
  }

  String get type {
    return localizedValues[locale.languageCode]['type'];
  }

  String get pickUpTime {
    return localizedValues[locale.languageCode]['pickUpTime'];
  }

  String get tableNo {
    return localizedValues[locale.languageCode]['tableNo'];
  }

  String get orderID {
    return localizedValues[locale.languageCode]['orderID'];
  }

  String get rate {
    return localizedValues[locale.languageCode]['rate'];
  }

  String get name {
    return localizedValues[locale.languageCode]['name'];
  }

  String get contactNo {
    return localizedValues[locale.languageCode]['contactNo'];
  }

  String get orderType {
    return localizedValues[locale.languageCode]['orderType'];
  }

  String get restaurant {
    return localizedValues[locale.languageCode]['restaurant'];
  }

  String get totalincludingGST {
    return localizedValues[locale.languageCode]['totalincludingGST'];
  }

  String get success {
    return localizedValues[locale.languageCode]['success'];
  }

  String get otp {
    return localizedValues[locale.languageCode]['otp'];
  }

  String get pleaseAccepttermsandconditions {
    return localizedValues[locale.languageCode]
        ['pleaseAccepttermsandconditions'];
  }

  String get alert {
    return localizedValues[locale.languageCode]['alert'];
  }

  String get ok {
    return localizedValues[locale.languageCode]['ok'];
  }

  String get nameonCard {
    return localizedValues[locale.languageCode]['nameonCard'];
  }

  String get pleaseenteryourfullname {
    return localizedValues[locale.languageCode]['pleaseenteryourfullname'];
  }

  String get creditCardNumber {
    return localizedValues[locale.languageCode]['creditCardNumber'];
  }

  String get cardNumbermustbeof16digit {
    return localizedValues[locale.languageCode]['cardNumbermustbeof16digit'];
  }

  String get mm {
    return localizedValues[locale.languageCode]['mm'];
  }

  String get invalidmonth {
    return localizedValues[locale.languageCode]['invalidmonth'];
  }

  String get yyyy {
    return localizedValues[locale.languageCode]['yyyy'];
  }

  String get invalidyear {
    return localizedValues[locale.languageCode]['invalidyear'];
  }

  String get cvv {
    return localizedValues[locale.languageCode]['cvv'];
  }

  String get cardNumbermustbeof3digit {
    return localizedValues[locale.languageCode]['cardNumbermustbeof3digit'];
  }

  String get selectOrderType {
    return localizedValues[locale.languageCode]['selectOrderType'];
  }

  String get restaurantAddress {
    return localizedValues[locale.languageCode]['restaurantAddress'];
  }

  String get dELIVERY {
    return localizedValues[locale.languageCode]['dELIVERY'];
  }

  String get clickToSlot {
    return localizedValues[locale.languageCode]['clickToSlot'];
  }

  String get dateandTime {
    return localizedValues[locale.languageCode]['dateandTime'];
  }

  String get time {
    return localizedValues[locale.languageCode]['time'];
  }

  String get selectDate {
    return localizedValues[locale.languageCode]['selectDate'];
  }

  String get closed {
    return localizedValues[locale.languageCode]['closed'];
  }

  String get pleaseSelectDatefirstforpickup {
    return localizedValues[locale.languageCode]
        ['pleaseSelectDatefirstforpickup'];
  }

  String get storeisClosedPleaseTryAgainduringouropeninghours {
    return localizedValues[locale.languageCode]
        ['storeisClosedPleaseTryAgainduringouropeninghours'];
  }

  String get somethingwentwrongpleaserestarttheapp {
    return localizedValues[locale.languageCode]
        ['somethingwentwrongpleaserestarttheapp'];
  }

  String get logoutSuccessfully {
    return localizedValues[locale.languageCode]['logoutSuccessfully'];
  }

  String get topRated {
    return localizedValues[locale.languageCode]['topRated'];
  }

  String get newlyArrived {
    return localizedValues[locale.languageCode]['newlyArrived'];
  }

  String get cod {
    return localizedValues[locale.languageCode]['cod'];
  }

  String get noPaymentMethods {
    return localizedValues[locale.languageCode]['noPaymentMethods'];
  }

  String get selectCard {
    return localizedValues[locale.languageCode]['selectCard'];
  }

  String get noSavedCardsPleaseaddone {
    return localizedValues[locale.languageCode]['noSavedCardsPleaseaddone'];
  }

  String get pleaseEnterCVV {
    return localizedValues[locale.languageCode]['pleaseEnterCVV'];
  }

  String get cVVmustbeof3digits {
    return localizedValues[locale.languageCode]['cVVmustbeof3digits'];
  }

  String get paymentFailed {
    return localizedValues[locale.languageCode]['paymentFailed'];
  }

  String get yourordercancelledPleasetryagain {
    return localizedValues[locale.languageCode]
        ['yourordercancelledPleasetryagain'];
  }

  String get productRemovedFromFavourite {
    return localizedValues[locale.languageCode]['productRemovedFromFavourite'];
  }

  String get productaddedtoFavourites {
    return localizedValues[locale.languageCode]['productaddedtoFavourites'];
  }

  String get whichextraingredientswouldyouliketoadd {
    return localizedValues[locale.languageCode]
        ['whichextraingredientswouldyouliketoadd'];
  }

  String get extra {
    return localizedValues[locale.languageCode]['extra'];
  }

  String get deliveryisNotAvailable {
    return localizedValues[locale.languageCode]['deliveryisNotAvailable'];
  }

  String get description {
    return localizedValues[locale.languageCode]['description'];
  }

  String get clearcart {
    return localizedValues[locale.languageCode]['clearcart'];
  }

  String get youhavesomeitemsalreadyinyourcartfromotherlocationremovetoaddthis {
    return localizedValues[locale.languageCode]
        ['youhavesomeitemsalreadyinyourcartfromotherlocationremovetoaddthis'];
  }

  String get nodeliveryavailable {
    return localizedValues[locale.languageCode]['nodeliveryavailable'];
  }

  String get freedeliveryabove {
    return localizedValues[locale.languageCode]['freedeliveryabove'];
  }

  String get freedeliveryavailable {
    return localizedValues[locale.languageCode]['freedeliveryavailable'];
  }

  String get storeisClosed {
    return localizedValues[locale.languageCode]['storeisClosed'];
  }

  String get openingTime {
    return localizedValues[locale.languageCode]['openingTime'];
  }

  String get sorry {
    return localizedValues[locale.languageCode]['sorry'];
  }

  String get restaurants {
    return localizedValues[locale.languageCode]['restaurants'];
  }

  String get restaurantSass {
    return localizedValues[locale.languageCode]['restaurantSass'];
  }

  String get grilledChickenLoremipsumdolorsitametconsecteturadipiscingelit {
    return localizedValues[locale.languageCode]
        ['grilledChickenLoremipsumdolorsitametconsecteturadipiscingelit'];
  }

  String get seddoeiusmodtemporincididuntutlaboreetdolormagna {
    return localizedValues[locale.languageCode]
        ['seddoeiusmodtemporincididuntutlaboreetdolormagna'];
  }

  String get pleaseSelectTimefirstforpickup {
    return localizedValues[locale.languageCode]
        ['pleaseSelectTimefirstforpickup'];
  }

  String get pleaseSelectAddshippingaddressfirst {
    return localizedValues[locale.languageCode]
        ['pleaseSelectAddshippingaddressfirst'];
  }

  String get noDeliverycharge {
    return localizedValues[locale.languageCode]['noDeliverycharge'];
  }

  String get houseFlatBlocknumber {
    return localizedValues[locale.languageCode]['houseFlatBlocknumber'];
  }

  String get pleaseenterhouseflatblocknumber {
    return localizedValues[locale.languageCode]
        ['pleaseenterhouseflatblocknumber'];
  }

  String get apartmentName {
    return localizedValues[locale.languageCode]['apartmentName'];
  }

  String get pleaseenterapartmentname {
    return localizedValues[locale.languageCode]['pleaseenterapartmentname'];
  }

  String get landMark {
    return localizedValues[locale.languageCode]['landMark'];
  }

  String get pleaseenterpostalcode {
    return localizedValues[locale.languageCode]['pleaseenterpostalcode'];
  }

  String get pleaseenterlandmark {
    return localizedValues[locale.languageCode]['pleaseenterlandmark'];
  }

  String get pleaseenter6digitpostalcode {
    return localizedValues[locale.languageCode]['pleaseenter6digitpostalcode'];
  }

  String get contactNumber {
    return localizedValues[locale.languageCode]['contactNumber'];
  }

  String get pleaseentercontactnumber {
    return localizedValues[locale.languageCode]['pleaseentercontactnumber'];
  }

  String get pleaseenter10digitcontactnumber {
    return localizedValues[locale.languageCode]
        ['pleaseenter10digitcontactnumber'];
  }

  String get addressTypeHomeWorkOthersetc {
    return localizedValues[locale.languageCode]['addressTypeHomeWorkOthersetc'];
  }

  String get savedAddress {
    return localizedValues[locale.languageCode]['savedAddress'];
  }

  String get addNewAddress {
    return localizedValues[locale.languageCode]['addNewAddress'];
  }

  String get edit {
    return localizedValues[locale.languageCode]['edit'];
  }

  String get delete {
    return localizedValues[locale.languageCode]['delete'];
  }

  String get editAddress {
    return localizedValues[locale.languageCode]['editAddress'];
  }

  String get updateAddress {
    return localizedValues[locale.languageCode]['updateAddress'];
  }

  String get update {
    return localizedValues[locale.languageCode]['update'];
  }

  String get passwordreset {
    return localizedValues[locale.languageCode]['passwordreset'];
  }

  String get pleaseenteryourregisteredEmailtosendtheresetcode {
    return localizedValues[locale.languageCode]
        ['pleaseenteryourregisteredEmailtosendtheresetcode'];
  }

  String get email {
    return localizedValues[locale.languageCode]['email'];
  }

  String get welcomeBack {
    return localizedValues[locale.languageCode]['welcomeBack'];
  }

  String get or {
    return localizedValues[locale.languageCode]['or'];
  }

  String get pleaseEnter4DigitOTP {
    return localizedValues[locale.languageCode]['pleaseEnter4DigitOTP'];
  }

  String get wehavesenta4digitcodeto {
    return localizedValues[locale.languageCode]['wehavesenta4digitcodeto'];
  }

  String get enterVerificationcode {
    return localizedValues[locale.languageCode]['enterVerificationcode'];
  }

  String get submitOTP {
    return localizedValues[locale.languageCode]['submitOTP'];
  }

  String get enternewpassword {
    return localizedValues[locale.languageCode]['enternewpassword'];
  }

  String get pleaseEnterMin6DigitPassword {
    return localizedValues[locale.languageCode]['pleaseEnterMin6DigitPassword'];
  }

  String get reenternewpassword {
    return localizedValues[locale.languageCode]['reenternewpassword'];
  }

  String get passwordsdonotmatch {
    return localizedValues[locale.languageCode]['passwordsdonotmatch'];
  }

  String get letsgetstarted {
    return localizedValues[locale.languageCode]['letsgetstarted'];
  }

  String get enterFullName {
    return localizedValues[locale.languageCode]['enterFullName'];
  }

  String get pleaseEnterValidFullName {
    return localizedValues[locale.languageCode]['pleaseEnterValidFullName'];
  }

  String get havegotanaccount {
    return localizedValues[locale.languageCode]['havegotanaccount'];
  }

  String get enterTextHere {
    return localizedValues[locale.languageCode]['enterTextHere'];
  }

  String get chat {
    return localizedValues[locale.languageCode]['chat'];
  }

  String get areyousureclosechat {
    return localizedValues[locale.languageCode]['areyousureclosechat'];
  }

  String get pleaseselectaddressfirst {
    return localizedValues[locale.languageCode]['pleaseselectaddressfirst'];
  }

  String get pleaseselecttimeslotfirst {
    return localizedValues[locale.languageCode]['pleaseselecttimeslotfirst'];
  }

  String get cartsummary {
    return localizedValues[locale.languageCode]['cartsummary'];
  }

  String get enterCouponCode {
    return localizedValues[locale.languageCode]['enterCouponCode'];
  }

  String get chooseDeliveryDateandTimeSlot {
    return localizedValues[locale.languageCode]
        ['chooseDeliveryDateandTimeSlot'];
  }

  String get sorryNoSlotsAvailableToday {
    return localizedValues[locale.languageCode]['sorryNoSlotsAvailableToday'];
  }

  String get proceed {
    return localizedValues[locale.languageCode]['proceed'];
  }

  String get store {
    return localizedValues[locale.languageCode]['store'];
  }

  String get savedItems {
    return localizedValues[locale.languageCode]['savedItems'];
  }

  String get myCart {
    return localizedValues[locale.languageCode]['myCart'];
  }

  String get ordered {
    return localizedValues[locale.languageCode]['ordered'];
  }

  String get orderConfirmed {
    return localizedValues[locale.languageCode]['orderConfirmed'];
  }

  String get outfordelivery {
    return localizedValues[locale.languageCode]['outfordelivery'];
  }

  String get orderdelivered {
    return localizedValues[locale.languageCode]['orderdelivered'];
  }

  String get reorder {
    return localizedValues[locale.languageCode]['reorder'];
  }

  String get tax {
    return localizedValues[locale.languageCode]['tax'];
  }

  String get star {
    return localizedValues[locale.languageCode]['star'];
  }

  String get rateNow {
    return localizedValues[locale.languageCode]['rateNow'];
  }

  String get itemsList {
    return localizedValues[locale.languageCode]['itemsList'];
  }

  String get orderStatus {
    return localizedValues[locale.languageCode]['orderStatus'];
  }

  String get paymentType {
    return localizedValues[locale.languageCode]['paymentType'];
  }

  String get pleaseentercorrectexpirymonthandyear {
    return localizedValues[locale.languageCode]
        ['pleaseentercorrectexpirymonthandyear'];
  }

  String get enteracardnumber {
    return localizedValues[locale.languageCode]['enteracardnumber'];
  }

  String get pleaseenter16digitcardnumber {
    return localizedValues[locale.languageCode]['pleaseenter16digitcardnumber'];
  }

  String get entercardHolderName {
    return localizedValues[locale.languageCode]['entercardHolderName'];
  }

  String get bankName {
    return localizedValues[locale.languageCode]['bankName'];
  }

  String get enterbankname {
    return localizedValues[locale.languageCode]['enterbankname'];
  }

  String get expiryMonth {
    return localizedValues[locale.languageCode]['expiryMonth'];
  }

  String get entercardexpiredmonth {
    return localizedValues[locale.languageCode]['entercardexpiredmonth'];
  }

  String get pleaseentera2digitcardexpiredmonth {
    return localizedValues[locale.languageCode]
        ['pleaseentera2digitcardexpiredmonth'];
  }

  String get expiryYear {
    return localizedValues[locale.languageCode]['expiryYear'];
  }

  String get enteracardexpiredyear {
    return localizedValues[locale.languageCode]['enteracardexpiredyear'];
  }

  String get pleaseentera4digitcardexpiredyear {
    return localizedValues[locale.languageCode]
        ['pleaseentera4digitcardexpiredyear'];
  }

  String get enteracardCVV {
    return localizedValues[locale.languageCode]['enteracardCVV'];
  }

  String get pleaseenter3digitcardCVV {
    return localizedValues[locale.languageCode]['pleaseenter3digitcardCVV'];
  }

  String get expired {
    return localizedValues[locale.languageCode]['expired'];
  }

  String get deleteCard {
    return localizedValues[locale.languageCode]['deleteCard'];
  }

  String get payment {
    return localizedValues[locale.languageCode]['payment'];
  }

  String get backToHome {
    return localizedValues[locale.languageCode]['backToHome'];
  }

  String get editProfile {
    return localizedValues[locale.languageCode]['editProfile'];
  }

  String get select {
    return localizedValues[locale.languageCode]['select'];
  }

  String get yourCartIsEmpty {
    return localizedValues[locale.languageCode]['yourCartIsEmpty'];
  }

  String get addSomeItemsToProceedToCheckout {
    return localizedValues[locale.languageCode]
        ['addSomeItemsToProceedToCheckout'];
  }

  String get whatareyoubuyingtoday {
    return localizedValues[locale.languageCode]['whatareyoubuyingtoday'];
  }

  String get iteamsFounds {
    return localizedValues[locale.languageCode]['iteamsFounds'];
  }

  String get explorebyCategories {
    return localizedValues[locale.languageCode]['explorebyCategories'];
  }

  String get products {
    return localizedValues[locale.languageCode]['products'];
  }

  String get deal {
    return localizedValues[locale.languageCode]['deal'];
  }

  String get topDeals {
    return localizedValues[locale.languageCode]['topDeals'];
  }

  String get dealsoftheday {
    return localizedValues[locale.languageCode]['dealsoftheday'];
  }

  String get limitedquantityavailableyoucantaddmorethan {
    return localizedValues[locale.languageCode]
        ['limitedquantityavailableyoucantaddmorethan'];
  }

  String get ofthisitem {
    return localizedValues[locale.languageCode]['ofthisitem'];
  }

  String get youhavenotselectedanyaddressyet {
    return localizedValues[locale.languageCode]
        ['youhavenotselectedanyaddressyet'];
  }

  String get mailUs {
    return localizedValues[locale.languageCode]['mailUs'];
  }

  String get callUs {
    return localizedValues[locale.languageCode]['callUs'];
  }

  String get yourLocation {
    return localizedValues[locale.languageCode]['yourLocation'];
  }

  String get off {
    return localizedValues[locale.languageCode]['off'];
  }

  String get ordernow {
    return localizedValues[locale.languageCode]['ordernow'];
  }

  String get oops {
    return localizedValues[locale.languageCode]['oops'];
  }

  String get outOfStock {
    return localizedValues[locale.languageCode]['outOfStock'];
  }

  String get and {
    return localizedValues[locale.languageCode]['and'];
  }

  String get moreitems {
    return localizedValues[locale.languageCode]['moreitems'];
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
  bool isSupported(Locale locale) =>
      Constants.LANGUAGES.contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(
        MyLocalizations(locale, localizedValues));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
