import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

import 'otp.dart';

class FaceBookRegisterDetail extends StatefulWidget {
  final Map localizedValues;
  final String locale, accessToken;

  const FaceBookRegisterDetail(
      {Key key, this.localizedValues, this.locale, this.accessToken})
      : super(key: key);

  @override
  _FaceBookRegisterDetailState createState() => _FaceBookRegisterDetailState();
}

class _FaceBookRegisterDetailState extends State<FaceBookRegisterDetail> {
  String mobileNumber;

  bool isCuntryLoading = false;

  var selectedCountry;

  bool isUserLoaginLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getCuntry();
    super.initState();
  }

  getCuntry() {
    setState(() {
      isCuntryLoading = true;
    });
    Common.getCountryInfo().then((value) {
      setState(() {
        selectedCountry = Constants.countryCode[0];
        isCuntryLoading = false;
        if (value != null) {
          for (int i = 0; i < Constants.countryCode.length; i++) {
            if (Constants.countryCode[i]['code'].toString() ==
                value.toString()) {
              selectedCountry = Constants.countryCode[i];
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildMobileNumberText(),
              isCuntryLoading
                  ? Container()
                  : Form(
                      key: _formKey,
                      child: buildMobileNumberTextField(),
                    ),
              SizedBox(
                height: 40,
              ),
              buildLoginButton()
            ],
          ),
        ));
  }

  Widget buildMobileNumberText() {
    return buildGFTypography(context, "MOBILE_NUMBER", true, true);
  }

  Widget buildMobileNumberTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: TextFormField(
        maxLength: 15,
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty) {
            return MyLocalizations.of(context)
                .getLocalizations("ENTER_YOUR_MOBILE_NUMBER");
          } else
            return null;
        },
        onChanged: (String value) {
          if(mounted){
            setState(() {
              mobileNumber = value;
            });
          }
        },
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: () {
              _settingModalBottomSheet(context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 9),
              width: 100,
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey[300]))),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        "${selectedCountry['code'] ?? ""}${selectedCountry['dial_code'] ?? ""}",
                        overflow: TextOverflow.ellipsis,
                        style: textBarlowSemiboldPrimaryy()),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      size: 17, color: Colors.grey[400])
                ],
              ),
            ),
          ),
          counterText: "",
          prefixStyle: textBarlowRegularBlack(),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding:
              EdgeInsets.only(left: 25.0, right: 15.0, top: 10.0, bottom: 10.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return InkWell(
        onTap: () => validation(),
        child: buttonPrimary(context, "SUBMIT", isUserLoaginLoading));
  }

  void _settingModalBottomSheet(context) {
    var result = showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1.0,
                  ),
                ],
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                )),
            child: new ListView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: EdgeInsets.only(top: 25, left: 20),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      )),
                  child: Text(
                    MyLocalizations.of(context)
                        .getLocalizations('SELECT_YOUR_COUNTRY'),
                    style: textbarlowmediumwhitee(),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: Constants.countryCode.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pop(Constants.countryCode[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "(${Constants.countryCode[index]['dial_code'] ?? ""}) ${Constants.countryCode[index]['name'] ?? ""}",
                                style: textbarlowRegularadd(),
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          );
        });
    result.then((value) {
      if (value != null) {
        setState(() {
          selectedCountry = value;
        });
      }
    });
  }

  validation() async {
    if (_formKey.currentState.validate()) {
      if(mounted){
        setState(() {
          isUserLoaginLoading = true;
        });
      }
      await LoginService.facebookLoginMobile(
        accessToken: widget.accessToken,
              countryCode: selectedCountry['dial_code'],
              countryName: selectedCountry['name'],
              mobileNumber: mobileNumber)
          .then((onValue) {
        if(mounted){
          setState(() {
            isUserLoaginLoading = false;
          });
        }
        showDialog<Null>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return new AlertDialog(
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text(onValue['response_data'],
                        style: textBarlowRegularBlack()),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                      MyLocalizations.of(context).getLocalizations("OK"),
                      style: textbarlowRegularaPrimary()),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Otp(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          signUpTime: true,
                          mobileNumber: mobileNumber,
                          sId: onValue['sId'],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }).catchError((onError) {
        if(mounted){
          setState(() {
            isUserLoaginLoading = false;
          });
        }
      });
    } else {
      return;
    }
  }
}
