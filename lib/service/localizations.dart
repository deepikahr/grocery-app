import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class MyLocalizations {
  final Map localizedValues;
  MyLocalizations(this.locale, this.localizedValues);
  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
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

  String get letsGetStarted {
    return localizedValues[locale.languageCode]['letsGetStarted'];
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

  String get error {
    return localizedValues[locale.languageCode]['error'];
  }

  String get enterNewPassword {
    return localizedValues[locale.languageCode]['enterNewPassword'];
  }

  String get thankYou {
    return localizedValues[locale.languageCode]['thankYou'];
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

  String get deliveryAddress {
    return localizedValues[locale.languageCode]['deliveryAddress'];
  }

  String get logout {
    return localizedValues[locale.languageCode]['logout'];
  }

  String get cancel {
    return localizedValues[locale.languageCode]['cancel'];
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

  String get quantity {
    return localizedValues[locale.languageCode]['quantity'];
  }

  String get addToCart {
    return localizedValues[locale.languageCode]['addToCart'];
  }

  String get typeToSearch {
    return localizedValues[locale.languageCode]['typeToSearch'];
  }

  String get noResultsFound {
    return localizedValues[locale.languageCode]['noResultsFound'];
  }

  String get payNow {
    return localizedValues[locale.languageCode]['payNow'];
  }

  String get checkout {
    return localizedValues[locale.languageCode]['checkout'];
  }

  String get cartSummary {
    return localizedValues[locale.languageCode]['cartSummary'];
  }

  String get couponApplied {
    return localizedValues[locale.languageCode]['couponApplied'];
  }

  String get apply {
    return localizedValues[locale.languageCode]['apply'];
  }

  String get addAddress {
    return localizedValues[locale.languageCode]['addAddress'];
  }

  String get deliveryDate {
    return localizedValues[locale.languageCode]['deliveryDate'];
  }

  String get cashOnDelivery {
    return localizedValues[locale.languageCode]['cashOnDelivery'];
  }

  String get payByCard {
    return localizedValues[locale.languageCode]['payByCard'];
  }

  String get cardNumber {
    return localizedValues[locale.languageCode]['cardNumber'];
  }

  String get addCard {
    return localizedValues[locale.languageCode]['addCard'];
  }

  String get rateProduct {
    return localizedValues[locale.languageCode]['rateProduct'];
  }

  String get orderDetails {
    return localizedValues[locale.languageCode]['orderDetails'];
  }

  String get typeQuestion {
    return localizedValues[locale.languageCode]['typeQuestion'];
  }

  String get cardHolderName {
    return localizedValues[locale.languageCode]['cardHolderName'];
  }

  String get cvvShouldBe {
    return localizedValues[locale.languageCode]['cvvShouldBe'];
  }

  String get register {
    return localizedValues[locale.languageCode]['register'];
  }

  String get address {
    return localizedValues[locale.languageCode]['address'];
  }

  String get selectPaymentMethod {
    return localizedValues[locale.languageCode]['selectPaymentMethod'];
  }

  String get home {
    return localizedValues[locale.languageCode]['home'];
  }

  String get myOrders {
    return localizedValues[locale.languageCode]['myOrders'];
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

  String get fullName {
    return localizedValues[locale.languageCode]['fullName'];
  }

  String get postalCode {
    return localizedValues[locale.languageCode]['postalCode'];
  }

  String get save {
    return localizedValues[locale.languageCode]['save'];
  }

  String get password {
    return localizedValues[locale.languageCode]['password'];
  }

  String get verifyOtp {
    return localizedValues[locale.languageCode]['verifyOtp'];
  }

  String get status {
    return localizedValues[locale.languageCode]['status'];
  }

  String get view {
    return localizedValues[locale.languageCode]['view'];
  }

  String get total {
    return localizedValues[locale.languageCode]['total'];
  }

  String get goToCart {
    return localizedValues[locale.languageCode]['goToCart'];
  }

  String get location {
    return localizedValues[locale.languageCode]['location'];
  }

  String get size {
    return localizedValues[locale.languageCode]['size'];
  }

  String get add {
    return localizedValues[locale.languageCode]['add'];
  }

  String get date {
    return localizedValues[locale.languageCode]['date'];
  }

  String get contactInformation {
    return localizedValues[locale.languageCode]['contactInformation'];
  }

  String get addressInformation {
    return localizedValues[locale.languageCode]['addressInformation'];
  }

  String get orderPlaced {
    return localizedValues[locale.languageCode]['orderPlaced'];
  }

  String get submit {
    return localizedValues[locale.languageCode]['submit'];
  }

  String get writeReview {
    return localizedValues[locale.languageCode]['writeReview'];
  }

  String get item {
    return localizedValues[locale.languageCode]['item'];
  }

  String get orderID {
    return localizedValues[locale.languageCode]['orderID'];
  }

  String get success {
    return localizedValues[locale.languageCode]['success'];
  }

  String get ok {
    return localizedValues[locale.languageCode]['ok'];
  }

  String get creditCardNumber {
    return localizedValues[locale.languageCode]['creditCardNumber'];
  }

  String get cvv {
    return localizedValues[locale.languageCode]['cvv'];
  }

  String get time {
    return localizedValues[locale.languageCode]['time'];
  }

  String get somethingwentwrongpleaserestarttheapp {
    return localizedValues[locale.languageCode]
        ['somethingwentwrongpleaserestarttheapp'];
  }

  String get description {
    return localizedValues[locale.languageCode]['description'];
  }

  String get clearcart {
    return localizedValues[locale.languageCode]['clearcart'];
  }

  String get houseFlatBlocknumber {
    return localizedValues[locale.languageCode]['houseFlatBlocknumber'];
  }

  String get apartmentName {
    return localizedValues[locale.languageCode]['apartmentName'];
  }

  String get pleaseenterapartmentname {
    return localizedValues[locale.languageCode]['pleaseenterapartmentname'];
  }

  String get pleaseenterhouseflatblocknumber {
    return localizedValues[locale.languageCode]
        ['pleaseenterhouseflatblocknumber'];
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

  String get contactNumber {
    return localizedValues[locale.languageCode]['contactNumber'];
  }

  String get pleaseentercontactnumber {
    return localizedValues[locale.languageCode]['pleaseentercontactnumber'];
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

  String get amountshouldbegreterthenorequalminamount {
    return localizedValues[locale.languageCode]
        ['amountshouldbegreterthenorequalminamount'];
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  Map localizedValues;
  MyLocalizationsDelegate(this.localizedValues);

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(
        MyLocalizations(locale, localizedValues));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
