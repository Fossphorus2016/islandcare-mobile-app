// ignore_for_file: use_build_context_synchronously, await_only_futures, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
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
    {
      "id": 2023,
      "name": "2023",
    },
    {
      "id": 2024,
      "name": "2024",
    },
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
    CreditCard? selectCard = Provider.of<CardProvider>(context).selectedCard;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
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
              color: CustomColors.primaryText,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
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
                                                keyboardType: TextInputType.number,
                                                controller: cardNumberController,
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
                                                keyboardType: TextInputType.number,
                                                controller: cvvController,
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
                                                // if (nameOncardController.text.isEmpty) {
                                                //   showErrorToast("Please Enter Name");
                                                // } else if (cardNumberController.text.isEmpty) {
                                                //   showErrorToast("Please Enter Card Number");
                                                // } else if (selectedMonth == null) {
                                                //   showErrorToast("Please Select Month");
                                                // } else if (selectedYear == null) {
                                                //   showErrorToast("Please Select Year");
                                                // } else if (cvvController.text.isEmpty) {
                                                //   showErrorToast("Please Enter CVV");
                                                // } else {
                                                //   if (cardKey.currentState!.validate()) {
                                                //     await postAddCard();
                                                //   }
                                                // }
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
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ServiceRecieverColor.redButton,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        "Add New Card",
                        style: TextStyle(color: CustomColors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: FocusScope.of(context).hasFocus ? MediaQuery.of(context).size.height : 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        focusNode: focus,
                        autofocus: true,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Search Bank...",
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
                          Provider.of<CardProvider>(context, listen: false).setfilterList(value);
                        },
                      ),
                      const SizedBox(height: 15),
                      if (FocusScope.of(context).hasFocus) ...[
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Card Name",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Account Title",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Consumer<CardProvider>(builder: (context, provider, _) {
                            return ListView.builder(
                              itemCount: provider.filteredList!.length,
                              cacheExtent: 50,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    provider.setSelectedCard(provider.filteredList![index]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          provider.filteredList![index].nameOnCard.toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          provider.filteredList![index].cardNumber.toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
                if (selectCard != null && !FocusScope.of(context).hasFocus) ...[
                  Row(
                    children: [
                      const Text(
                        "Name Of Card: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(selectCard.nameOnCard.toString()),
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
                      Text(selectCard.cardNumber.toString()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "CVV Number: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(selectCard.cvv.toString()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "Expiry Month: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(selectCard.cardExpirationMonth.toString()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "Expiry Year: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        selectCard.cardExpirationYear.toString(),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
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
