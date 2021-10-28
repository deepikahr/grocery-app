import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readymadeGroceryApp/screens/drawer/enterLocation.dart';
import 'package:readymadeGroceryApp/service/locationService.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

class AddressPickPage extends StatefulWidget {
  final LatLng? initialLocation;
  final Map? localizedValues;
  final String? locale;
  const AddressPickPage(
      {Key? key, this.initialLocation, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _AddressPickPageState createState() => _AddressPickPageState();
}

class _AddressPickPageState extends State<AddressPickPage> {
  LatLng? initialLocation;
  TextEditingController addressController = TextEditingController();
  late GoogleMapController _controller;
  final locationUtils = LocationUtils();
  @override
  void initState() {
    setState(() {
      initialLocation = widget.initialLocation;
    });
    initializeLocation();
    super.initState();
  }

  Future<void> initializeLocation() async {
    if (initialLocation != null) {
      final address = await locationUtils.getAddressFromLatLng(initialLocation);
      setState(() {
        addressController.text = address.formattedAddress!;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bg(context),
        body: addressController.text.isNotEmpty
            ? Stack(children: [
                Column(children: [
                  Expanded(
                    child: Container(
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(initialLocation!.latitude,
                              initialLocation!.longitude),
                          zoom: 13.5,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('0'),
                            icon: BitmapDescriptor.defaultMarker,
                            position: LatLng(initialLocation!.latitude,
                                initialLocation!.longitude),
                          )
                        },
                        onMapCreated: (controller) async {
                          _controller = controller;
                        },
                        onTap: (coordinates) {
                          _controller.animateCamera(
                              CameraUpdate.newLatLng(coordinates));
                          setState(() {
                            initialLocation = coordinates;
                            initializeLocation();
                          });
                        },
                      ),
                    ),
                  ),
                  GFListTile(
                    title: Text(
                      addressController.text,
                      style: textBarlowRegularBlack(context),
                    ),
                    icon: InkWell(
                      onTap: () {
                        Navigator.of(context).pop({
                          'address': addressController.text,
                          'location': initialLocation
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: primary(context), shape: BoxShape.circle),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(Icons.send, color: dark(context)),
                        ),
                      ),
                    ),
                  ),
                ]),
                Positioned(
                  top: 30,
                  left: 20,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.black26,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 20,
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnterLocationPage(
                            locale: widget.locale,
                            localizedValues: widget.localizedValues,
                          ),
                        ),
                      ).then((value) {
                        if (value != null) {
                          Navigator.of(context)
                              .pop({'initialLocation': value['location']});
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: primary(context), shape: BoxShape.circle),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.search, color: dark(context)),
                      ),
                    ),
                  ),
                ),
              ])
            : SquareLoader(),
      ),
    );
  }
}
