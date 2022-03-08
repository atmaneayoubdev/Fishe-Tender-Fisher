import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel extends StatefulWidget {
  final LatLng initpos;

  const LocationModel({Key? key, required this.initpos}) : super(key: key);
  @override
  _LocationModelState createState() => _LocationModelState();
}

class _LocationModelState extends State<LocationModel> {
  String _currentLocation = '';
  String _currentLat = '';
  String _curentLon = '';
  String _currentCity = '';
  BitmapDescriptor? pinLocationIcon;
  Uint8List? markerIcon;
  List<Marker> _markers = [];
  late GoogleMapController mapController;
  List<Placemark> placemarks = [];
  List<Placemark> placemarks2 = [];
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

  void _onCameraMoved(position) {
    if (mounted)
      setState(() {
        _markers.first =
            _markers.first.copyWith(positionParam: position.target);
      });
  }

  var isLoading = false;

  Future<void> _onCameraStoped() async {
    await placemarkFromCoordinates(
      _markers.first.position.latitude,
      _markers.first.position.longitude,
      localeIdentifier: "en",
    ).then((value) {
      if (mounted)
        setState(() {
          placemarks2 = value;
        });
    });
    await placemarkFromCoordinates(
      _markers.first.position.latitude,
      _markers.first.position.longitude,
      localeIdentifier: context.locale.toLanguageTag(),
    ).then((value) {
      if (mounted)
        setState(() {
          placemarks = value;
        });
    });
    if (placemarks.isNotEmpty) {
      if (mounted)
        setState(() {
          _currentCity = placemarks2.first.locality.toString();
          _currentLat = _markers.first.position.latitude.toString();
          _curentLon = _markers.first.position.longitude.toString();
          _currentLocation =
              ' ${placemarks.first.locality}, ${placemarks.first.administrativeArea},${placemarks.first.subLocality}, ${placemarks.first.subAdministrativeArea},${placemarks.first.thoroughfare}, ${placemarks.first.subThoroughfare}';
        });
    }
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    //getLoc();
    Future.delayed(Duration.zero, () async {
      markerIcon = await getBytesFromAsset('assets/icons/pin.png', 50);
    }).then((value) {
      if (mounted)
        setState(() {
          pinLocationIcon = BitmapDescriptor.fromBytes(markerIcon!);
        });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _markers.add(Marker(
      icon: pinLocationIcon!,
      markerId: MarkerId("0"),
      position: widget.initpos,
    ));
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.initpos,
          zoom: widget.initpos == LatLng(24.745794, 46.659102) ? 10 : 15,
          tilt: 90.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      child: Container(
        height: 619.h,
        color: kprimaryLightColor,
        child: Stack(
          children: [
            Container(
              //height: 425.h,
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: _onMapCreated,
                //onCameraIdle: _onCameraStoped,
                onCameraMove: _onCameraMoved,
                initialCameraPosition: CameraPosition(
                  target: widget.initpos,
                  zoom: 5.0,
                  tilt: 90.0,
                ),
                markers: Set<Marker>.of(_markers),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: isLoading
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          _onCameraStoped().then((value) {
                            if (_currentCity == "" || _currentCity.isEmpty) {
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: false,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return SnackabrDialog(
                                      status: placemarks.isEmpty
                                          ? false
                                          : placemarks.first.country != "SA"
                                              ? true
                                              : false,
                                      message: placemarks.isEmpty
                                          ? LocaleKeys.select_valide_address
                                              .tr()
                                          : placemarks.first.country != "SA"
                                              ? LocaleKeys.area_not_supported
                                                  .tr()
                                              : LocaleKeys.select_valide_address
                                                  .tr(),
                                      onPopFunction: () {
                                        Navigator.pop(context);
                                      });
                                },
                              );
                            } else if (placemarks.first.isoCountryCode !=
                                    "SA" ||
                                placemarks.isEmpty) {
                              print(placemarks.first.isoCountryCode);
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: false,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return SnackabrDialog(
                                      status: placemarks.isEmpty
                                          ? false
                                          : placemarks.first.country != "SA"
                                              ? true
                                              : false,
                                      message: placemarks.isEmpty
                                          ? LocaleKeys.select_valide_address
                                              .tr()
                                          : placemarks.first.country != "SA"
                                              ? LocaleKeys.area_not_supported
                                                  .tr()
                                              : LocaleKeys.select_valide_address
                                                  .tr(),
                                      onPopFunction: () {
                                        Navigator.pop(context);
                                      });
                                },
                              );
                            } else {
                              Navigator.pop(context, {
                                'address': _currentLocation,
                                'lat': _currentLat,
                                'lon': _curentLon,
                                'city': _currentCity,
                              });
                            }
                          });
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 100.w,
                            vertical: 10.h,
                          ),
                          child: BottomButton(
                            title: LocaleKeys.market_account_add_loc.tr(),
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
