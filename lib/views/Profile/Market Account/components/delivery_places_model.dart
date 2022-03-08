import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fishe_tender_fisher/models/city/city_model.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryPlacesModel extends StatefulWidget {
  const DeliveryPlacesModel(
      {Key? key, required this.startWorkTime, required this.endWorkTie})
      : super(key: key);
  final String startWorkTime;
  final String endWorkTie;
  @override
  _DeliveryPlacesModelState createState() => _DeliveryPlacesModelState();
}

class _DeliveryPlacesModelState extends State<DeliveryPlacesModel> {
  TextEditingController _controller = TextEditingController();
  var toBorderColor = kbordercolor;
  var fromBorderColor = kbordercolor;
  bool _isDelivery = false;
  List<City> _cities = [];
  City? selectedCity;
  List<AddCitie> _finalSelectedCities = [];
  List<City> _selectedCities = [];
  String? _fromTime;
  String? _toTime;

  Future<void> _show(String type) async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      if (type == 'from') {
        if (mounted)
          setState(() {
            _fromTime = "${result.hour}:${result.minute}";
            print(_fromTime);
          });
      } else {
        if (mounted)
          setState(() {
            _toTime = "${result.hour}:${result.minute}";
            print(_toTime);
          });
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      // await UserController.getCities(
      //   Provider.of<UserProvider>(context, listen: false).user.token!,
      // ).then((value) {
      //   if(mounted)setState(() {
      //     _cities = value;
      //   });
      // });
      // await UserController.getFisherCities('token').then((value) {
      //   if(mounted)setState(() {
      //     value.forEach((element) {
      //       _finalSelectedCities.add(
      //         AddCitie(
      //             id: element.id,
      //             shippingPrice: double.parse(element.shippingPrice)),
      //       );
      //       _selectedCities.add(
      //         City(
      //           id: element.id,
      //           name: element.name,
      //         ),
      //       );
      //     });
      //   });
      // });
    });
    _fromTime = widget.startWorkTime;
    _toTime = widget.endWorkTie;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isDelivery
        ? Container(
            height: 313.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
              color: kprimaryLightColor,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 17.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWidget(
                    title: LocaleKeys.market_account_delivery_places.tr(),
                    color: kprimaryColor,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    height: 54.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 240.w,
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: kshadowcolor),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: DropdownButton<City>(
                            hint: Text(LocaleKeys.select_city.tr()),
                            value: selectedCity,
                            underline: SizedBox(
                              height: 0,
                            ),
                            isExpanded: true,
                            iconSize: 15.sp,
                            icon: Icon(
                              FontAwesomeIcons.chevronDown,
                            ),
                            items: (_cities).map((City city) {
                              return DropdownMenuItem<City>(
                                value: city,
                                child: new Text(city.name),
                              );
                            }).toList(),
                            onChanged: (City? newValue) {
                              if (mounted)
                                setState(() {
                                  selectedCity = newValue;
                                });
                              print(newValue?.name);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 11.w,
                        ),
                        Container(
                          width: 60.w,
                          height: 54.h,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: kshadowcolor),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: TextField(
                            autofocus: false,
                            style: GoogleFonts.getFont('Tajawal',
                                fontSize: 18.sp, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: '0',
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            controller: _controller,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: 9.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (mounted)
                              setState(() {
                                _selectedCities.add(selectedCity!);
                                _finalSelectedCities.add(AddCitie(
                                    id: selectedCity!.id,
                                    shippingPrice:
                                        double.parse(_controller.text)));
                                _controller.clear();
                              });
                          },
                          child: Container(
                            width: 31.w,
                            height: 31.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: kprimaryColor),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Icon(
                              Icons.add,
                              color: kprimaryColor,
                              size: 25.sp,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 21.h,
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: _selectedCities.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCities[index].name,
                              style: GoogleFonts.getFont('Tajawal',
                                  color: kprimaryTextColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${_finalSelectedCities[index].shippingPrice} SR',
                                  style: GoogleFonts.getFont('Tajawal',
                                      color: ksecondaryTextColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 34.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (mounted)
                                      setState(() {
                                        _selectedCities.removeAt(index);
                                        _finalSelectedCities.removeAt(index);
                                      });
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    size: 15.sp,
                                    color: kredcolor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 19.h,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 23.h,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 171.11.w,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: BottomButton(
                              title: LocaleKeys.back.tr(),
                              bgcolor: kprimaryLightColor,
                              bordercolor: kprimaryColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (mounted)
                              setState(() {
                                _isDelivery = false;
                              });
                          },
                          child: Container(
                            width: 171.11.w,
                            child: BottomButton(
                              title: LocaleKeys.cont.tr(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 240.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
              color: kprimaryLightColor,
            ),
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 17.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWidget(
                    title: LocaleKeys.market_account_working_time.tr(),
                    color: kprimaryColor,
                  ),
                  SizedBox(
                    height: 17.h,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _show("from");
                          },
                          child: Container(
                            width: 171.11.w,
                            height: 54.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: fromBorderColor),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.market_account_from.tr(),
                                  style: GoogleFonts.getFont(
                                    'Tajawal',
                                    color: ksecondaryTextColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  _fromTime ?? "",
                                  style: GoogleFonts.getFont(
                                    'Tajawal',
                                    color: kprimaryTextColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 30.w,
                                ),
                                Icon(
                                  Icons.access_time_filled,
                                  color: ksecondaryTextColor,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _show("to");
                          },
                          child: Container(
                            width: 171.11.w,
                            height: 54.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: toBorderColor),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.market_account_to.tr(),
                                  style: GoogleFonts.getFont(
                                    'Tajawal',
                                    color: ksecondaryTextColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  _toTime ?? "",
                                  style: GoogleFonts.getFont(
                                    'Tajawal',
                                    color: kprimaryTextColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 30.w,
                                ),
                                Icon(
                                  Icons.access_time_filled,
                                  color: ksecondaryTextColor,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 23.h,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 171.11.w,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: BottomButton(
                              title: LocaleKeys.back.tr(),
                              bgcolor: kprimaryLightColor,
                              bordercolor: kprimaryColor,
                              color: kprimaryColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_fromTime == "") {
                              if (mounted)
                                setState(() {
                                  fromBorderColor = kredcolor;
                                });
                              return;
                            } else if (_toTime == "") {
                              if (mounted)
                                setState(() {
                                  toBorderColor = kredcolor;
                                });
                            } else {
                              var cities = _finalSelectedCities.map((item) {
                                return {
                                  "id": item.id,
                                  "shipping_price": item.shippingPrice
                                };
                              }).toList();
                              Navigator.pop(context, {
                                "cities": cities,
                                "from": _fromTime,
                                "to": _toTime,
                                "state": true,
                              });
                            }
                          },
                          child: Container(
                            width: 171.11.w,
                            child: BottomButton(
                              title: LocaleKeys.save.tr(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class AddCitie {
  int id;
  double shippingPrice;

  AddCitie({
    required this.id,
    required this.shippingPrice,
  });
}
