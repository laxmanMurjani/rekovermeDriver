import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/model/user_detail_model.dart';
import 'package:mozlit_driver/ui/terms_and_condition_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/enum/error_type.dart';

import '../../util/app_constant.dart';
import '../widget/custom_text_filed.dart';

class VehicleSignUpScreen extends StatefulWidget {
  @override
  _VehicleSignUpScreenState createState() => _VehicleSignUpScreenState();
}

class _VehicleSignUpScreenState extends State<VehicleSignUpScreen> {
  final UserController _userController = Get.find();
  Map<String, dynamic> params = Map();

  @override
  void initState() {
    super.initState();

    // _userController.clearFormData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getServiceType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.325,child:
              Stack(children: [
                Positioned(top: -550,left: -300,right: -300,
                    child: CircleAvatar(backgroundColor: AppColors.skyBlue,radius: 400,)),
                Align(alignment: Alignment.topCenter,child:
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(children: [
                    Image.asset(AppImage.rekovermeDriverLogo,width: 180,height: 180,),
                    // Text(
                    //   'register'.tr,
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 24.sp,
                    //     fontWeight: FontWeight.w800,
                    //   ),
                    // ),
                  ],),
                ),),
              ],),),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(height: 18.h),
                    // Image.asset(
                    //   AppImage.logo,
                    //   height: 150,
                    //   width: 150,
                    // ),
                    // SizedBox(height: 15.h),
                    Text(
                      "Vehicle_Registration".tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24.sp,
                          color: Colors.black),
                    ),
                    SizedBox(height: 15.h),
                    Container(height: 50, width: double.infinity,decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(
                        0.0,
                        1.0,
                      ),
                      blurRadius: 1.0,
                      //spreadRadius: 2.0,
                    ),]
                    ),child: Padding(
                      padding: const EdgeInsets.only(top: 12.0,left: 10),
                      child: DropdownButton<ServiceType>(
                        hint: Text(
                          'service_type'.tr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // Not necessary for Option 1
                        value: cont.serviceType,
                        isExpanded: true,
                        isDense: true,
                        focusColor: AppColors.primaryColor,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400),

                        // underline: Container(
                        //   height: 1.h,
                        //   width: double.infinity,
                        //   decoration:
                        //       BoxDecoration(color: AppColors.underLineColor),
                        // ),
                        onChanged: (newValue) {
                          setState(() {
                            cont.serviceType = newValue;
                          });
                        },
                        items: cont.serviceTypeList.map((location) {
                          return DropdownMenuItem(
                            child: Text(
                              location.name ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.sp,
                              ),
                            ),
                            value: location,
                          );
                        }).toList(),
                      ),
                    )),
                    SizedBox(height: 15.h),
                    CustomTextFiled(
                        controller: cont.carModelController,
                        label: "Truck make".tr,
                        hint: "Truck make".tr,fillColor: AppColors.white,filled: true),
                    SizedBox(height: 15.h),
                    CustomTextFiled(
                        controller: cont.carNumberController,
                        label: "License plate number".tr,
                        hint: "License plate number".tr,fillColor: AppColors.white,filled: true),
                    // SizedBox(height: 15.h),
                    // CustomTextFiled(
                    //     controller: cont.carColorController,
                    //     label: "car_color".tr,
                    //     hint: "car_color".tr,fillColor: AppColors.white,filled: true),
                    // SizedBox(height: 15.h),
                    // CustomTextFiled(
                    //     controller: cont.carCompanyNameController,
                    //     label: "car_name".tr,
                    //     hint: "car_name".tr,fillColor: AppColors.white,filled: true),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     Checkbox(
              //       value: cont.chkTerms.value,
              //       onChanged: (v) {
              //         cont.chkTerms.value = v!;
              //       },
              //     ),
              //     InkWell(
              //       onTap: () {
              //         cont.removeUnFocusManager();
              //         Get.to(() => TermsAndConditionScreen());
              //       },
              //       child: Text(
              //         "i_have_read_and_agreed_the_terms_and_Conditions".tr,
              //         style: TextStyle(fontSize: 12.sp),
              //       ),
              //     )
              //   ],
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    //SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: cont.chkTerms.value,
                          onChanged: (value) {
                            cont.chkTerms.value = value!;
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'By Continuing, You Agree to our ',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 10),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '\nTerms of use ',
                                  style: TextStyle(
                                      color: Color(0xff297FFF),
                                      fontSize: 10)),
                              TextSpan(
                                text: 'and',
                              ),
                              TextSpan(
                                  text: '  Privacy Policy',
                                  style: TextStyle(
                                      color: Color(0xff297FFF),
                                      fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    InkWell(
                      onTap: () {
                        //print(cont.countryCode.toString());
                        cont.registerUser();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("create_an_account".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                              width: 20.w,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
