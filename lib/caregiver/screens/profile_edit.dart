// ignore_for_file: use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unrelated_type_equality_checks

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/progress_dialog.dart';

// import '../../utils/utils.dart';
// import 'package:dio/dio.dart';
// class ProfileGiverEdit extends StatefulWidget {
//   const ProfileGiverEdit({
//     Key? key,
//   }) : super(key: key);
//   @override
//   State<ProfileGiverEdit> createState() => _ProfileGiverEditState();
// }
// class _ProfileGiverEditState extends State<ProfileGiverEdit> {
//   var _isSelectedGender = "1";
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController zipController = TextEditingController();
//   final TextEditingController userInfoController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController experienceController = TextEditingController();
//   final TextEditingController hourlyController = TextEditingController();
//   final TextEditingController availabilityController = TextEditingController();
//   final TextEditingController keywordController = TextEditingController();
//   final TextEditingController instituteController = TextEditingController();
//   final TextEditingController majorController = TextEditingController();
//   final TextEditingController fromController = TextEditingController();
//   final TextEditingController toController = TextEditingController();
//   var isPeriodSeleted = "0";
//   void _toggleradio() {
//     if (isPeriodSeleted == "0") {
//       setState(() {
//         isPeriodSeleted = "1";
//       });
//     } else {
//       {
//         setState(() {
//           isPeriodSeleted = "0";
//         });
//       }
//     }
//   }
//   List<Map<String, String>> education = [];
//   var arr1 = [];
//   List instituteMapList = [];
//   List majorMapList = [];
//   List startDateMapList = [];
//   List endDateMapList = [];
//   List currentMapList = [];
//   var stringListData = [];
//   FilePickerResult? enhanceResult;
// // DatePicker
//   var getPickedDate;
//   var gettoPickedDate;
//   var getfromPickedDate;
//   DateTime? selectedDate = DateTime.now();
//   var myFormat = DateFormat('d-MM-yyyy');
//   _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate!,
//       firstDate: DateTime(1930),
//       lastDate: DateTime(2050),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.fromSwatch(
//               primarySwatch: Colors.teal,
//               primaryColorDark: CustomColors.primaryColor,
//               accentColor: const Color(0xff55CE86),
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       dobController.text = DateFormat('yyyy-MM-dd').format(picked);
//       // print(dobController);
//       // print("picked $picked");
//       picked == dobController;
//       // print("controller ${dobController.text}");
//       setState(() {
//         getPickedDate = dobController.text;
//       });
//       // print("GetPickedDate $getPickedDate");
//     }
//   }
//   _fromDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate!,
//       firstDate: DateTime(1930),
//       lastDate: DateTime(2050),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.fromSwatch(
//               primarySwatch: Colors.teal,
//               primaryColorDark: CustomColors.primaryColor,
//               accentColor: const Color(0xff55CE86),
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       fromController.text = DateFormat('yyyy-MM-dd').format(picked);
//       // print(fromController);
//       // print("picked $picked");
//       picked == fromController;
//       // print("fromcontroller ${fromController.text}");
//       setState(() {
//         getfromPickedDate = fromController.text;
//       });
//       // print("GetfromPickedDate $getfromPickedDate");
//     }
//   }
//   _toDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate!,
//       firstDate: DateTime(1930),
//       lastDate: DateTime(2050),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.fromSwatch(
//               primarySwatch: Colors.teal,
//               primaryColorDark: CustomColors.primaryColor,
//               accentColor: const Color(0xff55CE86),
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       toController.text = DateFormat('yyyy-MM-dd').format(picked);
//       // print(toController);
//       // print("picked $picked");
//       picked == toController;
//       // print("tocontroller ${toController.text}");
//       setState(() {
//         gettoPickedDate = toController.text;
//       });
//       // print("GettoPickedDate $gettoPickedDate");
//     }
//   }
//   List educationApiList = [];
//   late Future<ProfileGiverModel> fetchProfileEdit;
//   Future<ProfileGiverModel> fetchProfileGiverModelEdit() async {
//     var token = await getUserToken();
//     final response = await http.get(
//         Uri.parse(
//           CareGiverUrl.serviceProviderProfile,
//         ),
//         headers: {
//           'Authorization': 'Bearer $token',
//           "Accept": "application/json",
//         });
//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body) as Map<String, dynamic>;
//       final data = body["data"] as List<dynamic>;
//       // final listEdu = body['data']['educations'] as List<dynamic>;
//       final responseeducationListApi = data.map((d) => (d as Map<String, dynamic>)["educations"].toString()).toList();
//       // print("responseeducationListApi== $responseeducationListApi");
//       setState(() {
//         educationApiList = responseeducationListApi;
//       });
//       // print(jsonDecode(response.body));
//       return ProfileGiverModel.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception(
//         customErrorSnackBar('Failed to load Profile Model', context),
//       );
//     }
//   }
//   // Image Picking
//   ProgressDialog? pr;
//   void showProgress(context) async {
//     pr ??= ProgressDialog(context);
//     await pr!.show();
//  }
//   void hideProgress() async {
//     if (pr != null && pr!.isShowing()) {
//       await pr!.hide();
//     }
//   }
//   File? image;
//   File? imageFileDio;
//   final picker = ImagePicker();
//   final _pickerDio = ImagePicker();
//   bool showSpinner = false;
//   var myimg;
//   Future getImageDio() async {
//     XFile? pickedFileDio = await _pickerDio.pickImage(source: ImageSource.gallery, imageQuality: 80);
//     if (pickedFileDio != null) {
//       setState(() {
//         imageFileDio = File(pickedFileDio.path);
//       });
//     } else {
//       // print("No image selected");
//     }
//   }
//   // Future getEnhancePdf() async {
//   //   FilePickerResult? result = await FilePicker.platform.pickFiles();
//   //   if (result != null) {
//   //     File pdfFileEnhance = File(result.files.single.path ?? " ");
//  //     String? enhanceFileName = pdfFileEnhance.path.split('/').last;
//   //     String? enhancePath = pdfFileEnhance.path;
//   //   }
//   // }
//   String? _getEnhanceFile;
//   String? _getBasicFile;
//   String? _getFirstAidFile;
//   String? _getVehicleRecordFile;
//   Future getEnhancedPdfFile() async {
//     FilePickerResult? file = await FilePicker.platform.pickFiles();
//     if (file != null) {
//       File pdfFileEnhance = File(file.files.single.path ?? " ");
//       // String? enhanceFileName = pdfFileEnhance.path.split('/').last;
//       String? enhancePath = pdfFileEnhance.path;
//       setState(() {
//         _getEnhanceFile = enhancePath;
//         // print("_getEnhanceFile = $_getEnhanceFile");
//       });
//     }
//   }
//   Future getBasicFile() async {
//     FilePickerResult? file = await FilePicker.platform.pickFiles();
//     if (file != null) {
//       File pdfFileEnhance = File(file.files.single.path ?? " ");
//       // String? enhanceFileName = pdfFileEnhance.path.split('/').last;
//       String? enhancePath = pdfFileEnhance.path;
//       setState(() {
//         _getBasicFile = enhancePath;
//         // print("_getBasicFile = $_getBasicFile");
//       });
//     }
//   }
//   Future getFirstAidFile() async {
//     FilePickerResult? file = await FilePicker.platform.pickFiles();
//     if (file != null) {
//       File pdfFileEnhance = File(file.files.single.path ?? " ");
//       // String? enhanceFileName = pdfFileEnhance.path.split('/').last;
//       String? enhancePath = pdfFileEnhance.path;
//       setState(() {
//         _getFirstAidFile = enhancePath;
//         // print("_getFirstAidFile = $_getFirstAidFile");
//       });
//     }
//   }
//   Future getVehicleRecordFile() async {
//     FilePickerResult? file = await FilePicker.platform.pickFiles();
//     if (file != null) {
//       File pdfFileEnhance = File(file.files.single.path ?? " ");
//       // String? enhanceFileName = pdfFileEnhance.path.split('/').last;
//       String? enhancePath = pdfFileEnhance.path;
//       setState(() {
//         _getVehicleRecordFile = enhancePath;
//         // print("_getVehicleRecordFile = $_getVehicleRecordFile");
//       });
//     }
//   }
//   uploadImageDio() async {
//     var usersId = await getUserId();
//     var token = await getUserToken();
//     // FilePickerResult? result = await FilePicker.platform.pickFiles();
//     //   if(result!=null){
//     //     File pdfFileEnhance = File(result.files.single.path??" ");
//     //     String? enhanceFileName = pdfFileEnhance.path.split('/').last;
//     //     String? enhancePath = pdfFileEnhance.path;
//     // }
//     // File pdfFileEnhance = File(result?.files.single.path ?? " ");
//     // String? enhanceFileName = pdfFileEnhance.path.split('/').last;
//     // String? enhancePath = pdfFileEnhance.path;
//     var formData = FormData.fromMap(
//       {
//         '_method': 'PUT',
//         'user_info': userInfoController.text.toString(),
//         'phone': phoneController.text.toString(),
//         'address': addressController.text.toString(),
//         'gender': _isSelectedGender,
//         'dob': dobController.text.toString(),
//         'zip': zipController.text.toString(),
//         'experience': experienceController.text.toString(),
//         'hourly_rate': hourlyController.text.toString(),
//         'availability': availabilityController.text.toString(),
//         'keywords': keywordController.text.toString(),
//         "avatar": await MultipartFile.fromFile(imageFileDio!.path),
//         "enhanced_criminal": await MultipartFile.fromFile(_getEnhanceFile.toString()),
//         "basic_criminal": await MultipartFile.fromFile(_getBasicFile.toString()),
//         "first_aid": await MultipartFile.fromFile(_getFirstAidFile.toString()),
//         "vehicle_record": await MultipartFile.fromFile(_getVehicleRecordFile.toString()),
//       },
//     );
//     for (var element in instituteMapList) {
//       formData.fields.add(MapEntry("institute_name[]", element.toString()));
//     }
//     for (var element in startDateMapList) {
//       formData.fields.add(MapEntry("start_date[]", element.toString()));
//     }
//     for (var element in endDateMapList) {
//       formData.fields.add(MapEntry("end_date[]", element.toString()));
//     }
//     for (var element in currentMapList) {
//       formData.fields.add(MapEntry("current[]", element.toString()));
//     }
//     for (var element in majorMapList) {
//       formData.fields.add(MapEntry("major[]", element.toString()));
//     }
//     Dio dio = Dio();
//     try {
//       var response = await dio.post('http://192.168.0.244:9999/api/service-provider-profile/$usersId', data: formData, options: Options(contentType: 'application/json', followRedirects: false, validateStatus: (status) => true, headers: {"Accept": "application/json", "Authorization": "Bearer $token"}));
//       // dio.options.headers['Accept'] = 'application/json';
//       // dio.options.headers["Authorization"] = "Bearer ${token}";
//       // print("DioREsponse = ${response.toString()}");
//     } catch (e) {
//       // print(e);
//     }
//   }
//   //Upload PDF
//   Future uploadPdf() async {
//     var dio = Dio();
//     // FilePickerResult? result
//   }
//   getUserToken() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     var userToken = preferences.getString(
//       'userToken',
//     );
//     // print(userToken);
//     return userToken.toString();
//   }
//   getUserId() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     var userId = preferences.getString(
//       'userId',
//     );
//     // print(userId);
//     return userId.toString();
//   }
//   @override
//   void initState() {
//     getUserToken();
//     getUserId();
//     // print("educationListtt $education");
//     super.initState();
//     // this.getSWData();
//     fetchProfileEdit = fetchProfileGiverModelEdit();
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     dobController.dispose();
//     nameController.dispose();
//     zipController.dispose();
//     userInfoController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     experienceController.dispose();
//     hourlyController.dispose();
//     availabilityController.dispose();
//     keywordController.dispose();
//     instituteController.dispose();
//     majorController.dispose();
//     fromController.dispose();
//     toController.dispose();
//   }
//   int selectedIndex = -1;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: CustomColors.loginBg,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: CustomColors.primaryColor,
//           centerTitle: true,
//           title: Text(
//             "Profile Edit",
//             style: TextStyle(
//               fontSize: 20,
//               color: CustomColors.white,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Rubik",
//             ),
//           ),
//           actions: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const NotificationScreen(),
//                   ),
//                 );
//               },
//               child: const Padding(
//                 padding: EdgeInsets.all(12.0),
//                 // child: Badge(
//                 //   elevation: 0,
//                 //   badgeContent: const Text(""),
//                 //   badgeColor: CustomColors.red,
//                 //   position: BadgePosition.topStart(start: 18),
//                 //   child: const Icon(
//                 //     Icons.notifications_none,
//                 //     size: 30,
//                 //   ),
//                 // ),
//               ),
//             )
//           ],
//         ),
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 18),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Text(
//                         "Personal Information",
//                         style: TextStyle(
//                           color: CustomColors.primaryText,
//                           fontFamily: "Rubik",
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       // Upload Image
//                       GestureDetector(
//                         onTap: () {
//                           getImageDio();
//                         },
//                         child: imageFileDio == null
//                             ? Center(
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   height: 100.45,
//                                   width: 100.45,
//                                   // padding: const EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     color: CustomColors.primaryColor,
//                                     borderRadius: BorderRadius.circular(100),
//                                     boxShadow: const [
//                                       BoxShadow(
//                                         color: Color.fromARGB(15, 0, 0, 0),
//                                         blurRadius: 4,
//                                         spreadRadius: 4,
//                                         offset: Offset(2, 2), // Shadow position
//                                       ),
//                                     ],
//                                   ),
//                                   child: const Center(child: Text("Upload")),
//                                 ),
//                               )
//                             : Center(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(100),
//                                   child: Image.file(
//                                     imageFileDio!,
//                                     width: 100,
//                                     height: 100,
//                                     fit: BoxFit.fitWidth,
//                                   ),
//                                 ),
//                               ),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       // Gender
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Gender",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         _isSelectedGender = "1";
//                                         // print(_isSelectedGender);
//                                       });
//                                     },
//                                     child: Container(
//                                       height: 50.45,
//                                       // width: 149.49,
//                                       padding: const EdgeInsets.all(4),
//                                       decoration: BoxDecoration(
//                                         color: _isSelectedGender == "1" ? CustomColors.primaryColor : CustomColors.white,
//                                         borderRadius: BorderRadius.circular(8),
//                                         boxShadow: const [
//                                           BoxShadow(
//                                             color: Color.fromARGB(15, 0, 0, 0),
//                                             blurRadius: 4,
//                                             spreadRadius: 4,
//                                             offset: Offset(2, 2), // Shadow position
//                                           ),
//                                         ],
//                                       ),
//                                       child: TextButton(
//                                         style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
//                                         onPressed: () {
//                                           setState(() {
//                                             _isSelectedGender = "1";
//                                             // print(_isSelectedGender);
//                                           });
//                                         },
//                                         child: Text(
//                                           "Male",
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             color: _isSelectedGender == "1" ? CustomColors.white : CustomColors.primaryText,
//                                             fontFamily: "Rubik",
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w300,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 15,
//                                 ),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         _isSelectedGender = "2";
//                                         // print(_isSelectedGender);
//                                       });
//                                     },
//                                     child: Container(
//                                       height: 50.45,
//                                       // width: 149.49,
//                                       padding: const EdgeInsets.all(4),
//                                       decoration: BoxDecoration(
//                                         color: _isSelectedGender == "2" ? CustomColors.primaryColor : CustomColors.white,
//                                         borderRadius: BorderRadius.circular(8),
//                                         boxShadow: const [
//                                           BoxShadow(
//                                             color: Color.fromARGB(15, 0, 0, 0),
//                                             blurRadius: 4,
//                                             spreadRadius: 4,
//                                             offset: Offset(2, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: TextButton(
//                                         style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
//                                         onPressed: () {
//                                           setState(() {
//                                             _isSelectedGender = "2";
//                                             // print(_isSelectedGender);
//                                           });
//                                         },
//                                         child: Text(
//                                           "Female",
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             color: _isSelectedGender == "2" ? CustomColors.white : CustomColors.primaryText,
//                                             fontFamily: "Rubik",
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w300,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Phone Number
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Phone Number",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             TextFormField(
//                               controller: phoneController,
//                               keyboardType: TextInputType.number,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlignVertical: TextAlignVertical.bottom,
//                               maxLines: 1,
//                               decoration: InputDecoration(
//                                 hintText: "Phone Number",
//                                 fillColor: CustomColors.white,
//                                 focusColor: CustomColors.white,
//                                 hoverColor: CustomColors.white,
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // DOB
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Date Of Birth",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             CustomTextFieldWidget(
//                               borderColor: CustomColors.white,
//                               obsecure: false,
//                               keyboardType: TextInputType.number,
//                               controller: dobController,
//                               onChanged: (value) {
//                                 setState(() {
//                                   getPickedDate = value;
//                                 });
//                               },
//                               hintText: "DOB",
//                               onTap: () async {
//                                 _selectDate(context);
//                                 // DateTime? pickedDate = await showDatePicker(
//                                 //     context: context,
//                                 //     initialDate: DateTime.now(),
//                                 //     firstDate: DateTime(1950),
//                                 //     lastDate: DateTime(2050));
//                                 // if (pickedDate != null) {
//                                 //   dobController.text =
//                                 //       DateFormat('dd MMMM yyyy').format(pickedDate);
//                                 // }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Experrience
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Years Of Experience",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             TextFormField(
//                               controller: experienceController,
//                               keyboardType: TextInputType.number,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlignVertical: TextAlignVertical.bottom,
//                               maxLines: 1,
//                               decoration: InputDecoration(
//                                 hintText: "Experience",
//                                 fillColor: CustomColors.white,
//                                 focusColor: CustomColors.white,
//                                 hoverColor: CustomColors.white,
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Hourly
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Hourly Rate",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             TextFormField(
//                               controller: hourlyController,
//                               keyboardType: TextInputType.number,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlignVertical: TextAlignVertical.bottom,
//                               maxLines: 1,
//                               decoration: InputDecoration(
//                                 hintText: "Hourly",
//                                 fillColor: CustomColors.white,
//                                 focusColor: CustomColors.white,
//                                 hoverColor: CustomColors.white,
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // User Address
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "User Address",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             TextFormField(
//                               controller: addressController,
//                               keyboardType: TextInputType.multiline,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlignVertical: TextAlignVertical.bottom,
//                               maxLines: 4,
//                               decoration: InputDecoration(
//                                 hintText: "User Address",
//                                 fillColor: CustomColors.white,
//                                 focusColor: CustomColors.white,
//                                 hoverColor: CustomColors.white,
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Zip Code
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Zip Code",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             TextFormField(
//                               controller: zipController,
//                               keyboardType: TextInputType.number,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlignVertical: TextAlignVertical.bottom,
//                               maxLines: 1,
//                               decoration: InputDecoration(
//                                 hintText: "Zip Code",
//                                 fillColor: CustomColors.white,
//                                 focusColor: CustomColors.white,
//                                 hoverColor: CustomColors.white,
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // AdditionalService
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Additional Services",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             TextFormField(
//                               controller: keywordController,
//                               keyboardType: TextInputType.multiline,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlignVertical: TextAlignVertical.bottom,
//                               maxLines: 3,
//                               decoration: InputDecoration(
//                                 hintText: "abc, abc, abc",
//                                 fillColor: CustomColors.white,
//                                 focusColor: CustomColors.white,
//                                 hoverColor: CustomColors.white,
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Education
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Education",
//                             style: TextStyle(
//                               color: CustomColors.primaryText,
//                               fontSize: 16,
//                               fontFamily: "Poppins",
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return StatefulBuilder(builder: (context, setState) {
//                                     return AlertDialog(
//                                       content: SingleChildScrollView(
//                                         scrollDirection: Axis.vertical,
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: <Widget>[
//                                             const Text("Add Education"),
//                                             // Institute Name
//                                             Container(
//                                               height: 50,
//                                               margin: const EdgeInsets.only(bottom: 15, top: 15),
//                                               decoration: BoxDecoration(
//                                                 color: CustomColors.white,
//                                                 borderRadius: BorderRadius.circular(12),
//                                               ),
//                                               child: TextFormField(
//                                                 controller: instituteController,
//                                                 keyboardType: TextInputType.name,
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                   fontFamily: "Rubik",
//                                                   fontWeight: FontWeight.w400,
//                                                 ),
//                                                 textAlignVertical: TextAlignVertical.bottom,
//                                                 maxLines: 1,
//                                                 decoration: InputDecoration(
//                                                   hintText: "Institute Name",
//                                                   fillColor: CustomColors.myJobDetail,
//                                                   focusColor: CustomColors.white,
//                                                   hoverColor: CustomColors.white,
//                                                   filled: true,
//                                                   border: OutlineInputBorder(
//                                                     borderRadius: BorderRadius.circular(10),
//                                                   ),
//                                                   focusedBorder: OutlineInputBorder(
//                                                     borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                                     borderRadius: BorderRadius.circular(10.0),
//                                                   ),
//                                                   enabledBorder: OutlineInputBorder(
//                                                     borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                                     borderRadius: BorderRadius.circular(10.0),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             // Major
//                                             Container(
//                                               height: 50,
//                                               decoration: BoxDecoration(
//                                                 color: CustomColors.white,
//                                                 borderRadius: BorderRadius.circular(12),
//                                               ),
//                                               child: TextFormField(
//                                                 controller: majorController,
//                                                 keyboardType: TextInputType.name,
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                   fontFamily: "Rubik",
//                                                   fontWeight: FontWeight.w400,
//                                                 ),
//                                                 textAlignVertical: TextAlignVertical.bottom,
//                                                 maxLines: 1,
//                                                 decoration: InputDecoration(
//                                                   hintText: "Major",
//                                                   fillColor: CustomColors.myJobDetail,
//                                                   focusColor: CustomColors.white,
//                                                   hoverColor: CustomColors.white,
//                                                   filled: true,
//                                                   border: OutlineInputBorder(
//                                                     borderRadius: BorderRadius.circular(10),
//                                                   ),
//                                                   focusedBorder: OutlineInputBorder(
//                                                     borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                                     borderRadius: BorderRadius.circular(10.0),
//                                                   ),
//                                                   enabledBorder: OutlineInputBorder(
//                                                     borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                                     borderRadius: BorderRadius.circular(10.0),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             // Time period
//                                             const SizedBox(
//                                               height: 15,
//                                             ),
//                                             TextButton.icon(
//                                               style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
//                                               onPressed: () {
//                                                 _toggleradio();
//                                                 setState(() {});
//                                                 // print(isPeriodSeleted);
//                                               },
//                                               icon: CircleAvatar(
//                                                 backgroundColor: const Color.fromARGB(181, 171, 171, 171),
//                                                 radius: 8,
//                                                 child: CircleAvatar(
//                                                   radius: 4,
//                                                   backgroundColor: isPeriodSeleted == "1" ? CustomColors.primaryText : const Color.fromARGB(181, 171, 171, 171),
//                                                 ),
//                                               ),
//                                               label: Text(
//                                                 "Currently Studying?",
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   color: CustomColors.primaryText,
//                                                   fontFamily: "Rubik",
//                                                   fontStyle: FontStyle.normal,
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w400,
//                                                 ),
//                                               ),
//                                             ),
//                                             // From
//                                             Container(
//                                               height: 50,
//                                               decoration: BoxDecoration(
//                                                 color: CustomColors.myJobDetail,
//                                                 borderRadius: BorderRadius.circular(12),
//                                               ),
//                                               child: CustomTextFieldWidget(
//                                                 borderColor: CustomColors.white,
//                                                 obsecure: false,
//                                                 keyboardType: TextInputType.number,
//                                                 controller: fromController,
//                                                 hintText: "From",
//                                                 onTap: () async {
//                                                   _fromDate(context);
//                                                 },
//                                               ),
//                                             ),
//                                             // To
//                                             const SizedBox(
//                                               height: 15,
//                                             ),
//                                             Container(
//                                               height: 50,
//                                               decoration: BoxDecoration(
//                                                 color: CustomColors.myJobDetail,
//                                                 borderRadius: BorderRadius.circular(12),
//                                               ),
//                                               child: CustomTextFieldWidget(
//                                                 borderColor: CustomColors.white,
//                                                 obsecure: false,
//                                                 keyboardType: TextInputType.number,
//                                                 controller: toController,
//                                                 hintText: "To",
//                                                 onTap: () async {
//                                                   _toDate(context);
//                                                 },
//                                               ),
//                                             ),
//                                             // AddBtn
//                                             GestureDetector(
//                                               onTap: () async {
//                                                 {
//                                                   //
//                                                   String institute = instituteController.text.trim();
//                                                   String major = majorController.text.trim();
//                                                   String from = fromController.text.toString();
//                                                   String to = toController.text.toString();
//                                                   if (institute.isNotEmpty && major.isNotEmpty) {
//                                                     instituteController.text = '';
//                                                     majorController.text = '';
//                                                     fromController.text = '';
//                                                     toController.text = '';
//                                                     setState(() {
//                                                       instituteMapList.add(institute);
//                                                       majorMapList.add(major);
//                                                       startDateMapList.add(from);
//                                                       endDateMapList.add(to);
//                                                       currentMapList.add(isPeriodSeleted);
//                                                       // print(" asdas $instituteMapList $majorMapList");
//                                                     });
//                                                     setState(() {
//                                                       instituteController.text = '';
//                                                       majorController.text = '';
//                                                       fromController.text = '';
//                                                       toController.text = '';
//                                                       // education.add(
//                                                       //   {
//                                                       //     "institute_name[]":
//                                                       //         institute,
//                                                       //     "major[]": major,
//                                                       //     "start_date[]": from,
//                                                       //     "current[]": "1",
//                                                       //     "end_date[]": to,
//                                                       //   },
//                                                       // );
//                                                     });
//                                                     SharedPreferences pref = await SharedPreferences.getInstance();
//                                                     var data = await pref.setString('ListData', education.toString());
//                                                     // print(data);
//                                                     // print("educationListtt2 $education");
//                                                     Navigator.pop(context, true);
//                                                     // print("object = $jsonser");
//                                                   }
//                                                 }
//                                               },
//                                               child: Container(
//                                                 width: MediaQuery.of(context).size.width,
//                                                 height: 50,
//                                                 margin: const EdgeInsets.only(top: 20),
//                                                 decoration: BoxDecoration(
//                                                   gradient: LinearGradient(
//                                                     begin: Alignment.center,
//                                                     end: Alignment.center,
//                                                     colors: [
//                                                       const Color(0xff90EAB4).withOpacity(0.1),
//                                                       const Color(0xff6BD294).withOpacity(0.8),
//                                                     ],
//                                                   ),
//                                                   color: CustomColors.white,
//                                                   boxShadow: const [
//                                                     BoxShadow(
//                                                       color: Color.fromARGB(13, 0, 0, 0),
//                                                       blurRadius: 4.0,
//                                                       spreadRadius: 2.0,
//                                                       offset: Offset(2.0, 2.0),
//                                                     ),
//                                                   ],
//                                                   borderRadius: BorderRadius.circular(6),
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     "Save",
//                                                     style: TextStyle(
//                                                       color: CustomColors.white,
//                                                       fontSize: 16,
//                                                       fontWeight: FontWeight.w600,
//                                                       fontFamily: "Rubik",
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   });
//                                 },
//                               );
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: CustomColors.primaryColor,
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(
//                                 "Add Education",
//                                 style: TextStyle(
//                                   color: CustomColors.white,
//                                   fontSize: 13,
//                                   fontFamily: "Poppins",
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         child: Column(
//                           children: [
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             // education.isEmpty
//                             //     ? const Text(
//                             //         '',
//                             //         style: TextStyle(fontSize: 22),
//                             //       )
//                             //     :
//                             SizedBox(
//                                 child: FutureBuilder<ProfileGiverModel>(
//                                     future: fetchProfileEdit,
//                                     builder: (context, snapshot) {
//                                       if (snapshot.hasData) {
//                                         return ListView.builder(
//                                             shrinkWrap: true,
//                                             scrollDirection: Axis.vertical,
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             itemCount: snapshot.data!.data![0].educations!.length,
//                                             itemBuilder: (context, index) {
//                                               return Stack(
//                                                 children: [
//                                                   Container(
//                                                     decoration: const BoxDecoration(
//                                                       color: Colors.transparent,
//                                                     ),
//                                                     alignment: Alignment.centerRight,
//                                                     width: MediaQuery.of(context).size.width,
//                                                     height: 100,
//                                                     child: const RotatedBox(
//                                                       quarterTurns: 1,
//                                                       child: Text(
//                                                         'Container 1',
//                                                         style: TextStyle(fontSize: 18.0, color: Colors.white),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Positioned(
//                                                     top: 25,
//                                                     right: 10,
//                                                     left: 3,
//                                                     bottom: 5,
//                                                     child: Container(
//                                                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                         decoration: BoxDecoration(
//                                                           color: CustomColors.white,
//                                                           borderRadius: BorderRadius.circular(10),
//                                                         ),
//                                                         alignment: Alignment.centerLeft,
//                                                         width: MediaQuery.of(context).size.width,
//                                                         // height: 100,
//                                                         child: Row(
//                                                           children: [
//                                                             SizedBox(
//                                                               width: MediaQuery.of(context).size.width * .80,
//                                                               child: Column(
//                                                                 children: [
//                                                                   Row(
//                                                                     children: [
//                                                                       Container(
//                                                                         alignment: Alignment.topLeft,
//                                                                         width: 100,
//                                                                         child: const Column(
//                                                                           children: [
//                                                                             Text("Institute Name:"),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       Expanded(
//                                                                         child: Text("${snapshot.data!.data![0].educations![index].name}"),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   Row(
//                                                                     children: [
//                                                                       Container(
//                                                                         alignment: Alignment.topLeft,
//                                                                         width: 100,
//                                                                         child: const Column(
//                                                                           children: [
//                                                                             Text("Major:"),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       Expanded(
//                                                                         // width: 300,
//                                                                         child: Text("${snapshot.data!.data![0].educations![index].major}"),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   Row(
//                                                                     children: [
//                                                                       Container(
//                                                                         alignment: Alignment.topLeft,
//                                                                         width: 100,
//                                                                         child: const Column(
//                                                                           children: [
//                                                                             Text("From:"),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       Expanded(
//                                                                         // width: 300,
//                                                                         child: Text("${snapshot.data!.data![0].educations![index].from}"),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         )
//                                                         // ListTile(
//                                                         //   title: Text( "Institute Name: ${snapshot.data!.data![0].educations![index].name}"),
//                                                         //   subtitle: Text("Major: ${snapshot.data!.data![0].educations![index].major}"),
//                                                         //   trailing: Text(snapshot.data!.data![0].educations![index].from.toString()),
//                                                         // ),
//                                                         ),
//                                                   ),
//                                                   Positioned(
//                                                     top: 10,
//                                                     right: -2,
//                                                     // left: 20,
//                                                     child: GestureDetector(
//                                                       onTap: (() {
//                                                         //
//                                                         setState(() {
//                                                           // education.removeAt(index);
//                                                           snapshot.data!.data![0].educations!.removeAt(index);
//                                                           instituteMapList.removeAt(index);
//                                                           majorMapList.removeAt(index);
//                                                           startDateMapList.removeAt(index);
//                                                           endDateMapList.removeAt(index);
//                                                           currentMapList.removeAt(index);
//                                                         });
//                                                       }),
//                                                       child: Container(
//                                                           decoration: BoxDecoration(
//                                                             borderRadius: const BorderRadius.only(
//                                                               topLeft: Radius.circular(100),
//                                                               bottomLeft: Radius.circular(100),
//                                                               bottomRight: Radius.circular(100),
//                                                               topRight: Radius.circular(100),
//                                                             ),
//                                                             color: CustomColors.white,
//                                                             boxShadow: const [
//                                                               BoxShadow(
//                                                                 color: Color.fromARGB(13, 0, 0, 0),
//                                                                 blurRadius: 4.0,
//                                                                 spreadRadius: 2.0,
//                                                                 offset: Offset(2.0, 2.0),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           alignment: Alignment.center,
//                                                           width: 30,
//                                                           height: 30,
//                                                           child: const Icon(
//                                                             Icons.close,
//                                                             size: 16,
//                                                           )),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               );
//                                             }
//                                             // getEducation(index),
//                                             );
//                                       } else {
//                                         return const Center(child: CircularProgressIndicator());
//                                       }
//                                     })),
//                           ],
//                         ),
//                       ),
//                       // Availability
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15, top: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Availability",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             TextFormField(
//                               controller: availabilityController,
//                               keyboardType: TextInputType.multiline,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlignVertical: TextAlignVertical.bottom,
//                               maxLines: 4,
//                               decoration: InputDecoration(
//                                 hintText: "Availability",
//                                 fillColor: CustomColors.white,
//                                 focusColor: CustomColors.white,
//                                 hoverColor: CustomColors.white,
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // User Info
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: CustomColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "User Info",
//                               style: TextStyle(
//                                 color: CustomColors.primaryColor,
//                                 fontSize: 12,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             TextFormField(
//                               controller: userInfoController,
//                               keyboardType: TextInputType.name,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Rubik",
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlignVertical: TextAlignVertical.bottom,
//                               maxLines: 1,
//                               decoration: InputDecoration(
//                                 hintText: "User Info",
//                                 fillColor: CustomColors.white,
//                                 focusColor: CustomColors.white,
//                                 hoverColor: CustomColors.white,
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: CustomColors.white, width: 0.0),
//                                   borderRadius: BorderRadius.circular(0.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Background Verified
//                       DottedBorder(
//                         radius: const Radius.circular(10),
//                         borderType: BorderType.RRect,
//                         color: CustomColors.primaryColor,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           decoration: BoxDecoration(
//                             color: CustomColors.primaryLight,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: ListTile(
//                             leading: Icon(
//                               Icons.workspace_premium,
//                               color: CustomColors.primaryColor,
//                             ),
//                             title: Text(
//                               "Background Varified",
//                               style: TextStyle(
//                                 color: CustomColors.primaryText,
//                                 fontSize: 12,
//                                 fontFamily: "Poppins",
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             subtitle: Text(
//                               "We encourage parents to conduct their own screenings using the background check tools. See what each of the badges covered, or learn more about keeping your family safe by visiting the Trust & Safety Center.",
//                               style: TextStyle(
//                                 color: CustomColors.primaryText,
//                                 fontSize: 10,
//                                 fontFamily: "Poppins",
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.picture_as_pdf_rounded,
//                               color: CustomColors.red,
//                             ),
//                             label: Text(
//                               "Enhanced Criminal",
//                               style: TextStyle(fontSize: 12, color: CustomColors.primaryText),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               getEnhancedPdfFile();
//                             },
//                             child: DottedBorder(
//                               padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
//                               radius: const Radius.circular(4),
//                               borderType: BorderType.RRect,
//                               color: CustomColors.primaryColor,
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.picture_as_pdf_rounded,
//                                     color: CustomColors.red,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     _getEnhanceFile.toString() == null ? "Quick File Uploader" : "File Selected",
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: CustomColors.primaryText,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.picture_as_pdf_rounded,
//                               color: CustomColors.red,
//                             ),
//                             label: Text(
//                               "Basic Criminal",
//                               style: TextStyle(fontSize: 12, color: CustomColors.primaryText),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               getBasicFile();
//                             },
//                             child: DottedBorder(
//                               padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
//                               radius: const Radius.circular(4),
//                               borderType: BorderType.RRect,
//                               color: CustomColors.primaryColor,
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.picture_as_pdf_rounded,
//                                     color: CustomColors.red,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     _getBasicFile.toString() == null ? "Quick File Uploader" : "File Selected",
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: CustomColors.primaryText,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.picture_as_pdf_rounded,
//                               color: CustomColors.red,
//                             ),
//                             label: Text(
//                               "First aid certification",
//                               style: TextStyle(fontSize: 12, color: CustomColors.primaryText),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               getFirstAidFile();
//                             },
//                             child: DottedBorder(
//                               padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
//                               radius: const Radius.circular(4),
//                               borderType: BorderType.RRect,
//                               color: CustomColors.primaryColor,
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.picture_as_pdf_rounded,
//                                     color: CustomColors.red,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     _getFirstAidFile.toString() == null ? "Quick File Uploader" : "File Selected",
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: CustomColors.primaryText,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                      const SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.picture_as_pdf_rounded,
//                               color: CustomColors.red,
//                             ),
//                             label: Text(
//                               "Vehicle Records",
//                               style: TextStyle(fontSize: 12, color: CustomColors.primaryText),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               getVehicleRecordFile();
//                             },
//                             child: DottedBorder(
//                               padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
//                               radius: const Radius.circular(4),
//                               borderType: BorderType.RRect,
//                               color: CustomColors.primaryColor,
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.picture_as_pdf_rounded,
//                                     color: CustomColors.red,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     _getVehicleRecordFile.toString() == null ? "Quick File Uploader" : "File Selected",
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: CustomColors.primaryText,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 0),
//                         child: GestureDetector(
//                           onTap: () async {
//                             if (imageFileDio == null) {
//                               customErrorSnackBar("Please Select Image", context);
//                             } else if (_isSelectedGender == null) {
//                               customErrorSnackBar("Please Select Gender", context);
//                             } else if (dobController.text.isEmpty) {
//                               customErrorSnackBar("Please Select Date Of Birth", context);
//                             } else if (zipController.text.isEmpty) {
//                               customErrorSnackBar("Please Enter Zip Code", context);
//                             } else if (phoneController.text.isEmpty) {
//                               customErrorSnackBar("Please Enter Phone Number", context);
//                             } else if (addressController.text.isEmpty) {
//                               customErrorSnackBar("Please Enter User Address", context);
//                             } else if (experienceController.text.isEmpty) {
//                               customErrorSnackBar("Please Enter User Experience", context);
//                             } else if (hourlyController.text.isEmpty) {
//                               customErrorSnackBar("Please Enter User Hourly Rate", context);
//                             } else if (availabilityController.text.isEmpty) {
//                               customErrorSnackBar("Please Enter User Availability", context);
//                             } else if (keywordController.text.isEmpty) {
//                               customErrorSnackBar("Please Enter User Keyword", context);
//                             } else {
//                               // uploadImage(image!.path);
//                               uploadImageDio();
//                               customSuccesSnackBar("Profile Updated Successfully.", context);
//                             }
//                           },
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 60,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.center,
//                                 end: Alignment.center,
//                                 colors: [
//                                   const Color(0xff90EAB4).withOpacity(0.1),
//                                   const Color(0xff6BD294).withOpacity(0.8),
//                                 ],
//                               ),
//                               color: CustomColors.white,
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Color.fromARGB(13, 0, 0, 0),
//                                   blurRadius: 4.0,
//                                   spreadRadius: 2.0,
//                                   offset: Offset(2.0, 2.0),
//                                 ),
//                               ],
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Save",
//                                 style: TextStyle(
//                                   color: CustomColors.white,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.w600,
//                                   fontFamily: "Rubik",
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   Widget getEducation(int index) {
//     return Stack(
//       children: [
//         Container(
//           decoration: const BoxDecoration(
//             color: Colors.transparent,
//           ),
//           alignment: Alignment.centerRight,
//           width: MediaQuery.of(context).size.width,
//           height: 100,
//           child: const RotatedBox(
//             quarterTurns: 1,
//             child: Text(
//               'Container 1',
//               style: TextStyle(fontSize: 18.0, color: Colors.white),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 25,
//           right: 10,
//           left: 3,
//           bottom: 5,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             decoration: BoxDecoration(color: CustomColors.white, borderRadius: BorderRadius.circular(10)),
//             alignment: Alignment.centerLeft,
//             width: MediaQuery.of(context).size.width,
//             height: 100,
//             // child: ListTile(
//             //   title: Text("Institute Name: ${snapshot![index][index]['name']}"),
//             //   subtitle: Text("Major: ${educationApiList![index][index].name}"),
//             //   trailing: Text(education[index]["start_date[]"].toString()),
//             // ),
//           ),
//         ),
//         Positioned(
//           top: 10,
//           right: -2,
//           // left: 20,
//           child: GestureDetector(
//             onTap: (() {
//               //
//               setState(() {
//                 education.removeAt(index);
//                 instituteMapList.removeAt(index);
//                 majorMapList.removeAt(index);
//                 startDateMapList.removeAt(index);
//                 endDateMapList.removeAt(index);
//                 currentMapList.removeAt(index);
//               });
//             }),
//             child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(100),
//                     bottomLeft: Radius.circular(100),
//                     bottomRight: Radius.circular(100),
//                     topRight: Radius.circular(100),
//                   ),
//                   color: CustomColors.white,
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color.fromARGB(13, 0, 0, 0),
//                       blurRadius: 4.0,
//                       spreadRadius: 2.0,
//                       offset: Offset(2.0, 2.0),
//                     ),
//                   ],
//                 ),
//                 alignment: Alignment.center,
//                 width: 30,
//                 height: 30,
//                 child: const Icon(
//                   Icons.close,
//                   size: 16,
//                 )),
//           ),
//         ),
//       ],
//     );
//   }
//   Widget getRow(int index) {
//     return Card(
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
//           foregroundColor: Colors.white,
//           child: Text(
//             education[index]["institute_name[]"].toString(),
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               education[index]["institute_name[]"].toString(),
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text(education[index]["major[]"].toString()),
//           ],
//         ),
//         trailing: SizedBox(
//           width: 70,
//           child: Row(
//             children: [
//               // InkWell(
//               //     onTap: () {
//               //       //
//               //       instituteController.text = education[index].name!;
//               //       majorController.text = education[index].major!;
//               //       setState(() {
//               //         selectedIndex = index;
//               //       });
//               //       //
//               //     },
//               //     child: const Icon(Icons.edit)),
//               InkWell(
//                   onTap: (() {
//                     //
//                     setState(() {
//                       education.removeAt(index);
//                       instituteMapList.removeAt(index);
//                       majorMapList.removeAt(index);
//                       startDateMapList.removeAt(index);
//                       endDateMapList.removeAt(index);
//                       currentMapList.removeAt(index);
//                       // stringListData.removeWhere((element) => true);
//                     });
//                     // for (var i = 0; i < stringListData.length; i++) {
//                     //   if (stringListData[i] == stringListData) {
//                     //     int index = i;
//                     //   }
//                     // }
//                     // stringListData.removeAt(index);
//                     //
//                     // stringListData.removeWhere((item) => item == index);
//                   }),
//                   child: const Icon(Icons.delete)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ProfileGiverPendingEdit extends StatefulWidget {
  final String? avatar;
  final String? gender;
  final String? phoneNumber;
  final String? dob;
  final String? yoe;
  final String? hourlyRate;
  final String? userAddress;
  final String? zipCode;
  final String? additionalService;
  final String? availability;
  final String? userInfo;
  final String? enhancedCriminal;
  final int? enhancedCriminalStatus;
  final String? basicCriminal;
  final int? basicCriminalStatus;
  final String? firstAid;
  final int? firstAidStatus;
  final String? vehicleRecord;
  final int? vehicleRecordStatus;
  const ProfileGiverPendingEdit({
    Key? key,
    this.avatar,
    this.gender,
    this.phoneNumber,
    this.dob,
    this.yoe,
    this.hourlyRate,
    this.userAddress,
    this.zipCode,
    this.additionalService,
    this.availability,
    this.userInfo,
    this.enhancedCriminal,
    this.enhancedCriminalStatus,
    this.basicCriminal,
    this.basicCriminalStatus,
    this.firstAid,
    this.firstAidStatus,
    this.vehicleRecord,
    this.vehicleRecordStatus,
  }) : super(key: key);
  @override
  State<ProfileGiverPendingEdit> createState() => _ProfileGiverPendingEditState();
}

class _ProfileGiverPendingEditState extends State<ProfileGiverPendingEdit> {
  var _isSelectedGender = "1";
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController userInfoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController hourlyController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  @override
  void initState() {
    userTokenProfile();
    getUserToken();
    getUserId();
    super.initState();
    // this.getSWData();
    fetchProfileEdit = fetchProfileGiverModelEdit();
    if (widget.gender != null) {
      _isSelectedGender = widget.gender!;
    }
    if (widget.phoneNumber != null) {
      phoneController.text = widget.phoneNumber!;
    }
    if (widget.dob != null) {
      dobController.text = widget.dob!;
    }
    if (widget.yoe != null) {
      experienceController.text = widget.yoe!;
    }
    if (widget.hourlyRate != null) {
      hourlyController.text = widget.hourlyRate!;
    }
    if (widget.userAddress != null) {
      addressController.text = widget.userAddress!;
    }
    if (widget.zipCode != null) {
      zipController.text = widget.zipCode!;
    }
    if (widget.additionalService != null) {
      keywordController.text = widget.additionalService!;
    }
    if (widget.availability != null) {
      availabilityController.text = widget.availability!;
    }
    if (widget.userInfo != null) {
      userInfoController.text = widget.userInfo!;
    }
  }

  var isPeriodSeleted = "0";
  void _toggleradio() {
    if (isPeriodSeleted == "0") {
      setState(() {
        isPeriodSeleted = "1";
      });
    } else {
      {
        setState(() {
          isPeriodSeleted = "0";
        });
      }
    }
  }

  List<Map<String, String>> education = [];
  var arr1 = [];
  List instituteMapList = [];
  List majorMapList = [];
  List startDateMapList = [];
  List endDateMapList = [];
  List currentMapList = [];
  var stringListData = [];
  FilePickerResult? enhanceResult;
// DatePicker
  var getPickedDate;
  var gettoPickedDate;
  var getfromPickedDate;

  DateTime? selectedDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1930),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              primaryColorDark: CustomColors.primaryColor,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      picked == dobController;
      setState(() {
        getPickedDate = dobController.text;
      });
    }
  }

  _fromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1930),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              primaryColorDark: CustomColors.primaryColor,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      fromController.text = DateFormat('yyyy-MM-dd').format(picked);

      picked == fromController;
      setState(() {
        getfromPickedDate = fromController.text;
      });
    }
  }

  _toDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1930),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              primaryColorDark: CustomColors.primaryColor,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      toController.text = DateFormat('yyyy-MM-dd').format(picked);
      picked == toController;
      setState(() {
        gettoPickedDate = toController.text;
      });
    }
  }

  List educationApiList = [];
  late Future<ProfileGiverModel> fetchProfileEdit;
  Future<ProfileGiverModel> fetchProfileGiverModelEdit() async {
    var token = await userTokenProfile();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfile,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        educationApiList = response.data['data']["educations"];
      });
      for (int i = 0; i < educationApiList.length; i++) {
        instituteMapList.add(educationApiList[i]['name']);
        majorMapList.add(educationApiList[i]['major']);
        startDateMapList.add(educationApiList[i]['from']);
        endDateMapList.add(educationApiList[i]['to']);
        currentMapList.add(educationApiList[i]['current']);
      }
      return ProfileGiverModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Profile Model',
        ),
      );
    }
  }

  // Image Picking
  ProgressDialog? pr;
  void showProgress(context) async {
    pr ??= ProgressDialog(context);
    await pr!.show();
  }

  void hideProgress() async {
    if (pr != null && pr!.isShowing()) {
      await pr!.hide();
    }
  }

  File? image;
  File? imageFileDio;

  bool showSpinner = false;
  var myimg;

  Future getImageDio() async {
    FilePickerResult? pickedFileDio = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (pickedFileDio != null) {
      if (checkImageFileTypes(context, pickedFileDio.files.single.extension)) {
        setState(() {
          imageFileDio = File(pickedFileDio.files.single.path ?? " ");
        });
      }
    } else {
      customErrorSnackBar(context, "No file select");
    }
  }

  String? _getEnhanceFile;
  String? _getBasicFile;
  String? _getFirstAidFile;
  String? _getVehicleRecordFile;

  Future getEnhancedPdfFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc'],
    );
    if (file != null) {
      if (checkDocuFileTypes(context, file.files.single.extension)) {
        File pdfFileEnhance = File(file.files.single.path ?? " ");

        String? enhanceFileName = pdfFileEnhance.path.split('/').last;
        String? enhancePath = pdfFileEnhance.path;
        setState(() {
          _getEnhanceFile = enhancePath;
        });
      }
    }
  }

  Future getBasicFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc'],
    );
    if (file != null) {
      if (checkDocuFileTypes(context, file.files.single.extension)) {
        File pdfFileEnhance = File(file.files.single.path ?? " ");

        String? enhanceFileName = pdfFileEnhance.path.split('/').last;
        String? enhancePath = pdfFileEnhance.path;
        setState(() {
          _getBasicFile = enhancePath;
        });
      }
    }
  }

  Future getFirstAidFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc'],
    );
    if (file != null) {
      if (checkDocuFileTypes(context, file.files.single.extension)) {
        File pdfFileEnhance = File(file.files.single.path ?? " ");

        String? enhanceFileName = pdfFileEnhance.path.split('/').last;
        String? enhancePath = pdfFileEnhance.path;
        setState(() {
          _getFirstAidFile = enhancePath;
        });
      }
    }
  }

  Future getVehicleRecordFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc'],
    );
    if (file != null) {
      if (checkDocuFileTypes(context, file.files.single.extension)) {
        File pdfFileEnhance = File(file.files.single.path ?? " ");

        String? enhanceFileName = pdfFileEnhance.path.split('/').last;
        String? enhancePath = pdfFileEnhance.path;
        setState(() {
          _getVehicleRecordFile = enhancePath;
        });
      }
    }
  }

  uploadImageDio() async {
    var usersId = await getUserId();
    var token = await userTokenProfile();

    var formData = FormData.fromMap(
      {
        '_method': 'PUT',
        'user_info': userInfoController.text.toString(),
        'phone': phoneController.text.toString(),
        'address': addressController.text.toString(),
        'gender': _isSelectedGender,
        'dob': dobController.text.toString(),
        'zip': zipController.text.toString(),
        'experience': experienceController.text.toString(),
        'hourly_rate': hourlyController.text.toString(),
        'availability': availabilityController.text.toString(),
        'keywords': keywordController.text.toString(),
        "avatar": imageFileDio == null ? null : await MultipartFile.fromFile(imageFileDio!.path),
        "institute_name[]": instituteMapList,
        "start_date[]": startDateMapList,
        "end_date[]": endDateMapList,
        "current[]": currentMapList,
        "major[]": majorMapList,
        "enhanced_criminal": _getEnhanceFile == null ? null : await MultipartFile.fromFile(_getEnhanceFile.toString()),
        "basic_criminal": _getBasicFile == null ? null : await MultipartFile.fromFile(_getBasicFile.toString()),
        "first_aid": _getFirstAidFile == null ? null : await MultipartFile.fromFile(_getFirstAidFile.toString()),
        "vehicle_record": _getVehicleRecordFile == null ? null : await MultipartFile.fromFile(_getVehicleRecordFile.toString()),
      },
    );

    Dio dio = Dio();
    try {
      var response = await dio.post('https://islandcare.bm/api/service-provider-profile/$usersId', data: formData, options: Options(contentType: 'application/json', followRedirects: false, validateStatus: (status) => true, headers: {"Accept": "application/json", "Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        customSuccesSnackBar(
          context,
          "Profile Updated Successfully.",
        );
      } else {
        customErrorSnackBar(
          context,
          "Something went wrong please try agan later.",
        );
      }
    } catch (e) {
      customErrorSnackBar(context, e.toString());
    }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    return userToken.toString();
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString(
      'userId',
    );
    return userId.toString();
  }

  userTokenProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    return userToken.toString();
  }

  @override
  void dispose() {
    super.dispose();
    dobController.dispose();
    nameController.dispose();
    zipController.dispose();
    userInfoController.dispose();
    phoneController.dispose();
    addressController.dispose();
    experienceController.dispose();
    hourlyController.dispose();
    availabilityController.dispose();
    keywordController.dispose();
    instituteController.dispose();
    majorController.dispose();
    fromController.dispose();
    toController.dispose();
  }

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Profile Edit",
            style: TextStyle(
              fontSize: 20,
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
              ),
            )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "Personal Information",
                        style: TextStyle(
                          color: CustomColors.primaryText,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Upload Image
                      GestureDetector(
                        onTap: () {
                          getImageDio();
                        },
                        child: imageFileDio == null
                            ? Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 100.45,
                                  width: 100.45,
                                  decoration: BoxDecoration(
                                    color: CustomColors.primaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(15, 0, 0, 0),
                                        blurRadius: 4,
                                        spreadRadius: 4,
                                        offset: Offset(2, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: widget.avatar != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: Image(
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fitWidth,
                                              image: NetworkImage("${AppUrl.webStorageUrl}/${widget.avatar}"),
                                            ),
                                          )
                                        : const Text("Upload"),
                                  ),
                                ),
                              )
                            : Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    imageFileDio!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 15),
                      // Gender
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Gender",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelectedGender = "1";
                                      });
                                    },
                                    child: Container(
                                      height: 50.45,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _isSelectedGender == "1" ? CustomColors.primaryColor : CustomColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(15, 0, 0, 0),
                                            blurRadius: 4,
                                            spreadRadius: 4,
                                            offset: Offset(2, 2), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                        onPressed: () {
                                          setState(() {
                                            _isSelectedGender = "1";
                                          });
                                        },
                                        child: Text(
                                          "Male",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _isSelectedGender == "1" ? CustomColors.white : CustomColors.primaryText,
                                            fontFamily: "Rubik",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelectedGender = "2";
                                      });
                                    },
                                    child: Container(
                                      height: 50.45,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _isSelectedGender == "2" ? CustomColors.primaryColor : CustomColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(15, 0, 0, 0),
                                            blurRadius: 4,
                                            spreadRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                        onPressed: () {
                                          setState(() {
                                            _isSelectedGender = "2";
                                          });
                                        },
                                        child: Text(
                                          "Female",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _isSelectedGender == "2" ? CustomColors.white : CustomColors.primaryText,
                                            fontFamily: "Rubik",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Phone Number
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phone Number",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // DOB
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Date Of Birth",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CustomTextFieldWidget(
                              borderColor: CustomColors.white,
                              obsecure: false,
                              keyboardType: TextInputType.number,
                              controller: dobController,
                              onChanged: (value) {
                                setState(() {
                                  getPickedDate = value;
                                });
                              },
                              hintText: "DOB",
                              onTap: () async {
                                _selectDate(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      // Experrience
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Years Of Experience",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: experienceController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Experience",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Hourly
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hourly Rate",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: hourlyController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Hourly",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // User Address
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "User Address",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: addressController,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "User Address",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Zip Code
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Zip Code",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: zipController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Zip Code",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // AdditionalService
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Additional Services",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: keywordController,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: "abc, abc, abc",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Education
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Education",
                            style: TextStyle(
                              color: CustomColors.primaryText,
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text("Add Education"),
                                        // Institute Name
                                        Container(
                                          height: 50,
                                          margin: const EdgeInsets.only(bottom: 15, top: 15),
                                          decoration: BoxDecoration(
                                            color: CustomColors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: TextFormField(
                                            controller: instituteController,
                                            keyboardType: TextInputType.name,
                                            textInputAction: TextInputAction.next,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlignVertical: TextAlignVertical.bottom,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              hintText: "Institute Name",
                                              fillColor: CustomColors.myJobDetail,
                                              focusColor: CustomColors.white,
                                              hoverColor: CustomColors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Major
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: CustomColors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: TextFormField(
                                            controller: majorController,
                                            keyboardType: TextInputType.name,
                                            textInputAction: TextInputAction.next,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlignVertical: TextAlignVertical.bottom,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              hintText: "Major",
                                              fillColor: CustomColors.myJobDetail,
                                              focusColor: CustomColors.white,
                                              hoverColor: CustomColors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Time period
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextButton.icon(
                                          style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                          onPressed: () {
                                            _toggleradio();
                                            setState(() {});
                                          },
                                          icon: CircleAvatar(
                                            backgroundColor: const Color.fromARGB(181, 171, 171, 171),
                                            radius: 8,
                                            child: CircleAvatar(
                                              radius: 4,
                                              backgroundColor: isPeriodSeleted == "1" ? CustomColors.primaryText : const Color.fromARGB(181, 171, 171, 171),
                                            ),
                                          ),
                                          label: Text(
                                            "Currently Studying?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: CustomColors.primaryText,
                                              fontFamily: "Rubik",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        // From Date
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: CustomColors.myJobDetail,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: CustomTextFieldWidget(
                                            borderColor: CustomColors.white,
                                            obsecure: false,
                                            keyboardType: TextInputType.number,
                                            controller: fromController,
                                            hintText: "From",
                                            onTap: () async {
                                              _fromDate(context);
                                            },
                                          ),
                                        ),
                                        // To Date
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: CustomColors.myJobDetail,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: CustomTextFieldWidget(
                                            borderColor: CustomColors.white,
                                            obsecure: false,
                                            keyboardType: TextInputType.number,
                                            controller: toController,
                                            hintText: "To",
                                            onTap: () async {
                                              _toDate(context);
                                            },
                                          ),
                                        ),
                                        // AddBtn
                                        GestureDetector(
                                          onTap: () async {
                                            {
                                              String institute = instituteController.text.trim();
                                              String major = majorController.text.trim();
                                              String from = fromController.text.toString();
                                              String to = toController.text.toString();

                                              if (institute.isNotEmpty && major.isNotEmpty) {
                                                instituteController.text = '';
                                                majorController.text = '';
                                                fromController.text = '';
                                                toController.text = '';
                                                instituteMapList.add(institute);
                                                majorMapList.add(major);
                                                startDateMapList.add(from);
                                                endDateMapList.add(to);
                                                currentMapList.add(isPeriodSeleted);
                                                setState(() {
                                                  educationApiList.add(
                                                    {
                                                      "name": institute.toString(),
                                                      "major": major.toString(),
                                                      "from": from.toString(),
                                                      "current": isPeriodSeleted.toString(),
                                                      "to": to.toString(),
                                                    },
                                                  );
                                                });

                                                setState(() {
                                                  instituteController.text = '';
                                                  majorController.text = '';
                                                  fromController.text = '';
                                                  toController.text = '';
                                                });
                                                SharedPreferences pref = await SharedPreferences.getInstance();
                                                var data = await pref.setString('ListData', education.toString());

                                                Navigator.pop(context, true);
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,
                                            margin: const EdgeInsets.only(top: 20),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.center,
                                                end: Alignment.center,
                                                colors: [
                                                  const Color(0xff90EAB4).withOpacity(0.1),
                                                  const Color(0xff6BD294).withOpacity(0.8),
                                                ],
                                              ),
                                              color: CustomColors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(13, 0, 0, 0),
                                                  blurRadius: 4.0,
                                                  spreadRadius: 2.0,
                                                  offset: Offset(2.0, 2.0),
                                                ),
                                              ],
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                  color: CustomColors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Rubik",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: CustomColors.primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "Add Education",
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 13,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              child: educationApiList.isEmpty
                                  ? null
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: educationApiList.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                              alignment: Alignment.centerRight,
                                              width: MediaQuery.of(context).size.width,
                                              height: 100,
                                              child: const RotatedBox(
                                                quarterTurns: 1,
                                                child: Text(
                                                  'Container 1',
                                                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 25,
                                              right: 10,
                                              left: 3,
                                              bottom: 5,
                                              child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: CustomColors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * .80,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  alignment: Alignment.topLeft,
                                                                  width: 100,
                                                                  child: const Column(
                                                                    children: [
                                                                      Text("Institute Name:"),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text("${educationApiList[index]['name']}"),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  alignment: Alignment.topLeft,
                                                                  width: 100,
                                                                  child: const Column(
                                                                    children: [
                                                                      Text("Major:"),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text("${educationApiList[index]['major']}"),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  alignment: Alignment.topLeft,
                                                                  width: 100,
                                                                  child: const Column(
                                                                    children: [
                                                                      Text("From:"),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text("${educationApiList[index]['from']}"),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: -2,
                                              child: GestureDetector(
                                                onTap: (() {
                                                  //
                                                  setState(() {
                                                    educationApiList.removeAt(index);
                                                    instituteMapList.removeAt(index);
                                                    majorMapList.removeAt(index);
                                                    startDateMapList.removeAt(index);
                                                    endDateMapList.removeAt(index);
                                                    currentMapList.removeAt(index);
                                                  });
                                                }),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(100),
                                                        bottomLeft: Radius.circular(100),
                                                        bottomRight: Radius.circular(100),
                                                        topRight: Radius.circular(100),
                                                      ),
                                                      color: CustomColors.white,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Color.fromARGB(13, 0, 0, 0),
                                                          blurRadius: 4.0,
                                                          spreadRadius: 2.0,
                                                          offset: Offset(2.0, 2.0),
                                                        ),
                                                      ],
                                                    ),
                                                    alignment: Alignment.center,
                                                    width: 30,
                                                    height: 30,
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 16,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                            ),
                          ],
                        ),
                      ),
                      // Availability
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15, top: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Availability",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: availabilityController,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "Availability",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // User Info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "User Info",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: userInfoController,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "User Info",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Background Verified
                      DottedBorder(
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        color: CustomColors.primaryColor,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: CustomColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.workspace_premium,
                              color: CustomColors.primaryColor,
                            ),
                            title: Text(
                              "Background Varified",
                              style: TextStyle(
                                color: CustomColors.primaryText,
                                fontSize: 12,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "We encourage parents to conduct their own screenings using the background check tools. See what each of the badges covered, or learn more about keeping your family safe by visiting the Trust & Safety Center.",
                              style: TextStyle(
                                color: CustomColors.primaryText,
                                fontSize: 10,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (widget.enhancedCriminalStatus == 2 || widget.enhancedCriminalStatus == 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.picture_as_pdf_rounded,
                                color: CustomColors.red,
                              ),
                              label: Text(
                                "Enhanced Criminal",
                                style: TextStyle(fontSize: 12, color: CustomColors.primaryText),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                getEnhancedPdfFile();
                              },
                              child: DottedBorder(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                                radius: const Radius.circular(4),
                                borderType: BorderType.RRect,
                                color: CustomColors.primaryColor,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: CustomColors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _getEnhanceFile.toString() == null ? "Quick File Uploader" : "File Selected",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: CustomColors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                      if (widget.basicCriminalStatus == 2 || widget.basicCriminalStatus == 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.picture_as_pdf_rounded,
                                color: CustomColors.red,
                              ),
                              label: Text(
                                "Basic Criminal",
                                style: TextStyle(fontSize: 12, color: CustomColors.primaryText),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                getBasicFile();
                              },
                              child: DottedBorder(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                                radius: const Radius.circular(4),
                                borderType: BorderType.RRect,
                                color: CustomColors.primaryColor,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: CustomColors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _getBasicFile.toString() == null ? "Quick File Uploader" : "File Selected",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: CustomColors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                      if (widget.firstAidStatus == 2 || widget.firstAidStatus == 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.picture_as_pdf_rounded,
                                color: CustomColors.red,
                              ),
                              label: Text(
                                "First aid certification",
                                style: TextStyle(fontSize: 12, color: CustomColors.primaryText),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                getFirstAidFile();
                              },
                              child: DottedBorder(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                                radius: const Radius.circular(4),
                                borderType: BorderType.RRect,
                                color: CustomColors.primaryColor,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: CustomColors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _getFirstAidFile.toString() == null ? "Quick File Uploader" : "File Selected",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: CustomColors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                      if (widget.vehicleRecordStatus == 2 || widget.vehicleRecordStatus == 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.picture_as_pdf_rounded,
                                color: CustomColors.red,
                              ),
                              label: Text(
                                "Vehicle Records",
                                style: TextStyle(fontSize: 12, color: CustomColors.primaryText),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                getVehicleRecordFile();
                              },
                              child: DottedBorder(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                                radius: const Radius.circular(4),
                                borderType: BorderType.RRect,
                                color: CustomColors.primaryColor,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: CustomColors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _getVehicleRecordFile.toString() == null ? "Quick File Uploader" : "File Selected",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: CustomColors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: GestureDetector(
                          onTap: () async {
                            if (_isSelectedGender == null) {
                              customErrorSnackBar(context, "Please Select Gender");
                            } else if (dobController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Select Date Of Birth");
                            } else if (zipController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Zip Code");
                            } else if (phoneController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Phone Number");
                            } else if (addressController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Address");
                            } else if (experienceController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Experience");
                            } else if (hourlyController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Hourly Rate");
                            } else if (availabilityController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Availability");
                            } else if (keywordController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Keyword");
                            } else if (instituteMapList.isEmpty) {
                              customErrorSnackBar(context, "Please Enter education");
                            } else {
                              uploadImageDio();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.center,
                                colors: [
                                  const Color(0xff90EAB4).withOpacity(0.1),
                                  const Color(0xff6BD294).withOpacity(0.8),
                                ],
                              ),
                              color: CustomColors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(13, 0, 0, 0),
                                  blurRadius: 4.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Rubik",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getEducation(int index) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: const RotatedBox(
            quarterTurns: 1,
            child: Text(
              'Container 1',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 25,
          right: 10,
          left: 3,
          bottom: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(color: CustomColors.white, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            height: 100,
          ),
        ),
        Positioned(
          top: 10,
          right: -2,
          child: GestureDetector(
            onTap: (() {
              setState(() {
                education.removeAt(index);
                instituteMapList.removeAt(index);
                majorMapList.removeAt(index);
                startDateMapList.removeAt(index);
                endDateMapList.removeAt(index);
                currentMapList.removeAt(index);
              });
            }),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
                color: CustomColors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(13, 0, 0, 0),
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
              alignment: Alignment.center,
              width: 30,
              height: 30,
              child: const Icon(
                Icons.close,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            education[index]["institute_name[]"].toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              education[index]["institute_name[]"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(education[index]["major[]"].toString()),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                  onTap: (() {
                    //
                    setState(() {
                      education.removeAt(index);
                      instituteMapList.removeAt(index);
                      majorMapList.removeAt(index);
                      startDateMapList.removeAt(index);
                      endDateMapList.removeAt(index);
                      currentMapList.removeAt(index);
                    });
                  }),
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}
