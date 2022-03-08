import 'dart:io';
import 'package:fishe_tender_fisher/common/bottom_button.dart';
import 'package:fishe_tender_fisher/common/snackbar_dialog_widget.dart';
import 'package:fishe_tender_fisher/common/title_widget.dart';
import 'package:fishe_tender_fisher/constants.dart';
import 'package:fishe_tender_fisher/controllers/auth_controller.dart';
import 'package:fishe_tender_fisher/controllers/image_logo_controller.dart';
import 'package:fishe_tender_fisher/models/products/image_model.dart';
import 'package:fishe_tender_fisher/models/auth/logo_model.dart';
import 'package:fishe_tender_fisher/services/image_provider.dart';
import 'package:fishe_tender_fisher/services/user_provier.dart';
import 'package:fishe_tender_fisher/translations/locale_keys.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LogoAndCoverModel extends StatefulWidget {
  LogoAndCoverModel({Key? key, required this.isImage, required this.pName})
      : super(key: key);
  final bool isImage;
  final String pName;

  @override
  _LogoAndCoverModelState createState() => _LogoAndCoverModelState();
}

class _LogoAndCoverModelState extends State<LogoAndCoverModel> {
  TextEditingController _controllerLogoName = new TextEditingController();
  TextEditingController _controllerSearch = new TextEditingController();
  ScrollController _scrollControllerimages = new ScrollController();
  ScrollController _scrollControllerLogos = new ScrollController();

  //List<Img> _selectedImages = [];
  Logo? _selectedLogo;
  Img? _selectedImage;
  bool _isAdding = false;
  List<Img> _images = [];
  List<Logo> _logos = [];
  File? imageFile;
  List<File> addedImages = [];
  List<File> imagesAdded = [];
  String? imagepath = "";
  ImagePicker _picker = new ImagePicker();
  bool isShimmer = false;
  bool isLoading = false;
  var nextimages;
  var nextLogos;
  bool isLoadinImags = false;
  int pageImages = 1;
  int pageLogo = 1;
  bool isLoadinLogos = false;

  @override
  void dispose() {
    _scrollControllerimages.dispose();
    _scrollControllerLogos.dispose();
    _controllerLogoName.dispose();
    _controllerSearch.dispose();
    super.dispose();
  }

  Future getImage() async {
    if (widget.isImage) {
      List<XFile>? images = await _picker.pickMultiImage();
      if (images != null) {
        if (mounted)
          setState(() {
            for (var item in images) {
              addedImages.add(File(item.path));
            }
          });
      }
    } else {
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (mounted)
          setState(() {
            imageFile = File(pickedFile.path);
            imagepath = pickedFile.path;
          });
      } else {
        return;
      }
    }
  }

  @override
  void initState() {
    if (mounted)
      setState(() {
        isShimmer = true;
      });
    Future.delayed(Duration.zero, () async {
      widget.isImage
          ? await ImageLogoController.getImage(
              token:
                  Provider.of<UserProvider>(context, listen: false).user.token!,
              pageNumber: pageImages,
              name: widget.pName,
            ).then((value) {
              if (value != null) if (mounted)
                setState(() {
                  _images = value["data"];
                  nextimages = value["next"];
                });
            })
          : await ImageLogoController.getLogo(
              token:
                  Provider.of<UserProvider>(context, listen: false).user.token!,
              pageNumber: pageLogo,
            ).then((value) {
              if (value != null) if (mounted)
                setState(() {
                  _logos = value["data"];
                  nextLogos = value["next"];
                });
            });
    }).then((value) {
      if (mounted)
        setState(() {
          isShimmer = false;
        });
    });

    _scrollControllerimages.addListener(() {
      if (_scrollControllerimages.position.pixels >=
              _scrollControllerimages.position.maxScrollExtent &&
          !isLoadinImags) {
        if (nextimages != null) {
          Future.delayed(Duration.zero, () async {
            if (mounted)
              setState(() {
                isLoadinImags = true;
              });
            await ImageLogoController.getImage(
              token:
                  Provider.of<UserProvider>(context, listen: false).user.token!,
              name: widget.pName,
              pageNumber: ++pageImages,
            ).then((value) {
              if (value != null) if (mounted)
                setState(() {
                  isLoadinImags = false;
                  _images.addAll(value["data"]);
                  nextimages = value["next"];
                });
            });
          });
        }
      }
    });

    _scrollControllerLogos.addListener(() {
      if (_scrollControllerLogos.position.pixels >=
              _scrollControllerLogos.position.maxScrollExtent &&
          !isLoadinLogos) {
        if (nextLogos != null) {
          Future.delayed(Duration.zero, () async {
            if (mounted)
              setState(() {
                isLoadinLogos = true;
              });
            await ImageLogoController.getLogo(
                    token: Provider.of<UserProvider>(context, listen: false)
                        .user
                        .token!,
                    pageNumber: ++pageLogo)
                .then((value) {
              if (value != null) if (mounted)
                setState(() {
                  _logos.addAll(value["data"]);
                  nextLogos = value["next"];
                  isLoadinLogos = false;
                });
            });
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdding
        ? Container(
            height: 320.h,
            decoration: BoxDecoration(
              color: kprimaryLightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleWidget(
                            title: widget.isImage
                                ? LocaleKeys.market_account_add_new_image.tr()
                                : LocaleKeys.market_account_add_new_logo.tr(),
                            color: kprimaryColor,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 28.h,
                              width: 28.w,
                              decoration: BoxDecoration(
                                color: kprimaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.clear,
                                color: kprimaryLightColor,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 17.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: !widget.isImage
                            ? Container(
                                height: 146.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: kbordercolor,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: imagepath == ''
                                    ? Center(
                                        child: Image.asset(
                                          'assets/icons/empty_file_icon.png',
                                          scale: 1.5,
                                        ),
                                      )
                                    : Image.file(imageFile!),
                              )
                            : Container(
                                height: 146.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: kbordercolor,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: addedImages.isEmpty
                                    ? Center(
                                        child: Image.asset(
                                          'assets/icons/empty_file_icon.png',
                                          scale: 1.5,
                                        ),
                                      )
                                    : Image.file(addedImages.first),
                              ),
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                      Form(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (!widget.isImage && imageFile != null) {
                                  if (mounted)
                                    setState(() {
                                      isLoading = true;
                                    });
                                  await AuthController.updateUserLogo(
                                    token: Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user
                                        .token!,
                                    file: imageFile,
                                    isAdding: true,
                                  ).then((value) {
                                    if (mounted)
                                      setState(() {
                                        isLoading = false;
                                      });
                                    showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return SnackabrDialog(
                                          status:
                                              value == 'Created' ? true : false,
                                          message: value == 'Created'
                                              ? LocaleKeys
                                                  .market_account_request_message
                                                  .tr()
                                              : value,
                                          onPopFunction: () {
                                            Navigator.of(context)
                                                .pop(_selectedLogo);
                                          },
                                        );
                                      },
                                    ).then(
                                      (value) => Navigator.pop(context),
                                    );
                                  });
                                } else {
                                  if (addedImages.isNotEmpty)
                                    Provider.of<ImgProvider>(context,
                                            listen: false)
                                        .addImages(addedImages);
                                  widget.isImage
                                      ? Navigator.pop(context, _selectedImage)
                                      : Navigator.pop(context, _selectedLogo);
                                }
                              },
                              child: BottomButton(
                                title:
                                    LocaleKeys.market_account_send_request.tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  Container(
                      color: Colors.black45,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ))
              ],
            ),
          )
//
//
//
//
//
//
        : Container(
            height: 590.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: kprimaryLightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleWidget(
                      title: widget.isImage
                          ? LocaleKeys.market_account_bank_images.tr()
                          : LocaleKeys.market_account_bank_logo.tr(),
                      color: kprimaryColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (mounted)
                          setState(() {
                            _isAdding = true;
                          });
                      },
                      child: Row(
                        children: [
                          Text(
                              widget.isImage
                                  ? LocaleKeys.add_image.tr()
                                  : LocaleKeys.add_logo.tr(),
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 15.sp,
                                color: kprimaryTextColor,
                              )),
                          SizedBox(width: 7.w),
                          Container(
                            height: 28.h,
                            width: 28.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kprimaryColor,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 20.sp,
                              color: kprimaryLightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                // if (widget.isImage)
                //   Container(
                //       alignment: Alignment.centerLeft,
                //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                //       width: 355.w,
                //       height: 54.h,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(5.r),
                //           border: Border.all(
                //             color: kbordercolor,
                //           )),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Container(
                //             width: 250.w,
                //             child: TextField(
                //               onSubmitted: (String value) async {
                //                 if(mounted)setState(() {
                //                   _images.clear();
                //                   pageImages = 1;
                //                   isShimmer = true;
                //                 });
                //                 await ImageLogoController.getImage(
                //                   token: Provider.of<UserProvider>(
                //                     context,
                //                     listen: false,
                //                   ).user.token!,
                //                   name: value,
                //                   pageNumber: pageImages,
                //                 ).then((value) {
                //                   if(mounted)setState(() {
                //                     _images = value["data"];
                //                     nextimages = value["next"];
                //                   });
                //                 });

                //                 if(mounted)setState(() {
                //                   isShimmer = false;
                //                 });
                //               },
                //               textInputAction: TextInputAction.search,
                //               controller: _controllerSearch,
                //               decoration: InputDecoration(
                //                 border: InputBorder.none,
                //                 hintText: LocaleKeys.market_account_search.tr(),
                //               ),
                //               style: GoogleFonts.getFont(
                //                 'Tajawal',
                //                 fontSize: 16.sp,
                //                 fontWeight: FontWeight.w600,
                //                 color: ksecondaryTextColor,
                //               ),
                //             ),
                //           ),
                //           ClipOval(
                //             child: IconButton(
                //               color: kprimaryColor,
                //               padding: EdgeInsets.zero,
                //               onPressed: () async {
                //                 if(mounted)setState(() {
                //                   _images.clear();
                //                   pageImages = 1;
                //                   isShimmer = true;
                //                 });
                //                 await ImageLogoController.getImage(
                //                         token: Provider.of<UserProvider>(
                //                                 context,
                //                                 listen: false)
                //                             .user
                //                             .token!,
                //                         name: _controllerSearch.text,
                //                         pageNumber: pageImages)
                //                     .then((value) {
                //                   if(mounted)setState(() {
                //                     _images = value["data"];
                //                     nextimages = value["next"];
                //                   });
                //                 });

                //                 if(mounted)setState(() {
                //                   isShimmer = false;
                //                 });
                //               },
                //               icon: Icon(
                //                 Icons.search,
                //                 size: 20.sp,
                //                 color: kprimaryTextColor,
                //               ),
                //             ),
                //           )
                //         ],
                //       )),
                SizedBox(
                  height: 18.h,
                ),
                Container(
                  height: 400.h,
                  padding: EdgeInsets.all(4),
                  child: !isShimmer
                      ? Column(
                          children: [
                            _images.isNotEmpty || _logos.isNotEmpty
                                ? Expanded(
                                    child: Stack(
                                      children: [
                                        GridView.builder(
                                          controller: widget.isImage
                                              ? _scrollControllerimages
                                              : _scrollControllerLogos,
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 0.5 / 0.5,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                          ),
                                          itemCount: widget.isImage
                                              ? _images.length
                                              : _logos.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                if (mounted)
                                                  setState(() {
                                                    if (widget.isImage) {
                                                      // _selectedImages.contains(
                                                      //         _images[index])
                                                      //     ? _selectedImages
                                                      //         .remove(
                                                      //             _images[index])
                                                      //     : _selectedImages.add(
                                                      //         _images[index]);
                                                      _selectedImage =
                                                          _images[index];
                                                    } else {
                                                      _selectedLogo =
                                                          _logos[index];
                                                    }
                                                  });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: klightbleucolor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: widget.isImage
                                                        ? (_selectedImage ==
                                                                    _images[
                                                                        index]
                                                                ? kprimaryColor
                                                                : kbordercolor
                                                            // _selectedImages
                                                            //       .contains(
                                                            //           _images[
                                                            //               index])
                                                            //   ? kprimaryColor
                                                            //   : kbordercolor
                                                            )
                                                        : (_selectedLogo ==
                                                                _logos[index]
                                                            ? kprimaryColor
                                                            : kbordercolor),
                                                  ),
                                                ),
                                                child: widget.isImage
                                                    ? Image.network(
                                                        _images[index].imageUrl,
                                                      )
                                                    : Image.network(
                                                        _logos[index].imageUrl,
                                                      ),
                                              ),
                                            );
                                          },
                                        ),
                                        if (isLoadinImags)
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                            ],
                                          ),
                                        if (isLoadinLogos)
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                            ],
                                          )
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        LocaleKeys.no_data.tr(),
                                        style: GoogleFonts.tajawal(
                                            fontSize: 20.sp,
                                            color: kprimaryTextColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                GestureDetector(
                    onTap: () {
                      Provider.of<ImgProvider>(context, listen: false)
                          .clearImages();
                      widget.isImage
                          ? Navigator.pop(context, _selectedImage)
                          : Navigator.pop(context, _selectedLogo);
                    },
                    child: BottomButton(
                        title: LocaleKeys.market_account_select.tr())),
              ],
            ),
          );
  }
}
