
// class HomeViewViewReceiverModel with ChangeNotifier {
//   final _myRepo = HomeRepository();

//   ApiResponse<ServiceReceiverDashboardModel> ReceiverDashboardList = ApiResponse.loading();

//   setServiceReceiverDashboard(ApiResponse<ServiceReceiverDashboardModel> response) {
//     ReceiverDashboardList = response;
//     notifyListeners();
//   }

//   Future<void> fetchReceiverDashboardListApi() async {
//     setServiceReceiverDashboard(ApiResponse.loading());

//     _myRepo.fetchReceiverDashboardList().then((value) {
//       setServiceReceiverDashboard(ApiResponse.completed(value as ServiceReceiverDashboardModel));
//     }).onError((error, stackTrace) {
//       setServiceReceiverDashboard(ApiResponse.error(error.toString()));
//     });
//   }
// }

// class HomeViewViewReceiverModel extends ChangeNotifier {
//   final _myRepo = HomeRepository();

//   ApiResponse<ServiceReceiverDashboardModel> ServiceReceiverDashboardModelMain = ApiResponse.loading();

//   void _setServiceReceiverDashboardModel(ApiResponse<ServiceReceiverDashboardModel>? response) {
//     print("MARAJ :: $response");
//     ServiceReceiverDashboardModelMain = response!;
//     notifyListeners();
//   }

//   Future fetchServiceReceiverDashboard() async {
//     _setServiceReceiverDashboardModel(ApiResponse.loading());
//     _myRepo.fetchReceiverDashboardList().then((value) => _setServiceReceiverDashboardModel(ApiResponse.completed(value as ServiceReceiverDashboardModel)))
//         .onError((error, stackTrace) => _setServiceReceiverDashboardModel(ApiResponse.error(error.toString())));
//   }
// }