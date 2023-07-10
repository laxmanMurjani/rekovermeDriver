import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mozlit_driver/controller/user_controller.dart';
import 'package:mozlit_driver/enum/error_type.dart';
import 'package:mozlit_driver/ui/authentication_screen/sign_up_screen.dart';
import 'package:mozlit_driver/ui/widget/custom_button.dart';
import 'package:mozlit_driver/ui/widget/no_internet_widget.dart';
import 'package:mozlit_driver/util/app_constant.dart';

class TowOrRoadRegister extends StatefulWidget {
  const TowOrRoadRegister({Key? key}) : super(key: key);

  @override
  State<TowOrRoadRegister> createState() => _TowOrRoadRegisterState();
}

class _TowOrRoadRegisterState extends State<TowOrRoadRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GetX<UserController>(
        builder: (cont) {
      if (cont.error.value.errorType == ErrorType.internet) {
        return NoInternetWidget();
      }
      return Stack(
        children: [
          SizedBox(height: double.infinity,width: double.infinity,),

          termsConditionWidget(),

          SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                logoWidget(),

                SizedBox(height: MediaQuery.of(context).size.height*0.03,),

                firstButton(),

                SizedBox(height: 25.h),

                Text('Or',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),

                SizedBox(height: 25.h),

                secondButton(),
              ])),
        ],
      );})
    );
  }

  Widget termsConditionWidget(){
    return Align(alignment: Alignment.bottomCenter,
        child: SizedBox(height: 50,child:
        Column(
          children: [
            Text('By Continuing, You Agree to our',
              style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400),),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Terms of use',style: TextStyle(color: Color(0xFF297FFF), fontSize: 12,fontWeight: FontWeight.w400),),
                Text(' and ',style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w400),),
                Text('Privacy Policy',style: TextStyle(color: Color(0xFF297FFF), fontSize: 12,fontWeight: FontWeight.w400),),
              ],
            )
          ],
        ),
        ));
  }

  Widget logoWidget(){
    return SizedBox(height: MediaQuery.of(context).size.height*0.4,
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
                'Register'.tr,
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
    );
  }

  Widget firstButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomButton(bgColor: AppColors.primaryColor,
        text: "Tow Driver",
        onTap: () {
          Get.to(() => SignUpScreen(isTow: true));
          // cont.registerUser();
          //Get.to(() => LoginScreen());
        },
      ),
    );
  }

  Widget secondButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomButton(bgColor: AppColors.primaryColor,
        text: "Road side serviceman",
        onTap: () {
          Get.to(() => SignUpScreen(isTow: false));
          // cont.registerUser();
          //Get.to(() => LoginScreen());
        },
      ),
    );
  }
}
