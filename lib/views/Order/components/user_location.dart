import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fishe_tender_fisher/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocations extends StatefulWidget {
  final LatLng latLng;

  const UserLocations({Key? key, required this.latLng}) : super(key: key);
  @override
  _UserLocationsState createState() => _UserLocationsState();
}

class _UserLocationsState extends State<UserLocations> {
  late GoogleMapController mapController;
  BitmapDescriptor? pinLocationIcon;
  Uint8List? markerIcon;
  List<Marker> _markers = [];
  final LatLng _initialcameraposition = const LatLng(24.745794, 46.659102);
  List<Placemark> placemarks = [];

  void _onMarkerTap(int id) {
    // Future.delayed(Duration.zero, () async {
    //   await placemarkFromCoordinates(
    //     _markers
    //         .firstWhere((element) => element.markerId.value == id.toString())
    //         .position
    //         .latitude,
    //     _markers
    //         .firstWhere((element) => element.markerId.value == id.toString())
    //         .position
    //         .longitude,
    //     localeIdentifier: context.locale.toLanguageTag(),
    //   ).then((value) {
    //     setState(() {
    //       _currentLocation =
    //           ' ${value.first.locality}, ${value.first.administrativeArea},${value.first.subLocality}, ${value.first.subAdministrativeArea},${value.first.thoroughfare}, ${value.first.subThoroughfare}';
    //       print(_currentLocation);
    //     });
    //   });
    // });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/icons/pin.png",
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.animateCamera(
      CameraUpdate.newLatLng(
        widget.latLng,
      ),
    );

    setState(() {
      _markers.add(
        Marker(
            icon: pinLocationIcon!,
            markerId: MarkerId("0"),
            position: widget.latLng,
            onTap: () {
              _onMarkerTap(0);
            }),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    Future.delayed(Duration.zero, () async {
      // setState(() {
      //   _markers.add(
      //     Marker(
      //         icon: pinLocationIcon!,
      //         markerId: MarkerId('0'),
      //         position: widget.latLng,
      //         onTap: () {
      //           _onMarkerTap(0);
      //         }),
      //   );
      // });
      markerIcon = await getBytesFromAsset('assets/icons/pin.png', 50);
    }).then((value) {
      setState(() {
        pinLocationIcon = BitmapDescriptor.fromBytes(
          markerIcon!,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 530.h,
        decoration: BoxDecoration(
          color: kprimaryLightColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                //height: 425.h,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialcameraposition,
                    zoom: 15,
                    tilt: 90.0,
                  ),
                  onMapCreated: _onMapCreated,
                  markers: Set<Marker>.of(_markers),
                ),
              ),
              // SizedBox(
              //   height: 24.h,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 19.w),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.location_on,
              //         color: kprimaryColor,
              //         size: 25.sp,
              //       ),
              //       SizedBox(
              //         width: 8.w,
              //       ),
              //       Text(
              //         LocaleKeys.market_account_current_location.tr(),
              //         style: GoogleFonts.getFont(
              //           'Tajawal',
              //           fontSize: 15.sp,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 8.h,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(
              //     horizontal: 50.w,
              //   ),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       _currentLocation,
              //       style: GoogleFonts.getFont(
              //         'Tajawal',
              //         fontSize: 14.sp,
              //         fontWeight: FontWeight.w600,
              //         color: ksecondaryTextColor,
              //       ),
              //       overflow: TextOverflow.clip,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 24.h,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //       margin: EdgeInsets.symmetric(horizontal: 19.w),
              //       child: BottomButton(
              //           title: LocaleKeys.market_account_add_loc.tr())),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
