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

  String get limitedquantityavailableyoucantaddmorethan {
    return localizedValues[locale.languageCode]
            ['limitedquantityavailableyoucantaddmorethan'] ??
        "Limited quantity available you can't add more than";
  }

  String get ofthisitem {
    return localizedValues[locale.languageCode]['ofthisitem'] ?? "of this item";
  }

  String get quantity {
    return localizedValues[locale.languageCode]['quantity'] ?? "Quantity";
  }

  String get items {
    return localizedValues[locale.languageCode]['items'] ?? "Items";
  }

  String get ok {
    return localizedValues[locale.languageCode]['ok'] ?? "OK";
  }

  String get forgotPassword {
    return localizedValues[locale.languageCode]['forgotPassword'] ??
        "Forgot Password";
  }

  String get passwordreset {
    return localizedValues[locale.languageCode]['passwordreset'] ??
        "Password Reset";
  }

  String get pleaseenteryourregisteredEmailtosendtheresetcode {
    return localizedValues[locale.languageCode]
            ['pleaseenteryourregisteredEmailtosendtheresetcode'] ??
        "Please enter your registered Email to send the reset code";
  }

  String get email {
    return localizedValues[locale.languageCode]['email'] ?? "Email";
  }

  String get enterYourEmail {
    return localizedValues[locale.languageCode]['enterYourEmail'] ??
        "Enter Your Email";
  }

  String get pleaseEnterValidEmail {
    return localizedValues[locale.languageCode]['pleaseEnterValidEmail'] ??
        "Please Enter Valid Email";
  }

  String get submit {
    return localizedValues[locale.languageCode]['submit'] ?? "Submit";
  }

  String get addToCart {
    return localizedValues[locale.languageCode]['addToCart'] ?? "Add To Cart";
  }

  String get invalidUser {
    return localizedValues[locale.languageCode]['invalidUser'] ??
        "Invalid User";
  }

  String get login {
    return localizedValues[locale.languageCode]['login'] ?? "Login";
  }

  String get welcomeBack {
    return localizedValues[locale.languageCode]['welcomeBack'] ??
        "Welcome Back";
  }

  String get password {
    return localizedValues[locale.languageCode]['password'] ?? "Password";
  }

  String get enterPassword {
    return localizedValues[locale.languageCode]['enterPassword'] ??
        "Enter Password";
  }

  String get pleaseEnterMin6DigitPassword {
    return localizedValues[locale.languageCode]
            ['pleaseEnterMin6DigitPassword'] ??
        "Please Enter Min 6 Digit Password";
  }

  String get or {
    return localizedValues[locale.languageCode]['or'] ?? "OR";
  }

  String get registerWithQuasMarks {
    return localizedValues[locale.languageCode]['registerWithQuasMarks'] ??
        "Register?";
  }

  String get forgotPasswordWithQuasMarks {
    return localizedValues[locale.languageCode]
            ['forgotPasswordWithQuasMarks'] ??
        "Forgot Password?";
  }

  String get pleaseEnter4DigitOTP {
    return localizedValues[locale.languageCode]['pleaseEnter4DigitOTP'] ??
        "Please Enter 4 Digit OTP";
  }

  String get error {
    return localizedValues[locale.languageCode]['error'] ?? "Error";
  }

  String get welcome {
    return localizedValues[locale.languageCode]['welcome'] ?? "Welcome";
  }

  String get verifyOtp {
    return localizedValues[locale.languageCode]['verifyOtp'] ?? "Verify Otp";
  }

  String get wehavesenta4digitcodeto {
    return localizedValues[locale.languageCode]['wehavesenta4digitcodeto'] ??
        "We have sent a 4 digit code to";
  }

  String get enterVerificationcode {
    return localizedValues[locale.languageCode]['enterVerificationcode'] ??
        "Enter Verification code";
  }

  String get submitOTP {
    return localizedValues[locale.languageCode]['submitOTP'] ?? "Submit OTP";
  }

  String get enternewpassword {
    return localizedValues[locale.languageCode]['enternewpassword'] ??
        "Enter new password";
  }

  String get reenternewpassword {
    return localizedValues[locale.languageCode]['reenternewpassword'] ??
        "Re-enter new password";
  }

  String get passwordsdonotmatch {
    return localizedValues[locale.languageCode]['passwordsdonotmatch'] ??
        "Passwords do not match";
  }

  String get oops {
    return localizedValues[locale.languageCode]['oops'] ?? "OOPS";
  }

  String get outOfStock {
    return localizedValues[locale.languageCode]['outOfStock'] ?? "Out Of Stock";
  }

  String get orderPlaced {
    return localizedValues[locale.languageCode]['orderPlaced'] ??
        "Order Placed ...!!";
  }

  String get thankYou {
    return localizedValues[locale.languageCode]['thankYou'] ??
        "Thank You .... !!";
  }

  String get backToHome {
    return localizedValues[locale.languageCode]['backToHome'] ?? "Back To Home";
  }

  String get signUp {
    return localizedValues[locale.languageCode]['signUp'] ?? "Sign Up";
  }

  String get letsgetstarted {
    return localizedValues[locale.languageCode]['letsgetstarted'] ??
        "Let's get started";
  }

  String get fullName {
    return localizedValues[locale.languageCode]['fullName'] ?? "Full Name";
  }

  String get enterFullName {
    return localizedValues[locale.languageCode]['enterFullName'] ??
        "Enter Full Name";
  }

  String get pleaseEnterValidFullName {
    return localizedValues[locale.languageCode]['pleaseEnterValidFullName'] ??
        "Please Enter Valid Full Name";
  }

  String get contactNumber {
    return localizedValues[locale.languageCode]['contactNumber'] ??
        "Contact Number";
  }

  String get enterYourContactNumber {
    return localizedValues[locale.languageCode]['enterYourContactNumber'] ??
        "Enter Your Contact Number";
  }

  String get havegotanaccount {
    return localizedValues[locale.languageCode]['havegotanaccount'] ??
        "Have got an account?";
  }

  String get allCategories {
    return localizedValues[locale.languageCode]['allCategories'] ??
        "All Categories";
  }

  String get add {
    return localizedValues[locale.languageCode]['add'] ?? "Add";
  }

  String get off {
    return localizedValues[locale.languageCode]['off'] ?? "OFF";
  }

  String get goToCart {
    return localizedValues[locale.languageCode]['goToCart'] ?? "Go To Cart";
  }

  String get pleaseselectaddressfirst {
    return localizedValues[locale.languageCode]['pleaseselectaddressfirst'] ??
        "Please select address first";
  }

  String get pleaseselecttimeslotfirst {
    return localizedValues[locale.languageCode]['pleaseselecttimeslotfirst'] ??
        "Please select time slot first";
  }

  String get checkout {
    return localizedValues[locale.languageCode]['checkout'] ?? "Checkout";
  }

  String get cartsummary {
    return localizedValues[locale.languageCode]['cartsummary'] ??
        "Cart Summary";
  }

  String get subTotal {
    return localizedValues[locale.languageCode]['subTotal'] ?? "Sub Total";
  }

  String get tax {
    return localizedValues[locale.languageCode]['tax'] ?? "TAX";
  }

  String get couponApplied {
    return localizedValues[locale.languageCode]['couponApplied'] ??
        "Coupon Applied";
  }

  String get discount {
    return localizedValues[locale.languageCode]['discount'] ?? "Discount";
  }

  String get enterCouponCode {
    return localizedValues[locale.languageCode]['enterCouponCode'] ??
        "Enter Coupon Code";
  }

  String get apply {
    return localizedValues[locale.languageCode]['apply'] ?? "APPLY";
  }

  String get deliveryCharges {
    return localizedValues[locale.languageCode]['deliveryCharges'] ??
        "Delivery Charges";
  }

  String get free {
    return localizedValues[locale.languageCode]['free'] ?? "FREE";
  }

  String get total {
    return localizedValues[locale.languageCode]['total'] ?? "Total";
  }

  String get deliveryAddress {
    return localizedValues[locale.languageCode]['deliveryAddress'] ??
        "Delivery Address";
  }

  String get youhavenotselectedanyaddressyet {
    return localizedValues[locale.languageCode]
            ['youhavenotselectedanyaddressyet'] ??
        "You have not selected any address yet?";
  }

  String get edit {
    return localizedValues[locale.languageCode]['edit'] ?? "EDIT";
  }

  String get delete {
    return localizedValues[locale.languageCode]['delete'] ?? "DELETE";
  }

  String get enableTogetlocation {
    return localizedValues[locale.languageCode]['enableTogetlocation'] ??
        "Enable To get location!";
  }

  String get thereisproblemusingyourdevicelocationPleasecheckyourGPSsettings {
    return localizedValues[locale.languageCode][
            'thereisproblemusingyourdevicelocationPleasecheckyourGPSsettings'] ??
        "There is problem using your device location. Please check your GPS settings";
  }

  String get addNewAddress {
    return localizedValues[locale.languageCode]['addNewAddress'] ??
        "Add New Address";
  }

  String get sorryNoSlotsAvailableToday {
    return localizedValues[locale.languageCode]['sorryNoSlotsAvailableToday'] ??
        "Sorry, No Slots Available Today..!!";
  }

  String get proceed {
    return localizedValues[locale.languageCode]['proceed'] ?? "Proceed";
  }

  String get chooseDeliveryDateandTimeSlot {
    return localizedValues[locale.languageCode]
            ['chooseDeliveryDateandTimeSlot'] ??
        "Choose Delivery Date and Time Slot";
  }

  String get aboutUs {
    return localizedValues[locale.languageCode]['aboutUs'] ?? "About Us";
  }

  String get description {
    return localizedValues[locale.languageCode]['description'] ?? "Description";
  }

  String get address {
    return localizedValues[locale.languageCode]['address'] ?? "Address";
  }

  String get contactInformation {
    return localizedValues[locale.languageCode]['contactInformation'] ??
        "Contact Information";
  }

  String get callUs {
    return localizedValues[locale.languageCode]['callUs'] ?? "Call Us";
  }

  String get mailUs {
    return localizedValues[locale.languageCode]['mailUs'] ?? "Mail Us";
  }

  String get location {
    return localizedValues[locale.languageCode]['location'] ?? "Location :";
  }

  String get houseFlatBlocknumber {
    return localizedValues[locale.languageCode]['houseFlatBlocknumber'] ??
        "House/Flat/Block number";
  }

  String get pleaseenterhouseflatblocknumber {
    return localizedValues[locale.languageCode]
            ['pleaseenterhouseflatblocknumber'] ??
        "Please enter House/Flat/Block number";
  }

  String get apartmentName {
    return localizedValues[locale.languageCode]['apartmentName'] ??
        "Apartment Name";
  }

  String get pleaseenterapartmentname {
    return localizedValues[locale.languageCode]['pleaseenterapartmentname'] ??
        "Please enter apartment name";
  }

  String get landMark {
    return localizedValues[locale.languageCode]['landMark'] ?? "Landmark";
  }

  String get pleaseenterlandmark {
    return localizedValues[locale.languageCode]['pleaseenterlandmark'] ??
        "Please enter landmark";
  }

  String get postalCode {
    return localizedValues[locale.languageCode]['postalCode'] ?? "Postal Code";
  }

  String get pleaseenterpostalcode {
    return localizedValues[locale.languageCode]['pleaseenterpostalcode'] ??
        "Please enter postal code";
  }

  String get pleaseentercontactnumber {
    return localizedValues[locale.languageCode]['pleaseentercontactnumber'] ??
        "Please enter contact number";
  }

  String get addressType {
    return localizedValues[locale.languageCode]['addressType'] ??
        "Saved Address";
  }

  String get save {
    return localizedValues[locale.languageCode]['save'] ?? "Save";
  }

  String get savedAddress {
    return localizedValues[locale.languageCode]['savedAddress'] ??
        "Saved Address";
  }

  String get somethingwentwrongpleaserestarttheapp {
    return localizedValues[locale.languageCode]
            ['somethingwentwrongpleaserestarttheapp'] ??
        "Something went wrong please restart the app";
  }

  String get no {
    return localizedValues[locale.languageCode]['no'] ?? "NO";
  }

  String get yes {
    return localizedValues[locale.languageCode]['yes'] ?? "YES";
  }

  String get areyousureclosechat {
    return localizedValues[locale.languageCode]['areyousureclosechat'] ??
        "Are you sure? close chat";
  }

  String get chat {
    return localizedValues[locale.languageCode]['chat'] ?? "Chat";
  }

  String get enterTextHere {
    return localizedValues[locale.languageCode]['enterTextHere'] ??
        " Enter Text Here...";
  }

  String get products {
    return localizedValues[locale.languageCode]['products'] ?? "Products";
  }

  String get home {
    return localizedValues[locale.languageCode]['home'] ?? "Home";
  }

  String get profile {
    return localizedValues[locale.languageCode]['profile'] ?? "Profile";
  }

  String get savedItems {
    return localizedValues[locale.languageCode]['savedItems'] ?? "Saved Items";
  }

  String get logout {
    return localizedValues[locale.languageCode]['logout'] ?? "Logout";
  }

  String get editAddress {
    return localizedValues[locale.languageCode]['editAddress'] ??
        "Edit Address";
  }

  String get updateAddress {
    return localizedValues[locale.languageCode]['updateAddress'] ??
        "Update Address";
  }

  String get update {
    return localizedValues[locale.languageCode]['update'] ?? "Update";
  }

  String get yourLocation {
    return localizedValues[locale.languageCode]['yourLocation'] ??
        "Your Location :";
  }

  String get store {
    return localizedValues[locale.languageCode]['store'] ?? "Store";
  }

  String get myCart {
    return localizedValues[locale.languageCode]['myCart'] ?? "My Cart";
  }

  String get rateProduct {
    return localizedValues[locale.languageCode]['rateProduct'] ??
        "Rate Product";
  }

  String get myOrders {
    return localizedValues[locale.languageCode]['myOrders'] ?? "My Orders";
  }

  String get and {
    return localizedValues[locale.languageCode]['and'] ?? "and";
  }

  String get moreitems {
    return localizedValues[locale.languageCode]['moreitems'] ?? "more items";
  }

  String get ordered {
    return localizedValues[locale.languageCode]['ordered'] ?? "Ordered";
  }

  String get orderConfirmed {
    return localizedValues[locale.languageCode]['orderConfirmed'] ??
        "Order Confirmed";
  }

  String get outfordelivery {
    return localizedValues[locale.languageCode]['outfordelivery'] ??
        "Out for delivery";
  }

  String get orderdelivered {
    return localizedValues[locale.languageCode]['orderdelivered'] ??
        "Order Delivered";
  }

  String get reorder {
    return localizedValues[locale.languageCode]['reorder'] ?? "Re-order";
  }

  String get view {
    return localizedValues[locale.languageCode]['view'] ?? "View";
  }

  String get orderDetails {
    return localizedValues[locale.languageCode]['orderDetails'] ??
        "Order Details";
  }

  String get orderID {
    return localizedValues[locale.languageCode]['orderID'] ?? "Order ID";
  }

  String get date {
    return localizedValues[locale.languageCode]['date'] ?? "Date";
  }

  String get deliveryDate {
    return localizedValues[locale.languageCode]['deliveryDate'] ??
        "Delivery Date";
  }

  String get time {
    return localizedValues[locale.languageCode]['time'] ?? "Time";
  }

  String get paymentType {
    return localizedValues[locale.languageCode]['paymentType'] ??
        "Payment Type";
  }

  String get paymentstatus {
    return localizedValues[locale.languageCode]['paymentstatus'] ??
        "Payment Status";
  }

  String get orderStatus {
    return localizedValues[locale.languageCode]['orderStatus'] ??
        "Order Status";
  }

  String get rateNow {
    return localizedValues[locale.languageCode]['rateNow'] ?? "Rate Now";
  }

  String get grandTotal {
    return localizedValues[locale.languageCode]['grandTotal'] ?? "Grand Total";
  }

  String get selectPaymentOption {
    return localizedValues[locale.languageCode]['selectPaymentOption'] ??
        "Select Payment Option";
  }

  String get cancel {
    return localizedValues[locale.languageCode]['cancel'] ?? "Cancel";
  }

  String get remove {
    return localizedValues[locale.languageCode]['remove'] ?? "Remove";
  }

  String get payment {
    return localizedValues[locale.languageCode]['payment'] ?? "Payment";
  }

  String get cashOnDelivery {
    return localizedValues[locale.languageCode]['cashOnDelivery'] ??
        "Cash On Delivery";
  }

  String get payByCard {
    return localizedValues[locale.languageCode]['payByCard'] ?? "Pay By Card";
  }

  String get payNow {
    return localizedValues[locale.languageCode]['payNow'] ?? "Pay Now";
  }

  String get select {
    return localizedValues[locale.languageCode]['select'] ?? "Select";
  }

  String get takePhoto {
    return localizedValues[locale.languageCode]['takePhoto'] ?? "Take Photo";
  }

  String get chooseFromPhotos {
    return localizedValues[locale.languageCode]['chooseFromPhotos'] ??
        "Choose From Photos";
  }

  String get removePhoto {
    return localizedValues[locale.languageCode]['removePhoto'] ??
        "Remove Photo";
  }

  String get editProfile {
    return localizedValues[locale.languageCode]['editProfile'] ??
        "Edit Profile";
  }

  String get yourCartIsEmpty {
    return localizedValues[locale.languageCode]['yourCartIsEmpty'] ??
        "Your Cart Is Empty";
  }

  String get addSomeItemsToProceedToCheckout {
    return localizedValues[locale.languageCode]
            ['addSomeItemsToProceedToCheckout'] ??
        "Add Some Items To Proceed To Checkout";
  }

  String get amountshouldbegreterthenorequalminamount {
    return localizedValues[locale.languageCode]
            ['amountshouldbegreterthenorequalminamount'] ??
        "Amount should be greter then or equal min amount";
  }

  String get item {
    return localizedValues[locale.languageCode]['item'] ?? "Item";
  }

  String get clearCart {
    return localizedValues[locale.languageCode]['clearCart'] ?? "Clear Cart";
  }

  String get deal {
    return localizedValues[locale.languageCode]['deal'] ?? "Deal";
  }

  String get selectLanguage {
    return localizedValues[locale.languageCode]['selectLanguage'] ??
        "Select Language";
  }

  String get orderHistory {
    return localizedValues[locale.languageCode]['orderHistory'] ??
        "Order History";
  }

  String get whatareyoubuyingtoday {
    return localizedValues[locale.languageCode]['whatareyoubuyingtoday'] ??
        "What are you buying today?";
  }

  String get typeToSearch {
    return localizedValues[locale.languageCode]['typeToSearch'] ??
        "Type To Search";
  }

  String get itemsFounds {
    return localizedValues[locale.languageCode]['itemsFounds'] ??
        "Items Founds";
  }

  String get noResultsFound {
    return localizedValues[locale.languageCode]['noResultsFound'] ??
        "No Results Found";
  }

  String get explorebyCategories {
    return localizedValues[locale.languageCode]['explorebyCategories'] ??
        "Explore by Categories";
  }

  String get viewAll {
    return localizedValues[locale.languageCode]['viewAll'] ?? "view All";
  }

  String get ordernow {
    return localizedValues[locale.languageCode]['ordernow'] ?? "Order Now";
  }

  String get topDeals {
    return localizedValues[locale.languageCode]['topDeals'] ?? "Top Deals";
  }

  String get dealsoftheday {
    return localizedValues[locale.languageCode]['dealsoftheday'] ??
        "Deals of the day";
  }

  String get chatDetail {
    return localizedValues[locale.languageCode]['chatDetail'] ?? "Chat Detail";
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
