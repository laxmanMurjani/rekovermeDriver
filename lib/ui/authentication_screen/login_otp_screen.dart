import 'dart:developer';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/preference/preference.dart';
import 'package:mozlit_driver/ui/authentication_screen/login_screen.dart';
import 'package:mozlit_driver/ui/authentication_screen/sign_up_screen.dart';
import 'package:mozlit_driver/ui/authentication_screen/towOrRoadRegister.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/custom_text_filed.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({Key? key}) : super(key: key);

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final UserController _userController = Get.find();

  Map<String, dynamic> params = Map();

  @override
  void initState() {
    super.initState();
    _userController.clearFormData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      print(
          "prefs.containsKey(Database.seenOnBoarding)===>${prefs.containsKey(Database.seenOnBoarding)}");
      if (!prefs.containsKey(Database.seenOnBoarding)) {
        _showDialog();
      }
    });
  }

  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: Text(
              "Rekoverme driver would like to collect location data to enable your current location to provide you the service for taxi booking and navigation even when the app is closed or not in use.",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Database.setSeenLocationAlertDialog();
                    Get.back();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetX<UserController>(
        builder: (cont) {
          if (cont.error.value.errorType == ErrorType.internet) {
            return NoInternetWidget();
          }
          return SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width,child:
                    Stack(
                      children: [
                        Positioned(top: -510,left: -300,right: -300,
                            child: CircleAvatar(backgroundColor: AppColors.skyBlue,radius: 400,)),
                        Align(alignment: Alignment.topCenter,child:
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Column(children: [
                            Image.asset(AppImage.rekovermeDriverLogo,width: 180,height: 180,),
                            SizedBox(height: 15,),
                            Text(
                              'Login'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],),
                        ),),

                      ],
                    ),
                  ),
                  // Image.asset(AppImage.logo,width: 180,height: 180,),
                  // SizedBox(
                  //   height: 40,
                  // ),
                  // Text(
                  //   'Login'.tr,
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 24.sp,
                  //     fontWeight: FontWeight.w800,
                  //   ),
                  // ),
                  // SizedBox(height: 30.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      children: [
                        Card(color: Colors.white,
                          child: Row(
                            children: [
                              CountryCodePicker(
                                onChanged: (s) {
                                  print("ssss===>${s}");
                                  _userController.countryCode.value = s.toString();
                                },
                                textStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                hideMainText: true,
                                initialSelection:
                                cont.userData.value.countryCode ?? "+1",
                                // favorite: ['+91', 'IN'],
                                countryFilter: ['Us', "IN"],
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
                        // Expanded(
                        //   child: CustomTextFiled(
                        //     controller: cont.phoneNumberController,
                        //     label: "phone".tr,
                        //     hint: "phone".tr,
                        //     inputType: TextInputType.phone,
                        //     fillColor: AppColors.white,
                        //     filled: true,
                        //   ),
                        // ),
                        Expanded(child: Container(height: 50,decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(
                              0.0,
                              1.0,
                            ),
                            blurRadius: 1.0,
                          ),]),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: cont.phoneNumberController,decoration: InputDecoration(
                              border: InputBorder.none,hintText: "phone".tr,hintStyle: TextStyle(
                            fontSize: 16, color: Colors.grey,
                          ),contentPadding: EdgeInsets.only(left: 10)
                          ),),
                        )),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomButton(
                      // padding: EdgeInsets.symmetric(vertical: 20),
                      text: "Continue",
                      onTap: () {
                        if (cont.phoneNumberController.text.isEmpty) {
                          // cont.showError(msg: "please_number".tr);
                          Get.snackbar("Alert", "please_number".tr,
                              backgroundColor: Colors.redAccent.withOpacity(0.8),
                              colorText: Colors.white);
                          return;
                        }
                        // else if (cont.phoneNumberController.text.length != 9 &&
                        //     cont.countryCode == '+593') {
                        //   Get.snackbar(
                        //       "Alert", "Please enter valid 9 digit mobile number",
                        //       backgroundColor: Colors.redAccent.withOpacity(0.8),
                        //       colorText: Colors.white);
                        //   // cont.showError(
                        //   //     msg:
                        //   //         "Please enter valid 10 digit mobile number");
                        //   return;
                        // }
                        cont.sendOtp(params: params);
                      },
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    'Or',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 25.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomButton(bgColor: AppColors.primaryColor,
                      text: "Login With Password",
                      onTap: () {
                        // cont.registerUser();
                        Get.to(() => LoginScreen());
                      },
                    ),
                  ),

                  SizedBox(height: 50.h),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomButton(bgColor: AppColors.primaryColor,
                      text: "register".tr,
                      onTap: () {
                        // cont.registerUser();
                        Get.to(() => TowOrRoadRegister());
                        //Get.to(() => SignUpScreen());
                      },
                    ),
                  ),
                  // SizedBox(height: 40.h),

                  // Container(
                  //   alignment: Alignment.center,
                  //   padding: new EdgeInsets.only(right: 25.0, left: 25.0, top: 50),
                  //   child: ListView(
                  //     children: [
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           // SizedBox(
                  //           //   height: 20,
                  //           // ),
                  //
                  //           // InkWell(
                  //           //   onTap: () {
                  //           //     if (cont.phoneNumberController.text.isEmpty) {
                  //           //       // cont.showError(msg: "please_number".tr);
                  //           //       Get.snackbar("Alert", "please_number".tr,
                  //           //           backgroundColor: Colors.redAccent.withOpacity(0.8),
                  //           //           colorText: Colors.white);
                  //           //       return;
                  //           //     } else if (cont.phoneNumberController.text.length !=
                  //           //         10 &&
                  //           //         cont.countryCode == '+91') {
                  //           //       Get.snackbar("Alert", "Please enter valid 10 digit mobile number",
                  //           //           backgroundColor: Colors.redAccent.withOpacity(0.8),
                  //           //           colorText: Colors.white);
                  //           //       // cont.showError(
                  //           //       //     msg:
                  //           //       //         "Please enter valid 10 digit mobile number");
                  //           //       return;
                  //           //     }
                  //           //     cont.sendOtp(params: params);
                  //           //   },
                  //           //   child: Card(
                  //           //     shape: RoundedRectangleBorder(
                  //           //         borderRadius: BorderRadius.circular(5)),
                  //           //     child: Container(
                  //           //       width: double.infinity,
                  //           //       padding: EdgeInsets.symmetric(vertical: 20),
                  //           //       alignment: Alignment.center,
                  //           //       decoration: BoxDecoration(
                  //           //           color: AppColors.primaryColor,
                  //           //           borderRadius: BorderRadius.circular(5.r),
                  //           //           border:
                  //           //           Border.all(color: AppColors.primaryColor)
                  //           //         // boxShadow: [
                  //           //         //   BoxShadow(
                  //           //         //     color: AppColors.lightGray.withOpacity(0.5),
                  //           //         //     blurRadius: 16.r,
                  //           //         //     spreadRadius: 2.w,
                  //           //         //     offset: Offset(0, 3.h),
                  //           //         //   )
                  //           //         // ],
                  //           //       ),
                  //           //       child: Text(
                  //           //         'Continue',
                  //           //         style: TextStyle(
                  //           //             fontSize: 16.sp,
                  //           //             fontWeight: FontWeight.w600,
                  //           //             color: Colors.white),
                  //           //       ),
                  //           //     ),
                  //           //   ),
                  //           // ),
                  //
                  //           // Text(
                  //           //   'Dont_have'.tr,
                  //           //   style: TextStyle(
                  //           //       fontSize: 13.sp,
                  //           //       fontWeight: FontWeight.w500,
                  //           //       color: Colors.black),
                  //           // ),
                  //           // SizedBox(height: 5.h),
                  //
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // new ListView(
                  //   // mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       height: MediaQuery.of(context).size.height * 0.5,
                  //       color: AppColors.white,
                  //       // width: double.infinity,
                  //       // child: Image.asset(
                  //       //   'assets/images/top_home.png',
                  //       //   fit: BoxFit.cover,
                  //       // ),
                  //     ),
                  //     Flexible(fit: FlexFit.tight, child: SizedBox()),
                  //     Stack(
                  //       alignment: Alignment.bottomCenter,
                  //       children: [
                  //         Container(
                  //           height: MediaQuery.of(context).size.height * 0.46,
                  //           width: double.infinity,
                  //           child: Image.asset(
                  //             'assets/images/bottom_home.png',
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         RichText(
                  //           text: TextSpan(
                  //             text: 'By Continuing, You Agree to our ',
                  //             style: TextStyle(
                  //                 color: AppColors.primaryColor, fontSize: 10),
                  //             children: <TextSpan>[
                  //               TextSpan(
                  //                   text: '\nTerms of use ',
                  //                   style: TextStyle(
                  //                       color: Color(0xff297FFF), fontSize: 10)),
                  //               TextSpan(
                  //                 text: 'and',
                  //               ),
                  //               TextSpan(
                  //                   text: '  Privacy Policy',
                  //                   style: TextStyle(
                  //                       color: Color(0xff297FFF), fontSize: 10)),
                  //             ],
                  //           ),
                  //         ),
                  //         Align(
                  //           alignment: Alignment.bottomCenter,
                  //           child: Image.asset(
                  //             AppImage.building,
                  //             color: Colors.black.withOpacity(0.1),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ]),
          );

          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     SizedBox(height: 40.h),
          //     Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Expanded(
          //           child: Text(
          //             "welcome_back".tr,
          //             style: TextStyle(
          //               fontWeight: FontWeight.w700,
          //               fontSize: 35.sp,
          //             ),
          //           ),
          //         ),
          //         InkWell(
          //           onTap: () {
          //             Get.back();
          //             _userController.isShowLogin.value = false;
          //           },
          //           child: Image.asset(
          //             AppImage.back,
          //             width: 35.w,
          //           ),
          //         ),
          //       ],
          //     ),
          //     SizedBox(height: 10.h),
          //     CustomTextFiled(
          //       controller: cont.emailController,
          //       hint: "email".tr,
          //       label: "email".tr,
          //     ),
          //     CustomTextFiled(
          //       controller: cont.passwordController,
          //       hint: "password".tr,
          //       label: "password".tr,
          //       isPassword: true,
          //     ),
          //     SizedBox(height: 7.h),
          //     Align(
          //       alignment: Alignment.centerRight,
          //       child: InkWell(
          //         onTap: () {
          //           cont.forgotPassword();
          //         },
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(vertical: 5.h),
          //           child: Text(
          //             "forgot_password".tr,
          //             style: TextStyle(fontSize: 10.sp),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(height: 65.h),
          //     CustomButton(
          //       text: "log_in".tr,
          //       onTap: () {
          //         cont.loginUser();
          //         // Get.to(() => HomeScreen());
          //       },
          //     ),
          //     SizedBox(height: 20.h),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           "${"don't_have_an_account?".tr} ",
          //           style: TextStyle(
          //             fontSize: 10.sp,
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: () {
          //             Get.to(() => SignUpScreen());
          //           },
          //           child: Text(
          //             "register".tr,
          //             style: TextStyle(
          //               color: AppColors.primaryColor,
          //               fontWeight: FontWeight.w700,
          //               fontSize: 10.sp,
          //               decoration: TextDecoration.underline,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     SizedBox(height: 60.h),
          //   ],
          // );
        },
      ),
      // body: GetX<UserController>(
      //   builder: (cont) {
      //     if (cont.error.value.errorType == ErrorType.internet) {
      //       return NoInternetWidget();
      //     }
      //     return SafeArea(
      //         child: Stack(
      //             alignment: Alignment.center, children: <Widget>[
      //       new ListView(
      //         // mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Container(
      //             height: MediaQuery.of(context).size.height * 0.5,
      //             color: AppColors.white,
      //             // width: double.infinity,
      //             // child: Image.asset(
      //             //   'assets/images/top_home.png',
      //             //   fit: BoxFit.cover,
      //             // ),
      //           ),
      //           Flexible(fit: FlexFit.tight, child: SizedBox()),
      //           Stack(
      //             alignment: Alignment.bottomCenter,
      //             children: [
      //               Container(
      //                 height: MediaQuery.of(context).size.height * 0.46,
      //                 width: double.infinity,
      //                 child: Image.asset(
      //                   'assets/images/bottom_home.png',
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //               RichText(
      //                 text: TextSpan(
      //                   text: 'By Continuing, You Agree to our ',
      //                   style: TextStyle(
      //                       color: AppColors.primaryColor, fontSize: 10),
      //                   children: <TextSpan>[
      //                     TextSpan(
      //                         text: '\nTerms of use ',
      //                         style: TextStyle(
      //                             color: Color(0xff297FFF), fontSize: 10)),
      //                     TextSpan(
      //                       text: 'and',
      //                     ),
      //                     TextSpan(
      //                         text: '  Privacy Policy',
      //                         style: TextStyle(
      //                             color: Color(0xff297FFF), fontSize: 10)),
      //                   ],
      //                 ),
      //               ),
      //               Align(
      //                   alignment: Alignment.bottomCenter,
      //                   child: Image.asset(
      //                     AppImage.building,
      //                     color: Colors.black.withOpacity(0.15),
      //                   )),
      //             ],
      //           ),
      //         ],
      //       ),
      //       new Container(
      //         alignment: Alignment.center,
      //         padding: new EdgeInsets.only(right: 25.0, left: 25.0, top: 50),
      //         child: ListView(
      //           children: [
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 // SizedBox(
      //                 //   height: 20,
      //                 // ),
      //                 Container(height: 150, child: Image.asset(AppImage.logo)),
      //                 SizedBox(
      //                   height: 20,
      //                 ),
      //                 Text(
      //                   'LogIn'.tr,
      //                   style: TextStyle(
      //                     color: Colors.black,
      //                     fontSize: 24.sp,
      //                     fontWeight: FontWeight.w800,
      //                   ),
      //                 ),
      //                 SizedBox(height: 30.h),
      //                 Row(
      //                   children: [
      //                     Stack(
      //                       children: [
      //                         Row(
      //                           children: [
      //                             CountryCodePicker(
      //                               onChanged: (s) {},
      //                               textStyle: TextStyle(
      //                                 color: AppColors.primaryColor,
      //                                 fontWeight: FontWeight.w600,
      //                               ),
      //                               hideMainText: true,
      //                               initialSelection:
      //                                   cont.userData.value.countryCode ??
      //                                       "+91",
      //                               // favorite: ['+91', 'IN'],
      //                               // countryFilter: ['IT', 'FR', "IN"],
      //                               showFlagDialog: true,
      //                               comparator: (a, b) =>
      //                                   b.name!.compareTo(a.name.toString()),
      //                               //Get the country information relevant to the initial selection
      //                               onInit: (code) => print(
      //                                   "on init ${code!.name} ${code.dialCode} ${code.name}"),
      //                             ),
      //                             Image.asset(
      //                               AppImage.downArrow1,
      //                               height: 15,
      //                               width: 15,
      //                               fit: BoxFit.contain,
      //                             )
      //                           ],
      //                         ),
      //                         Container(
      //                           margin: EdgeInsets.only(top: 45, left: 10),
      //                           color: Colors.black,
      //                           height: 1,
      //                           width: 80,
      //                         )
      //                       ],
      //                     ),
      //                     //
      //                     SizedBox(width: 15.w),
      //                     Expanded(
      //                       flex: 2,
      //                       child: CustomTextFiled(
      //                         controller: cont.phoneNumberController,
      //                         label: "phone".tr,
      //                         hint: "phone".tr,
      //                         inputType: TextInputType.phone,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 SizedBox(height: 30.h),
      //                 InkWell(
      //                   onTap: () {
      //                     if (cont.phoneNumberController.text.isEmpty) {
      //                       cont.showError(msg: "please_number".tr);
      //                       return;
      //                     }
      //                     cont.sendOtp(params: params);
      //                   },
      //                   child: Card(
      //                     shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(5)),
      //                     child: Container(
      //                       width: double.infinity,
      //                       padding: EdgeInsets.symmetric(vertical: 20),
      //                       alignment: Alignment.center,
      //                       decoration: BoxDecoration(
      //                           color: AppColors.primaryColor,
      //                           borderRadius: BorderRadius.circular(5.r),
      //                           border:
      //                               Border.all(color: AppColors.primaryColor)
      //                           // boxShadow: [
      //                           //   BoxShadow(
      //                           //     color: AppColors.lightGray.withOpacity(0.5),
      //                           //     blurRadius: 16.r,
      //                           //     spreadRadius: 2.w,
      //                           //     offset: Offset(0, 3.h),
      //                           //   )
      //                           // ],
      //                           ),
      //                       child: Text(
      //                         'Continue',
      //                         style: TextStyle(
      //                             fontSize: 16.sp,
      //                             fontWeight: FontWeight.w600,
      //                             color: Colors.white),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 // CustomButton(
      //                 //   padding: EdgeInsets.symmetric(vertical: 20),
      //                 //   text: "Continue",
      //                 //   onTap: () {
      //                 //     // cont.loginUser();
      //                 //     if (cont.phoneNumberController.text.isEmpty) {
      //                 //       cont.showError(msg: "please_number".tr);
      //                 //       return;
      //                 //     }
      //                 //     cont.sendOtp(params: params);
      //                 //   },
      //                 // ),
      //                 SizedBox(height: 25.h),
      //                 Text(
      //                   'Or',
      //                   style: TextStyle(
      //                       fontSize: 14, fontWeight: FontWeight.w500),
      //                 ),
      //                 SizedBox(height: 25.h),
      //                 Padding(
      //                   padding: const EdgeInsets.symmetric(horizontal: 30),
      //                   child: CustomButton(
      //                     text: "Login With Password".tr,
      //                     onTap: () {
      //                       // cont.registerUser();
      //                       Get.to(() => LoginScreen());
      //                     },
      //                   ),
      //                 ),
      //                 SizedBox(height: 60.h),
      //                 Padding(
      //                   padding: const EdgeInsets.symmetric(horizontal: 30),
      //                   child: CustomButton(
      //                     text: "register".tr,
      //                     onTap: () {
      //                       // cont.registerUser();
      //                       Get.to(() => SignUpScreen());
      //                     },
      //                   ),
      //                 ),
      //                 // SizedBox(height: 40.h),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ]));
      //
      //     // Column(
      //     //   mainAxisSize: MainAxisSize.min,
      //     //   children: [
      //     //     SizedBox(height: 40.h),
      //     //     Row(
      //     //       crossAxisAlignment: CrossAxisAlignment.start,
      //     //       children: [
      //     //         Expanded(
      //     //           child: Text(
      //     //             "welcome_back".tr,
      //     //             style: TextStyle(
      //     //               fontWeight: FontWeight.w700,
      //     //               fontSize: 35.sp,
      //     //             ),
      //     //           ),
      //     //         ),
      //     //         InkWell(
      //     //           onTap: () {
      //     //             Get.back();
      //     //             _userController.isShowLogin.value = false;
      //     //           },
      //     //           child: Image.asset(
      //     //             AppImage.back,
      //     //             width: 35.w,
      //     //           ),
      //     //         ),
      //     //       ],
      //     //     ),
      //     //     SizedBox(height: 10.h),
      //     //     CustomTextFiled(
      //     //       controller: cont.emailController,
      //     //       hint: "email".tr,
      //     //       label: "email".tr,
      //     //     ),
      //     //     CustomTextFiled(
      //     //       controller: cont.passwordController,
      //     //       hint: "password".tr,
      //     //       label: "password".tr,
      //     //       isPassword: true,
      //     //     ),
      //     //     SizedBox(height: 7.h),
      //     //     Align(
      //     //       alignment: Alignment.centerRight,
      //     //       child: InkWell(
      //     //         onTap: () {
      //     //           cont.forgotPassword();
      //     //         },
      //     //         child: Padding(
      //     //           padding: EdgeInsets.symmetric(vertical: 5.h),
      //     //           child: Text(
      //     //             "forgot_password".tr,
      //     //             style: TextStyle(fontSize: 10.sp),
      //     //           ),
      //     //         ),
      //     //       ),
      //     //     ),
      //     //     SizedBox(height: 65.h),
      //     //     CustomButton(
      //     //       text: "log_in".tr,
      //     //       onTap: () {
      //     //         cont.loginUser();
      //     //         // Get.to(() => HomeScreen());
      //     //       },
      //     //     ),
      //     //     SizedBox(height: 20.h),
      //     //     Row(
      //     //       mainAxisAlignment: MainAxisAlignment.center,
      //     //       children: [
      //     //         Text(
      //     //           "${"don't_have_an_account?".tr} ",
      //     //           style: TextStyle(
      //     //             fontSize: 10.sp,
      //     //           ),
      //     //         ),
      //     //         GestureDetector(
      //     //           onTap: () {
      //     //             Get.to(() => SignUpScreen());
      //     //           },
      //     //           child: Text(
      //     //             "register".tr,
      //     //             style: TextStyle(
      //     //               color: AppColors.primaryColor,
      //     //               fontWeight: FontWeight.w700,
      //     //               fontSize: 10.sp,
      //     //               decoration: TextDecoration.underline,
      //     //             ),
      //     //           ),
      //     //         ),
      //     //       ],
      //     //     ),
      //     //     SizedBox(height: 60.h),
      //     //   ],
      //     // );
      //   },
      // ),
    );
  }

  Future<void> _faceBookLogin() async {
    try {
      AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      // await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();
      log("messageFacebook    ==>   ${result.message}     ${result.status}");

      switch (result.status) {
        case LoginStatus.success:
          // final AuthCredential? facebookCredential =
          // FacebookAuthProvider.credential(result.accessToken.token);
          // final userCredential =
          //     await _auth.signInWithCredential(facebookCredential);
          // Map<String, String> params = {};
          // params["name"] = "${userCredential.user.displayName}";
          // params["email"] = "${userCredential.user.email}";
          // params["so_id"] = "${userCredential.user.uid}";
          // params["so_platform"] = "FACEBOOK";
          // log("messageFacebook    ==>   ${userCredential.user.email}   ${userCredential.user.displayName}   ${userCredential.user.phoneNumber}  ${userCredential.user.photoURL}  ${userCredential.user.uid}");
          // _socialLogin(params: params);
          _userController.loginWithFacebook(
              accessToken: "${result.accessToken?.token ?? ""}");
          break;

        case LoginStatus.failed:
          _userController.showError(msg: result.message ?? "");
          break;
        case LoginStatus.cancelled:
          _userController.showError(msg: result.message ?? "");
          break;
        default:
          return null;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> _appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: 'example-nonce',
        state: 'example-state',
      );

      log("Apple Login ==>  ${credential.userIdentifier}    ${credential.email}   ${credential.authorizationCode}");
      _userController.loginWithApple(
          socialUniqueId: credential.userIdentifier ?? "");
    } on SignInWithAppleAuthorizationException catch (e) {
      _userController.showError(msg: "${e.message}");
    } catch (e) {
      _userController.showError(msg: "$e");
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly'
    ],
    signInOption: SignInOption.standard,
    // clientId: AppString.googleSignInServerClientId,
    // hostedDomain: "predictive-host-314811.firebaseapp.com"
  );

  Future<void> _googleLogin() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    GoogleSignInAccount? _googleSignAccount = await _googleSignIn.signIn();

    if (_googleSignAccount != null) {
      GoogleSignInAuthentication? googleSignInAuthentication =
          await _googleSignAccount.authentication;
      log("GoogleSignInAuthentication   ==>    ${googleSignInAuthentication.accessToken}");
      _userController.loginWithGoogle(
          accessToken: googleSignInAuthentication.accessToken ?? "");
    }
  }
}
