import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/widgets/custom_pagination.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:island_app/widgets/profile_not_approved_text.dart';
import 'package:provider/provider.dart';

class RefundScreen extends StatefulWidget {
  const RefundScreen({super.key});

  @override
  State<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends State<RefundScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<RefundsProvider>(context, listen: false).fetchRefundData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RefundsProvider, RecieverUserProvider>(
      builder: (context, provider, recieverUserProvider, __) {
        // print(provider.totalRowsCount);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: CustomColors.primaryColor,
            automaticallyImplyLeading: false,
            title: const Text(
              "Refunds",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                fontFamily: "Rubik",
                color: Colors.white,
              ),
            ),
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
          ),
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: recieverUserProvider.profilePerentage != 100
                  ? const ProfileNotCompletedText()
                  : recieverUserProvider.profileIsApprove()
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () => provider.fetchRefundData(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 143,
                                          child: TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => addRefundRequest(context),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStatePropertyAll(ServiceRecieverColor.redButton),
                                              shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(05))),
                                            ),
                                            child: const Row(
                                              children: [
                                                Text(
                                                  "+",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                Text(
                                                  " Request Refund",
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                itemCount: provider.filterDataList.length,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  RefundDataModel item = provider.filterDataList[index];
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      height: 175,
                                                      padding: const EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(08),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 05,
                                                            spreadRadius: 01,
                                                            color: Colors.grey.shade300,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  "Job: ",
                                                                  style: TextStyle(
                                                                      fontSize: 16, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  item.job!["job_title"],
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(fontSize: 16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  "Amount: ",
                                                                  style: TextStyle(
                                                                      fontSize: 16, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  item.amount,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(fontSize: 16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  "Type: ",
                                                                  style: TextStyle(
                                                                      fontSize: 16, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  toCamelCase(item.type),
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(fontSize: 16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(
                                                                width: 70,
                                                                child: Text(
                                                                  "Status: ",
                                                                  style: TextStyle(
                                                                      fontSize: 16, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  toCamelCase(item.status),
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(fontSize: 16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: CustomPagination(
                                nextPage: (provider.currentPageIndex) < provider.totalRowsCount - 1
                                    ? () {
                                        provider.handlePageChange(provider.currentPageIndex + 1);
                                      }
                                    : null,
                                previousPage: provider.currentPageIndex > 0
                                    ? () => provider.handlePageChange(provider.currentPageIndex - 1)
                                    : null,
                                gotoPage: provider.handlePageChange,
                                gotoFirstPage:
                                    provider.currentPageIndex > 0 ? () => provider.handlePageChange(0) : null,
                                gotoLastPage: (provider.currentPageIndex) < provider.totalRowsCount - 1
                                    ? () => provider.handlePageChange(provider.totalRowsCount - 1)
                                    : null,
                                currentPageIndex: provider.currentPageIndex,
                                totalRowsCount: provider.totalRowsCount,
                              ),
                            ),
                          ],
                        )
                      : const ProfileNotApprovedText(),
            ),
          ),
        );
      },
    );
  }

  var selectType = "select";
  RefundJobModel? selectedJob;
  TextEditingController refundReasonController = TextEditingController();
  Widget addRefundRequest(BuildContext context) {
    return Consumer<RefundsProvider>(
      builder: (context, refundsProvider, __) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: CustomColors.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Request Refund",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              // contentPadding: EdgeInsets.zero,
              content: SizedBox(
                height: 380,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Job"),
                      const SizedBox(height: 05),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 05),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(08),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedJob ?? "select",
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem(
                                value: "select",
                                enabled: false,
                                child: Text("Select"),
                              ),
                              for (var i = 0; i < refundsProvider.jobsList.length; i++) ...[
                                // if(refundsProvider.jobsList[i].isFunded)...[

                                // ],
                                DropdownMenuItem(
                                  value: refundsProvider.jobsList[i],
                                  child: Text(refundsProvider.jobsList[i].jobTitle),
                                ),
                              ]
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedJob = value as RefundJobModel;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Amount"),
                      const SizedBox(height: 05),
                      Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.all(08),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(08),
                        ),
                        alignment: Alignment.centerLeft,
                        child: selectedJob != null ? Text(selectedJob!.amount) : const Text("Enter Amount"),
                      ),
                      const SizedBox(height: 10),
                      const Text("Refund Type"),
                      const SizedBox(height: 05),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 05),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(08),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: selectType,
                            items: const [
                              DropdownMenuItem(
                                value: "select",
                                enabled: false,
                                child: Text("Select"),
                              ),
                              DropdownMenuItem(
                                value: "full",
                                child: Text("Full"),
                              ),
                              DropdownMenuItem(
                                value: "partial",
                                child: Text("Partial"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Reason"),
                      const SizedBox(height: 05),
                      Container(
                        // width: double.infinity,
                        height: 100,
                        padding: const EdgeInsets.all(08),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(08),
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          controller: refundReasonController,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          decoration: const InputDecoration(
                            hintText: "Reason",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                LoadingButton(
                  title: "Request Refund",
                  backgroundColor: ServiceGiverColor.green,
                  width: 150,
                  height: 50,
                  onPressed: () async {
                    if (selectedJob == null) {
                      showErrorToast("Job is required");
                      return false;
                    }
                    if (selectType == "select") {
                      showErrorToast("Refund Type is required");
                      return false;
                    }
                    var token = await getToken();
                    var data = FormData.fromMap({
                      "refund_job_id": selectedJob!.id,
                      "refund_type": selectType,
                      "refund_amount": double.parse(selectedJob!.amount),
                      "refund_reason": refundReasonController.text.trim(),
                    });
                    var resp = await postRequesthandler(
                      url: CareReceiverURl.serviceReceiverRefundStore,
                      token: token,
                      formData: data,
                    );
                    if (resp != null && resp.statusCode == 201 && resp.data != null && resp.data["status"] == true) {
                      showSuccessToast("Refund Request is successfully Added");
                      // ignore: use_build_context_synchronously
                      refundsProvider.fetchRefundData();
                      setState(() {
                        selectedJob = null;
                        selectType = "select";
                        refundReasonController.clear();
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                    return true;
                  },
                ),
                LoadingButton(
                  title: "Close",
                  backgroundColor: ServiceGiverColor.redButtonLigth,
                  width: 60,
                  height: 50,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      selectedJob = null;
                      selectType = "select";
                      refundReasonController.clear();
                    });
                    return true;
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class RefundsProvider extends ChangeNotifier {
  setDefault() {
    refundList = [];
    isLoading = true;
    filterDataList = [];
    currentPageIndex = 0;
    rowsPerPage = 10;
    startIndex = 0;
    endIndex = 0;
    totalRowsCount = 0;
  }

  List refundList = [];
  List<RefundJobModel> jobsList = [];
  // Get all jobs

  bool isLoading = true;
  Future<void> fetchRefundData() async {
    var token = await getToken();

    final response = await getRequesthandler(
      url: CareReceiverURl.serviceReceiverRefund,
      token: token,
    );
    if (response != null && response.statusCode == 200 && response.data["status"]) {
      // var json = response.data;

      if (response.data['data'] != null && response.data['data']["all_refunds"] != null) {
        var data = RefundDataModel.fromJsonList(response.data['data']["all_refunds"]);
        refundList = data;
        notifyListeners();
        setPaginationList(data);
      }
      if (response.data['data'] != null && response.data['data']["jobs"] != null) {
        jobsList = RefundJobModel.fromJsonList(response.data['data']["jobs"]);
        notifyListeners();
      }
      isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load Hired Candidates');
    }
  }

  // Pagination List

  List<RefundDataModel> filterDataList = [];
  int currentPageIndex = 0;
  int rowsPerPage = 10;
  int startIndex = 0;
  int endIndex = 0;
  int totalRowsCount = 0;

  setPaginationList(List<RefundDataModel>? data) async {
    try {
      startIndex = currentPageIndex * rowsPerPage;
      endIndex = min(startIndex + rowsPerPage, data!.length);

      filterDataList = data.sublist(startIndex, endIndex).toList();
      totalRowsCount = (data.length / 10).ceil();
      notifyListeners();
    } catch (error) {
      // print(error.toString());
      showErrorToast("error in set pagination");
    }
  }

  // Generate List per page
  getCurrentPageData() {
    startIndex = currentPageIndex * rowsPerPage;
    endIndex = min(startIndex + rowsPerPage, refundList.length);
    filterDataList = refundList.sublist(startIndex, endIndex).toList() as List<RefundDataModel>;
    notifyListeners();
  }

  // handle page change function
  void handlePageChange(int pageIndex) {
    currentPageIndex = pageIndex;
    getCurrentPageData();
    notifyListeners();
  }

  // handle row change function
  void handleRowsPerPageChange(int rowsperPage) {
    rowsPerPage = rowsperPage;
    getCurrentPageData();
    notifyListeners();
  }
}

class RefundDataModel {
  final Map? job;
  final String type;
  final String amount;
  final String status;
  RefundDataModel({
    required this.job,
    required this.amount,
    required this.type,
    required this.status,
  });

  factory RefundDataModel.fromJson(Map json) {
    return RefundDataModel(
      job: json["job"],
      amount: json["amount"],
      type: json["type"],
      status: json["status"],
    );
  }

  static List<RefundDataModel> fromJsonList(List json) {
    return json.map((item) => RefundDataModel.fromJson(item)).toList();
  }
}

class RefundJobModel {
  final String id;
  final String userId;
  final String jobTitle;
  final String? isFunded;
  final String? status;
  final String amount;

  RefundJobModel({
    required this.id,
    required this.userId,
    required this.jobTitle,
    required this.amount,
    this.isFunded,
    this.status,
  });

  factory RefundJobModel.fromJson(Map json) {
    return RefundJobModel(
      jobTitle: json["job_title"],
      amount: json["total_amount"].toString(),
      id: json["id"].toString(),
      status: json["funds_transfered_to_provider"].toString(),
      userId: json["useer_id"].toString(),
      isFunded: json["is_funded"].toString(),
    );
  }

  static List<RefundJobModel> fromJsonList(List json) {
    return json.map((item) => RefundJobModel.fromJson(item)).toList();
  }
}
