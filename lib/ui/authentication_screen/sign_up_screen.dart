import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/model/user_detail_model.dart';
import 'package:mozlit_driver/ui/authentication_screen/vehicle_sign_up_screen.dart';
import 'package:mozlit_driver/ui/terms_and_condition_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/enum/error_type.dart';

import '../../util/app_constant.dart';
import '../widget/custom_text_filed.dart';

class SignUpScreen extends StatefulWidget {
  final bool isTow;
  const SignUpScreen({Key? key, required this.isTow}) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final UserController _userController = Get.find();
  Map<String, dynamic> params = Map();

  @override
  void initState() {
    super.initState();

    _userController.clearFormData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getServiceType(widget.isTow? 'Tow' : 'ROADSIDESERVICE');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: GetX<UserController>(builder: (cont) {
        if (cont.error.value.errorType == ErrorType.internet) {
          return NoInternetWidget();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.37,child:
              Stack(children: [
                Positioned(top: -510,left: -300,right: -300,
                    child: CircleAvatar(backgroundColor: AppColors.skyBlue,radius: 400,)),
                Align(alignment: Alignment.topCenter,child:
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(children: [
                    Image.asset(AppImage.rekovermeDriverLogo,width: 180,height: 180,),
                    Text(
                      'register'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    widget.isTow? SizedBox() :
                    Text('Road Side Serviceman',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),)
                  ],),
                ),),
              ],),),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                    // Text(
                    //   "Driver_Registration".tr,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w800,
                    //       fontSize: 24.sp,
                    //       color: Colors.black),
                    // ),
                    SizedBox(height: 15.h),
                    // CustomTextFiled(
                    //     controller: cont.emailController,
                    //     hint: "email".tr,
                    //     label: "email".tr),
                    CustomTextFiled(
                      controller: cont.firstNameController,
                      label: "first_name".tr,
                      hint: "first_name".tr,
                      inputType: TextInputType.name,
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-zA-Z]")),
                      ],
                      fillColor: AppColors.white,
                      filled: true,
                    ),
                    SizedBox(height: 15.w),
                    CustomTextFiled(
                      controller: cont.lastNameController, fillColor: AppColors.white,
                      filled: true,
                      label: "lastname".tr,
                      hint: "lastname".tr,
                      inputType: TextInputType.name,
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-zA-Z]")),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    CustomTextFiled(
                      controller: cont.emailController, fillColor: AppColors.white,
                      filled: true,
                      label: "email".tr,
                      hint: "email".tr,
                      inputType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Card(color: Colors.white,
                          child: Row(
                            children: [
                              CountryCodePicker(
                                onChanged: (s) {
                                  cont.countryCode.value = s.toString();
                                },
                                textStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                hideMainText: true,
                                initialSelection: 'Us',
                                //cont.userData.value.countryCode ?? "+1",
                                // favorite: ['+91', 'IN'],
                                countryFilter: ['US', "IN"],
                                showFlagDialog: true,
                                // showDropDownButton: true,
                                showCountryOnly: true,
                                padding: EdgeInsets.zero,
                                comparator: (a, b) =>
                                    b.name!.compareTo(a.name.toString()),
                                //Get the country information relevant to the initial selection
                                onInit: (code) {
                                  cont.countryCode.value = code!.dialCode.toString();
                                  print(
                                    "on init ${code.name} ${code.dialCode} ${code.name}");
                                },
                                backgroundColor: AppColors.white,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: AppColors.primaryColor,
                                size: 25,
                              ),
                              SizedBox(width: 5,)
                            ],
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: CustomTextFiled(
                            controller: cont.phoneNumberController,
                            label: "phone".tr,
                            hint: "phone".tr,
                            inputType: TextInputType.phone,
                            fillColor: AppColors.white,
                            filled: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    CustomTextFiled(
                      controller: cont.passwordController,
                      hint: "password".tr,
                      label: "password".tr,fillColor: AppColors.white,
                      filled: true,
                      isPassword: true,
                    ),
                    SizedBox(height: 15.h),
                    CustomTextFiled(
                      controller: cont.conPasswordController,
                      hint: "confirm_password".tr,
                      label: "confirm_password".tr,fillColor: AppColors.white,
                      filled: true,
                      isPassword: true,
                    ),
                    SizedBox(height: 15.h),
                    CustomTextFiled(
                        controller: cont.refCodeController,
                        hint: "referral_code".tr,fillColor: AppColors.white,
                        filled: true,
                        label: "referral_code_(Optional)".tr),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            cont.signUpDetailsUser(widget.isTow);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            height: 45,
                            width: MediaQuery.of(context).size.width*0.7,
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("next".tr,
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
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
