import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:readymadeGroceryApp/service/locationService.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class EnterLocationPage extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;
  const EnterLocationPage({Key? key, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _EnterLocationPageState createState() => _EnterLocationPageState();
}

class _EnterLocationPageState extends State<EnterLocationPage> {
  List<Prediction> places = [];
  final locationUtils = LocationUtils();
  Timer? timer;
  Future<void> searchPlaces(String suggestion) async {
    if (suggestion.isEmpty) {
      setState(() {
        places = [];
      });
    }
    var result = await locationUtils.getSuggestions(suggestion);
    if (result.length > 10) {
      setState(() {
        result = result.sublist(0, 10);
      });
    }
    setState(() {
      places = result;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      appBar: appBarPrimary(context, "ENTER_LOCATION") as PreferredSizeWidget?,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: buildGFTypography(context, "ENTER_LOCATION", true, true),
          ),
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Color(0xFFF44242))),
                  errorStyle: TextStyle(color: Color(0xFFF44242)),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary(context))),
                ),
                onChanged: (String value) async {
                  if (timer?.isActive ?? false) timer!.cancel();
                  timer = Timer(Duration(milliseconds: 500), () {
                    places = [];
                    searchPlaces(value);
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 6),
          if (places.isNotEmpty)
            ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: places.length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      await locationUtils
                          .getLatLngFromPlaceId(places[index].placeId!)
                          .then((latlog) async {
                        Navigator.of(context).pop({
                          'location': {
                            "latitude": latlog!.lat,
                            "longitude": latlog.lng
                          }
                        });
                      });
                    },
                    child: locationTile(context, places[index].description!),
                  );
                }),
        ],
      ),
    );
  }
}
