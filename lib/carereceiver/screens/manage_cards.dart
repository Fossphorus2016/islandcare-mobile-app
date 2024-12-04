// ignore_for_file: use_build_context_synchronously, await_only_futures, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/widgets/profile_not_approved_text.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class ManageCards extends StatefulWidget {
  const ManageCards({super.key});

  @override
  State<ManageCards> createState() => _ManageCardsState();
}

class _ManageCardsState extends State<ManageCards> {
  TextEditingController nameOncardController = TextEditingController();
  var cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  final cardKey = GlobalKey<FormState>();
  List? month = [
    {
      "id": 1,
      "name": "January",
    },
    {
      "id": 2,
      "name": "February",
    },
    {
      "id": 3,
      "name": "March",
    },
    {
      "id": 4,
      "name": "April",
    },
    {
      "id": 5,
      "name": "May",
    },
    {
      "id": 6,
      "name": "June",
    },
    {
      "id": 7,
      "name": "July",
    },
    {
      "id": 8,
      "name": "August",
    },
    {
      "id": 9,
      "name": "September",
    },
    {
      "id": 10,
      "name": "October",
    },
    {
      "id": 11,
      "name": "November",
    },
    {
      "id": 12,
      "name": "December",
    },
  ];
  String? selectedMonth;
  List? year = [
    // {
    //   "id": 2023,
    //   "name": "2023",
    // },
    // {
    //   "id": 2024,
    //   "name": "2024",
    // },
    {
      "id": 2025,
      "name": "2025",
    },
    {
      "id": 2026,
      "name": "2026",
    },
    {
      "id": 2027,
      "name": "2027",
    },
    {
      "id": 2028,
      "name": "2028",
    },
    {
      "id": 2029,
      "name": "2029",
    },
    {
      "id": 2030,
      "name": "2030",
    },
    {
      "id": 2031,
      "name": "2031",
    },
    {
      "id": 2032,
      "name": "2032",
    },
    {
      "id": 2033,
      "name": "2033",
    },
    {
      "id": 2034,
      "name": "2034",
    },
    {
      "id": 2035,
      "name": "2035",
    },
    {
      "id": 2036,
      "name": "2036",
    },
    {
      "id": 2037,
      "name": "2037",
    },
    {
      "id": 2038,
      "name": "2038",
    },
    {
      "id": 2039,
      "name": "2039",
    },
    {
      "id": 2040,
      "name": "2040",
    },
    {
      "id": 2041,
      "name": "2041",
    },
    {
      "id": 2042,
      "name": "2042",
    },
    {
      "id": 2043,
      "name": "2043",
    },
    {
      "id": 2044,
      "name": "2044",
    },
    {
      "id": 2045,
      "name": "2045",
    },
    {
      "id": 2046,
      "name": "2046",
    },
    {
      "id": 2047,
      "name": "2047",
    },
    {
      "id": 2048,
      "name": "2048",
    },
    {
      "id": 2049,
      "name": "2049",
    },
    {
      "id": 2050,
      "name": "2050",
    },
  ];
  String? selectedYear;

  Future<void> postAddCard() async {
    var requestBody = FormData.fromMap({
      'name_on_card': nameOncardController.text.toString(),
      'card_number': cardNumberController.text.toString(),
      'card_expiration_month': selectedMonth.toString(),
      'card_expiration_year': selectedYear.toString(),
      'cvv': cvvController.text.toString(),
    });
    var token = await getToken();
    try {
      final response = await postRequesthandler(
        url: CareReceiverURl.serviceReceiverAddCreditCards,
        formData: requestBody,
        token: token,
      );
      if (response != null && response.statusCode == 200) {
        if (response.data['success'] == false) {
          showErrorToast(response.data['message']);
        } else if (response.data['success'] == true) {
          showSuccessToast("Card Added Successfully");
        }
        await Provider.of<CardProvider>(context, listen: false).fetchManageCardsModel(notify: true);
      }
      Navigator.pop(context);
    } on DioError catch (e) {
      Navigator.pop(context);
      showErrorToast(e.response!.data['message'].toString());
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CardProvider>(context, listen: false).fetchManageCardsModel(notify: true);
  }

  TextEditingController textController = TextEditingController();
  FocusNode focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer2<CardProvider, RecieverUserProvider>(builder: (context, provider, recieverUserProvider, _) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(30, 0, 0, 0),
                      offset: Offset(2, 2),
                      spreadRadius: 1,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: CustomColors.primaryColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            "Manage Cards",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
              color: CustomColors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: recieverUserProvider.profilePerentage != 100
                ? const ProfileNotCompletedText()
                : recieverUserProvider.profileIsApprove()
                    ? CustomScrollView(
                        slivers: [
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 20),
                          ),
                          SliverToBoxAdapter(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 140,
                                height: 50,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(ServiceRecieverColor.redButton),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return SingleChildScrollView(
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Center(
                                                        child: Container(
                                                          width: 130,
                                                          height: 5,
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xffC4C4C4),
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          "Enter Your Card Detail",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: CustomColors.black,
                                                            fontFamily: "Rubik",
                                                            fontStyle: FontStyle.normal,
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      Form(
                                                        key: cardKey,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.only(
                                                                  topLeft: Radius.circular(6),
                                                                  bottomLeft: Radius.circular(6),
                                                                  bottomRight: Radius.circular(6),
                                                                  topRight: Radius.circular(6),
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
                                                              width: MediaQuery.of(context).size.width,
                                                              height: 50,
                                                              child: TextFormField(
                                                                controller: nameOncardController,
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: "Rubik",
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                                textAlignVertical: TextAlignVertical.bottom,
                                                                maxLines: 1,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                                                                ],
                                                                decoration: InputDecoration(
                                                                  suffixIcon: Icon(
                                                                    Icons.person,
                                                                    size: 17,
                                                                    color: CustomColors.primaryColor,
                                                                  ),
                                                                  hintText: "Enter Name On Card",
                                                                  fillColor: CustomColors.white,
                                                                  focusColor: CustomColors.white,
                                                                  hoverColor: CustomColors.white,
                                                                  filled: true,
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(4),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                                    borderRadius: BorderRadius.circular(4.0),
                                                                  ),
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                                    borderRadius: BorderRadius.circular(4.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.only(
                                                                  topLeft: Radius.circular(6),
                                                                  bottomLeft: Radius.circular(6),
                                                                  bottomRight: Radius.circular(6),
                                                                  topRight: Radius.circular(6),
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
                                                              width: MediaQuery.of(context).size.width,
                                                              height: 50,
                                                              child: TextFormField(
                                                                controller: cardNumberController,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                  LengthLimitingTextInputFormatter(16),
                                                                ],
                                                                keyboardType: TextInputType.number,
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: "Rubik",
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                                textAlignVertical: TextAlignVertical.bottom,
                                                                maxLines: 1,
                                                                decoration: InputDecoration(
                                                                  suffixIcon: Icon(
                                                                    Icons.credit_card,
                                                                    size: 17,
                                                                    color: CustomColors.primaryColor,
                                                                  ),
                                                                  hintText: "16 Digit Card Number",
                                                                  fillColor: CustomColors.white,
                                                                  focusColor: CustomColors.white,
                                                                  hoverColor: CustomColors.white,
                                                                  filled: true,
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(4),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                                    borderRadius: BorderRadius.circular(4.0),
                                                                  ),
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                                    borderRadius: BorderRadius.circular(4.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 50,
                                                                    width: MediaQuery.of(context).size.width * .4,
                                                                    child: Center(
                                                                      child: DecoratedBox(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: const BorderRadius.only(
                                                                            topLeft: Radius.circular(6),
                                                                            bottomLeft: Radius.circular(6),
                                                                            bottomRight: Radius.circular(6),
                                                                            topRight: Radius.circular(6),
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
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal: 10,
                                                                            vertical: 4,
                                                                          ),
                                                                          child: DropdownButtonHideUnderline(
                                                                            child: DropdownButton(
                                                                              hint: const Text(
                                                                                "Expiration Month",
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontFamily: "Rubik",
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),
                                                                              ),
                                                                              isExpanded: true,
                                                                              items: month!.map((item) {
                                                                                return DropdownMenuItem(
                                                                                  value: item['id'].toString(),
                                                                                  child: Text(item['name']),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (newVal) {
                                                                                setState(() {
                                                                                  selectedMonth = newVal;
                                                                                });
                                                                              },
                                                                              value: selectedMonth,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context).size.width * .4,
                                                                    height: 50,
                                                                    child: Center(
                                                                      child: DecoratedBox(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: const BorderRadius.only(
                                                                            topLeft: Radius.circular(6),
                                                                            bottomLeft: Radius.circular(6),
                                                                            bottomRight: Radius.circular(6),
                                                                            topRight: Radius.circular(6),
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
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal: 10,
                                                                            vertical: 4,
                                                                          ),
                                                                          child: DropdownButtonHideUnderline(
                                                                            child: DropdownButton(
                                                                              hint: const Text(
                                                                                "Expiration Year",
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontFamily: "Rubik",
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),
                                                                              ),
                                                                              isExpanded: true,
                                                                              items: year!.map((item) {
                                                                                return DropdownMenuItem(
                                                                                  value: item['id'].toString(),
                                                                                  child: Text(item['name']),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (newVal) {
                                                                                setState(() {
                                                                                  selectedYear = newVal;
                                                                                });
                                                                              },
                                                                              value: selectedYear,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.only(
                                                                  topLeft: Radius.circular(6),
                                                                  bottomLeft: Radius.circular(6),
                                                                  bottomRight: Radius.circular(6),
                                                                  topRight: Radius.circular(6),
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
                                                              width: MediaQuery.of(context).size.width,
                                                              height: 50,
                                                              child: TextFormField(
                                                                controller: cvvController,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                  LengthLimitingTextInputFormatter(3),
                                                                ],
                                                                keyboardType: TextInputType.number,
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: "Rubik",
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                                textAlignVertical: TextAlignVertical.bottom,
                                                                maxLines: 1,
                                                                decoration: InputDecoration(
                                                                  hintText: "CVV/CVC",
                                                                  fillColor: CustomColors.white,
                                                                  focusColor: CustomColors.white,
                                                                  hoverColor: CustomColors.white,
                                                                  filled: true,
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(4),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                                    borderRadius: BorderRadius.circular(4.0),
                                                                  ),
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                                    borderRadius: BorderRadius.circular(4.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            LoadingButton(
                                                              title: "Add Card",
                                                              height: 54,
                                                              backgroundColor: CustomColors.primaryColor,
                                                              textStyle: TextStyle(
                                                                color: CustomColors.white,
                                                                fontFamily: "Rubik",
                                                                fontStyle: FontStyle.normal,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 18,
                                                              ),
                                                              onPressed: () async {
                                                                if (nameOncardController.text.isEmpty) {
                                                                  showErrorToast("Please Enter Name");
                                                                } else if (cardNumberController.text.isEmpty) {
                                                                  showErrorToast("Please Enter Card Number");
                                                                } else if (selectedMonth == null) {
                                                                  showErrorToast("Please Select Month");
                                                                } else if (selectedYear == null) {
                                                                  showErrorToast("Please Select Year");
                                                                } else if (cvvController.text.isEmpty) {
                                                                  showErrorToast("Please Enter CVV");
                                                                } else {
                                                                  if (cardKey.currentState!.validate()) {
                                                                    await postAddCard();
                                                                  }
                                                                }
                                                                return false;
                                                              },
                                                            ),
                                                            const SizedBox(height: 10),
                                                            LoadingButton(
                                                              title: "Cancel",
                                                              height: 54,
                                                              backgroundColor: CustomColors.red,
                                                              textStyle: TextStyle(
                                                                color: CustomColors.white,
                                                                fontFamily: "Rubik",
                                                                fontStyle: FontStyle.normal,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 18,
                                                              ),
                                                              onPressed: () async {
                                                                Navigator.pop(context);
                                                                return false;
                                                              },
                                                            ),
                                                            const SizedBox(height: 30),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Add New Card",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 60,
                              child: TextField(
                                focusNode: focus,
                                // autofocus: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "Search Card...",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.black26),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.black12),
                                  ),
                                ),
                                style: const TextStyle(fontSize: 14),
                                controller: textController,
                                onChanged: (value) {
                                  provider.setfilterList(value);
                                },
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverList.separated(
                            itemCount: provider.filteredList!.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (BuildContext context, int index) {
                              CreditCard cardDetail = provider.filteredList![index];
                              return InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  provider.setSelectedCard(cardDetail);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(08),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 05,
                                        spreadRadius: 01,
                                        color: Colors.grey.shade200,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Name Of Card: ",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(cardDetail.nameOnCard.toString()),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Text(
                                            "Card: ",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(cardDetail.cardNumber.toString()),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "CVV Number: ${cardDetail.cvv.toString()}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "Expiry Month: ${cardDetail.cardExpirationMonth.toString()}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 10),
                                      // Row(
                                      //   children: [
                                      //     const SizedBox(width: 10),
                                      //     Text(),
                                      //   ],
                                      // ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Text(
                                            "Expiry Year: ",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            cardDetail.cardExpirationYear.toString(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 40)),
                        ],
                      )
                    : const ProfileNotApprovedText(),
          ),
        ),
      );
    });
  }
}

class CardProvider extends ChangeNotifier {
  setDefault() {
    allCards = [];
    filteredList = [];
    selectedCard = null;
  }

  List<CreditCard>? allCards = [];
  List<CreditCard>? filteredList = [];
  CreditCard? selectedCard;
  Future<void> fetchManageCardsModel({required bool notify}) async {
    var token = await getToken();
    final response = await getRequesthandler(
      url: CareReceiverURl.serviceReceiverGetCreditCards,
      token: token,
    );
    if (response != null && response.statusCode == 200) {
      allCards = List<CreditCard>.from(response.data["credit-cards"]!.map((x) => CreditCard.fromJson(x)));
      filteredList = allCards;
      if (notify) {
        notifyListeners();
      }
    } else {
      showErrorToast("Failed to load Cards");
    }
  }

  setfilterList(String value) {
    if (value.isEmpty) {
      filteredList = allCards;
      notifyListeners();
    } else {
      filteredList = allCards!.where((element) {
        if (element.cardNumber.toString().toLowerCase().contains(value.toLowerCase())) {
          return true;
        } else if (element.nameOnCard.toString().toLowerCase().contains(value.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }).toList();
      notifyListeners();
    }
  }

  setSelectedCard(CreditCard card) {
    selectedCard = card;
    notifyListeners();
  }
}
