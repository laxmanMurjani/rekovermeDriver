import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/cutom_appbar.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class OtpScreenForRegistration extends StatefulWidget {
  Map<String, dynamic> params;
  OtpScreenForRegistration({required this.params});

  @override
  State<OtpScreenForRegistration> createState() => _OtpScreenForRegistrationState();
}

class _OtpScreenForRegistrationState extends State<OtpScreenForRegistration> {
  String _otp = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "verification_code".tr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: GetX<UserController>(builder: (cont) {
          if ((cont.error.value.errorType == ErrorType.internet)) {
            return NoInternetWidget();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "please type the verification code sent to your number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.gray,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              OtpTextField(
                numberOfFields: 4,
                borderColor: AppColors.primaryColor,
                showFieldAsBox: true,
                fillColor: Colors.white,
                enabledBorderColor: AppColors.primaryColor,
                focusedBorderColor: AppColors.primaryColor,
                disabledBorderColor: AppColors.gray,
                autoFocus: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                  _otp = code;
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  _otp = verificationCode;
                  print("object  ==>  $_otp");
                }, // end onSubmit
              ),
              SizedBox(height: 20.h),
              CustomButton(
                bgColor: AppColors.skyBlue,
                textColor: AppColors.primaryColor,
                text: "continue".tr,
                onTap: () {
                  if (_otp.length != 4) {
                    cont.showError(msg: "please_enter_otp".tr);
                    return;
                  }
                  // if (_otp != widget.params["otp"].toString()) {
                  //   cont.showError(msg: "please_enter_valid_otp".tr);
                  //   return;
                  // }
                  if(widget.params["login_by"] == "facebook"){
                    cont.loginWithFacebook(accessToken: "",data: widget.params);
                  } else if(widget.params["login_by"] == "google"){
                    cont.loginWithGoogle(accessToken: "",data: widget.params);
                  }else if(widget.params["login_by"] == "apple"){
                    cont.loginWithApple(socialUniqueId: "",data: widget.params);
                  }
                  cont.verifyOTpForRegistration(_otp, widget.params['mobile']);
                },
                fontSize: 16.sp,
              ),
              SizedBox(height: 20.h),
              RichText(
                text: TextSpan(
                  text: "didn`t_get_the_otp".tr,
                  style: TextStyle(
                    color: AppColors.drawer.withOpacity(0.8),
                  ),
                  children: [
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {

                        },
                        child: Text(
                          " "+"resend_otp".tr,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
