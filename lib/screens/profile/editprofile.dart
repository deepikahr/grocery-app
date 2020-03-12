import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file/file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:image_cropper/image_cropper.dart';

SentryError sentryError = new SentryError();

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userInfo;
  Map<String, dynamic> userData;
  bool isLoading = false;
  bool isPicUploading = false;
  bool profileEdit = false;
  bool isGetTokenLoading = false;
  String name, lastName, contactNo;
  String profilePic;
  var filePath = new List<File>();
  var recentSize = 0;
  File image;

  @override
  void initState() {
    super.initState();
    getToken();
    getUserInfo();
  }

  getUserInfo() async {
    if (mounted) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
    }
    await LoginService.getUserInfo().then((onValue) {
      // print(onValue);
      try {
        if (mounted) {
          if (mounted)
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

  getToken() async {
    await Common.getToken().then((onValue) {
      // print('Token at the edit profile');
      // print(onValue);
      if (onValue != null) {
        setState(() {
          isGetTokenLoading = true;
        });
      } else {
        setState(() {
          isGetTokenLoading = false;
        });
      }
      // checkToken(onValue);
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  // updateUserInfo(url, key) async {
  //   final FormState form = _formKey.currentState;
  //   if (mounted) {
  //     if (mounted)
  //       setState(() {
  //         name = name == null ? userData['firstName'] : name;
  //         lastName = lastName == null ? userData['lastName'] : lastName;
  //         contactNo = contactNo == null ? userData['mobileNumber'] : contactNo;
  //       });
  //   }

  //   if (!form.validate()) {
  //     return;
  //   } else {
  //     form.save();
  //     if (mounted) {
  //       if (mounted)
  //         setState(() {
  //           isLoading = true;
  //         });
  //     }

  //     Map<String, dynamic> body = {
  //       "firstName": name,
  //       "lastName": lastName,
  //       "mobileNumber": contactNo,
  //       "role": "User",
  //       "profilePic": profilePic,
  //     };
  //     if (url != null) {
  //       body['profilePic'] = url;
  //       body['profilePicId'] = key;
  //     } else {
  //       body['profilePic'] = url;
  //       body['profilePicId'] = key;
  //     }
  //     await LoginService.updateUserInfo(body).then((onValue) {
  //       try {
  //         getUserInfo();
  //         // Toast.show("${onValue['response_data']}", context,
  //         //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //         if (mounted) {
  //           if (mounted)
  //             setState(() {
  //               isLoading = false;
  //             });
  //           if (mounted)
  //             setState(() {
  //               profileEdit = false;
  //             });
  //         }
  //       } catch (error, stackTrace) {
  //         sentryError.reportError(error, stackTrace);
  //       }
  //       // Navigator.of(context).pop();
  //     }).catchError((error) {
  //       sentryError.reportError(error, null);
  //     });
  //   }
  // }

  // getFile() async {
  //   try {
  //     filePath = await FilePicker.getMultiFile();

  //     filePath.forEach((file) async {
  //       var size = await file.absolute.length();
  //       recentSize = recentSize + size;
  //     });
  //   } catch (e) {
  //     print('File not selected');
  //     // _widgetsCollection.showToastMessage("File Not selected");
  //   }
  // }

  // galleryImage() async {
  //   image = await ImagePicker.pickImage(source: ImageSource.camera);
  //   if (image != null) cropImage();
  //   setState(() {});
  // }

  // cropImage() async {
  //   image = await ImageCropper.cropImage(
  //     sourcePath: image.path,
  //     maxWidth: 512,
  //     maxHeight: 512,
  //   );

  //   var size = await image.absolute.length();
  //   recentSize = recentSize + size;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            child: Stack(
              children: <Widget>[
                Center(
                  child: new Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: new BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(20.0),
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  "https://i.imgur.com/BoN9kdC.png")))),
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
                    child: Icon(Icons.camera_alt),
                    // Row(
                    //   children: <Widget>[
                    //     IconButton(
                    //       icon: Icon(
                    //         Icons.attach_file,
                    //         color: Colors.grey,
                    //       ),
                    //       onPressed: getFile,
                    //     ),
                    //     IconButton(
                    //       onPressed: galleryImage,
                    //       icon: Icon(Icons.camera_alt),
                    //     )
                    //   ],
                    // ),
                  ),
                )
              ],
            ),
          ),
          Center(child: Text('badguy@email.com')),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'First Name :',
              style: regular(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextFormField(
              // initialValue: "123456",
              style: labelStyle(),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
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
                  )),
              // style: textBlackOSR(),
              // obscureText: true,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'Last Name :',
              style: regular(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextFormField(
              // initialValue: "123456",
              style: labelStyle(),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
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
                  )),
              // style: textBlackOSR(),
              // obscureText: true,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'Phone Number :',
              style: regular(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextFormField(
              style: labelStyle(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
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
                  )),
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: GFButton(
            onPressed: () {},
            color: primary,
            text: 'Save',
            textColor: Colors.black,
            blockButton: true,
          ),
        ),
      ),
    );
  }
}
