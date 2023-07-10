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
  final bool isTow;
  const VehicleSignUpScreen({Key? key, required this.isTow}) : super(key: key);
  @override
  _VehicleSignUpScreenState createState() => _VehicleSignUpScreenState();
}

class _VehicleSignUpScreenState extends State<VehicleSignUpScreen> {
  final UserController _userController = Get.find();
  Map<String, dynamic> params = Map();
  List selectedServicesList = [];

  @override
  void initState() {
    super.initState();

    // _userController.clearFormData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userController.getServiceType(widget.isTow? 'Tow' : 'ROADSIDESERVICE');
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
              logoWidget(),
              titleAndFormWidget(cont),
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
              termsAndCondition(cont),
              createAccountButton(cont),

            ],
          ),
        );
      }),
    );
  }

  Widget logoWidget(){
    return SizedBox(height: MediaQuery.of(context).size.height*0.325,child:
    Stack(children: [
      Positioned(top: -550,left: -300,right: -300,
          child: CircleAvatar(backgroundColor: AppColors.skyBlue,radius: 400,)),
      Align(alignment: Alignment.topCenter,child:
      Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(children: [
          Image.asset(AppImage.rekovermeDriverLogo,width: 180,height: 180,),
        ],),
      ),),
    ],),);
  }

  Widget titleAndFormWidget(cont){
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleWidget(widget.isTow? "Vehicle_Registration".tr : 'Road Side Serviceman'),

          widget.isTow? serviceTypeDropdown(cont) : licensePlateTextField(cont),

          widget.isTow? truckMakeTextField(cont) : insuranceTextField(cont),

          widget.isTow? licensePlateNumberTextField(cont) : selectServicesWidget(cont),
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
    );
  }

  Widget titleWidget(title){
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24.sp,
            color: Colors.black),
      ),
    );
  }

  Widget serviceTypeDropdown(cont){
    return Container(margin: EdgeInsets.only(bottom: 15.h),height: 50, width: double.infinity,decoration: BoxDecoration(
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
        items: cont.serviceTypeList.map<DropdownMenuItem<ServiceType>>((location) {
          return DropdownMenuItem<ServiceType>(
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
    ));
  }

  Widget truckMakeTextField(cont){
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: CustomTextFiled(
          controller: cont.carModelController,
          label: "Truck make".tr,
          hint: "Truck make".tr,fillColor: AppColors.white,filled: true),
    );
  }

  Widget licensePlateNumberTextField(cont){
    return CustomTextFiled(
        controller: cont.carNumberController,
        label: "License plate number".tr,
        hint: "License plate number".tr,fillColor: AppColors.white,filled: true);
  }

  Widget licensePlateTextField(cont){
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: CustomTextFiled(
          controller: cont.licenseNumberController,
          label: "Enter License Number".tr,
          hint: "Enter License Number".tr,fillColor: AppColors.white,filled: true),
    );
  }

  Widget insuranceTextField(cont){
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: CustomTextFiled(
          controller: cont.insuranceNumberController,
          label: "Enter IN".tr,
          hint: "Enter IN".tr,fillColor: AppColors.white,filled: true),
    );
  }

  Widget selectServicesWidget(cont){
    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
      child: Column(children: [
        Row(children: [Text('Select Services',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),],),

        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: cont.serviceTypeList.length,
            itemBuilder: (BuildContext context, int index) {
            var val = cont.serviceTypeList[index].id;
              return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Text('${cont.serviceTypeList[index].name}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                Checkbox(
                  value: selectedServicesList.contains(cont.serviceTypeList[index].id),
                  onChanged: (bool? value) {
                    setState(() {
                      value == true? selectedServicesList.add(val) : selectedServicesList.remove(val);
                    });
                  },
                ),
              ],);
            }),
      ],),
    );
  }

  Widget termsAndCondition(cont){
    return Row(
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
    );
  }

  Widget createAccountButton(cont){
    return InkWell(
      onTap: () {
        //print(cont.countryCode.toString());
        // print('lic ${cont.licenseNumberController.text}');
        // print('ins ${cont.insuranceNumberController.text}');
        // print('services ${selectedServicesList.toString()}');
        widget.isTow? cont.registerUser() : cont.registerRoadSideDriver(selectedServicesList);
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 5),
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
    );
  }
}
