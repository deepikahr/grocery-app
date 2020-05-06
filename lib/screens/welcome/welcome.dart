// import 'package:flutter/material.dart';
// import 'package:readymadeGroceryApp/style/style.dart';

// class WelcomePage extends StatefulWidget {
//   @override
//   _WelcomePageState createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primary,
//       bottomNavigationBar: Container(
//         color: Color(0xFF394047),
//         height: 310.0,
//         child: Column(
//           children: <Widget>[
//             Text('Welcome !', style: hintSfLightprimary()),
//             Container(
//               margin: EdgeInsets.only(bottom: 20.0, top: 40.0),
//               width: screenWidth(context) * 0.65,
//               height: 48.5,
//               decoration: BoxDecoration(
//                   color: primary, borderRadius: BorderRadius.circular(1.81)),
//               child: RawMaterialButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (BuildContext context) => Login()),
//                   );
//                 },
//                 child: Text("Login"),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(bottom: 20.0, top: 40.0),
//               width: screenWidth(context) * 0.65,
//               height: 48.5,
//               decoration: BoxDecoration(
//                   color: primary, borderRadius: BorderRadius.circular(1.81)),
//               child: RawMaterialButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (BuildContext context) => Signup()),
//                     );
//                   },
//                   child: Text('Sign Up')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
