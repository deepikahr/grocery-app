import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:image_picker/image_picker.dart';
import '../../service/constants.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:io';
import 'dart:ui';
import 'package:grocery_pro/widgets/loader.dart';

SentryError sentryError = new SentryError();

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  EditProfile({Key key, this.userInfo, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userInfo;

  bool isLoading = false,
      isPicUploading = false,
      profileEdit = false,
      isGetTokenLoading = false;
  String firstName, lastName, mobileNumber, profilePic;
  var filePath = new List<File>(), recentSize = 0;
  File imageFile;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await LoginService.getUserInfo().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            isLoading = false;
            userInfo = onValue['response_data']['userInfo'];
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  updateUserInfo(url, key) async {
    var body = {
      "profilePic": url,
      "profilePicId": key,
      "role": "User",
    };

    await LoginService.updateUserInfo(body).then((onValue) {
      try {
        if (mounted) {
          setState(() {
            isPicUploading = false;
          });
        }
        if (onValue['response_code'] == 200) {
          showSnackbar(onValue['response_data']);
          if (key == null) {
            getUserInfo();
          }
        } else {
          showSnackbar(onValue['response_data']);
        }
        if (onValue['response_code'] == 200) {}
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  updateUserInformation() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      return;
    } else {
      form.save();
      if (mounted) {
        setState(() {
          profileEdit = true;
        });
      }

      Map<String, dynamic> body = {
        "firstName": firstName,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "role": "User",
      };

      await LoginService.updateUserInfo(body).then((onValue) {
        try {
          if (mounted)
            setState(() {
              profileEdit = false;
            });
          if (onValue['response_code'] == 200) {
            showSnackbar(onValue['response_data']);
          } else {
            showSnackbar(onValue['response_data']);
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    }
  }

  var image;
  selectGallary() async {
    Navigator.pop(context);

    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        isPicUploading = true;
      });
    }
    imageUpload(image);
  }

  selectCamera() async {
    Navigator.pop(context);
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (mounted) {
      setState(() {
        isPicUploading = true;
      });
    }
    imageUpload(image);
  }

  imageUpload(_imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));

    int length = await _imageFile.length();
    String uri = Constants.baseURL + 'utils/upload/file/imagekit';

    dynamic request = new http.MultipartRequest("POST", Uri.parse(uri));

    dynamic multipartFile = new http.MultipartFile('file', stream, length,
        filename: path.basename(_imageFile.path));

    await request.files.add(multipartFile);
    String token;

    await Common.getToken().then((onValue) {
      token = onValue;
    }).catchError((error) {
      sentryError.reportError(error, null);
    });

    request.headers['Authorization'] = 'bearer $token';
    await request.send().then((response) async {
      await response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> data;
        data = json.decode(value);

        updateUserInfo(data['response_data'][1]['thumbImage']['url'],
            data['response_data'][1]['thumbImage']['key']);
      });
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  selectImage() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(
                new Radius.circular(24.0),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    MyLocalizations.of(context).select,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        decoration: TextDecoration.none),
                  ),
                ),
                GFButton(
                  onPressed: selectCamera,
                  type: GFButtonType.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).takePhoto,
                        style: hintSfboldBig(),
                      ),
                      Icon(Icons.camera_alt),
                    ],
                  ),
                ),
                GFButton(
                  onPressed: selectGallary,
                  type: GFButtonType.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).chooseFromPhotos,
                        style: hintSfboldBig(),
                      ),
                      Icon(Icons.image),
                    ],
                  ),
                ),
                userInfo['profilePic'] != null
                    ? GFButton(
                        onPressed: removeImage,
                        type: GFButtonType.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              MyLocalizations.of(context).removePhoto,
                              style: hintSfboldBig(),
                            ),
                            Icon(Icons.delete_forever),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ));
        });
  }

  removeImage() {
    if (mounted) {
      setState(() {
        isPicUploading = true;
      });
    }
    LoginService.imagedelete(userInfo['profilePicId'].toString()).then((value) {
      if (value['response_code'] == 200) {
        if (mounted) {
          setState(() {
            isPicUploading = false;

            Navigator.pop(context);

            updateUserInfo(null, null);
          });
        }
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        title: Text(
          MyLocalizations.of(context).editProfile,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? SquareLoader()
          : Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 250,
                    child: Stack(
                      children: <Widget>[
                        image == null
                            ? userInfo['profilePic'] == null
                                ? Center(
                                    child: new Container(
                                      width: 200.0,
                                      height: 200.0,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new AssetImage(
                                              'lib/assets/images/profile.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: new Container(
                                      width: 200.0,
                                      height: 200.0,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                              userInfo['profilePic']),
                                        ),
                                      ),
                                    ),
                                  )
                            : isPicUploading
                                ? SquareLoader()
                                : Center(
                                    child: new Container(
                                      width: 200.0,
                                      height: 200.0,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new FileImage(image),
                                        ),
                                      ),
                                    ),
                                  ),
                        Positioned(
                          left: 250,
                          top: 190,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: IconButton(
                              onPressed: () {
                                selectImage();
                              },
                              icon: Icon(Icons.camera_alt),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                      child: Text(
                    userInfo['email'],
                    style: textBarlowRegularBlack(),
                  )),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, bottom: 5.0, right: 18.0),
                    child: Text(
                      MyLocalizations.of(context).fullName + ':',
                      style: textbarlowRegularBlack(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: TextFormField(
                      initialValue: userInfo['firstName'] ?? "",
                      style: textBarlowRegularBlack(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Color(0xFFF44242))),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      onSaved: (String value) {
                        firstName = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return MyLocalizations.of(context).enterFullName;
                        } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                          return MyLocalizations.of(context)
                              .pleaseEnterValidFullName;
                        } else
                          return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, bottom: 5.0, right: 18.0),
                    child: Text(
                      MyLocalizations.of(context).contactNumber + ' :',
                      style: textbarlowRegularBlack(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: TextFormField(
                      initialValue: userInfo['mobileNumber'] ?? "",
                      style: textBarlowRegularBlack(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Color(0xFFF44242))),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      onSaved: (String value) {
                        mobileNumber = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return MyLocalizations.of(context)
                              .enterYourContactNumber;
                        } else if (value.length != 10) {
                          return MyLocalizations.of(context)
                              .pleaseenter10digitcontactnumber;
                        } else
                          return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        height: 55,
        margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 5)
        ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: GFButton(
            onPressed: updateUserInformation,
            color: primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  MyLocalizations.of(context).save,
                  style: textBarlowRegularrBlack(),
                ),
                profileEdit
                    ? Image.asset(
                        'lib/assets/images/spinner.gif',
                        width: 15.0,
                        height: 15.0,
                        color: Colors.black,
                      )
                    : Text("")
              ],
            ),
            textColor: Colors.black,
            blockButton: true,
          ),
        ),
      ),
    );
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
