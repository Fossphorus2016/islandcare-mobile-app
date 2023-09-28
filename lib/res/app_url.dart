class AppUrl {
  static String localBaseURL = "http://192.168.10.183:4522";
  static String webBaseURL = "https://islandcare.bm";
  static String webStorageUrl = "$webBaseURL/storage";
  static String localStorageUrl = "$localBaseURL/storage";
  static String localImageUser = "assets/images/user.png";
  static String services = "$localBaseURL/api/services";
  static String bankName = "$localBaseURL/api/bank-names";
  static String sampleImage = "$localBaseURL/storage/avatar/sample.jpg";

  static String getNotification = "$localBaseURL/api/get-notifications";
}

class SessionUrl {
  static String login = "${AppUrl.localBaseURL}/api/login";
  static String register = "${AppUrl.localBaseURL}/api/register";
  static String signup = "${AppUrl.localBaseURL}/api/signup";
  static String emailVerification = "${AppUrl.localBaseURL}/api/email-verification";
}

class CareGiverUrl {
  static String serviceProviderProfile = "${AppUrl.localBaseURL}/api/service-provider-profile";
  static String serviceProviderProfileReviews = "${AppUrl.localBaseURL}/api/provider-reviews";
  static String serviceProviderDashboard = "${AppUrl.localBaseURL}/api/service-provider-dashboard";
  static String serviceProviderBankDetails = "${AppUrl.localBaseURL}/api/service-receiver-bank-details";
  static String serviceProviderAllJob = "${AppUrl.localBaseURL}/api/service-provider-my-jobs";
  static String serviceProviderJobDetail = "${AppUrl.localBaseURL}/api/service-provider-job-detail";
  static String addServiceProviderBank = "${AppUrl.localBaseURL}/api/add-service-receiver-bank";

  static String serviceProviderJobApply = "${AppUrl.localBaseURL}/api/service-provider-job-apply";
}

// service-receiver-subscribe
class CareReceiverURl {
  static String serviceReceiverApplicantDetails = "${AppUrl.localBaseURL}/api/service-receiver-my-application-applicant-details";
  static String serviceReceiverApplicantionApplicantsAccept = "${AppUrl.localBaseURL}/api/service-receiver-my-application-applicant-details-approve";
  static String serviceReceiverApplicantionApplicants = "${AppUrl.localBaseURL}/api/service-receiver-my-application-applicants";
  static String serviceReceiverBankDetails = "${AppUrl.localBaseURL}/api/service-receiver-bank-details";
  static String addServiceReceiverBank = "${AppUrl.localBaseURL}/api/add-service-receiver-bank";
  static String serviceReceiverJobCompleted = "${AppUrl.localBaseURL}/api/service-receiver-job-completed";
  static String serviceReceiverHireCandicate = "${AppUrl.localBaseURL}/api/service-receiver-hire-candicate";
  static String serviceReceiverDashboard = "${AppUrl.localBaseURL}/api/service-receiver-dashboard";
  static String serviceReceiverAddFavourite = "${AppUrl.localBaseURL}/api/service-receiver-add-to-favourite";
  static String serviceReceiverFavourite = "${AppUrl.localBaseURL}/api/service-receiver-favourites";
  static String serviceReceiverProfile = "${AppUrl.localBaseURL}/api/service-receiver-profile";
  static String serviceReceiverApplication = "${AppUrl.localBaseURL}/api/service-receiver-my-application";

  static String serviceReceiverSeniorCareJobCreater = "${AppUrl.localBaseURL}/api/service-receiver-seniorcare-job-create";
  static String serviceReceiverPetCareJobCreater = "${AppUrl.localBaseURL}/api/service-receiver-petcare-job-create";
  static String serviceReceiverHouseKeepingJobCreater = "${AppUrl.localBaseURL}/api/service-receiver-housekeeping-job-create";
  static String serviceReceiverLearningJobCreater = "${AppUrl.localBaseURL}/api/service-receiver-learning-job-create";
  static String serviceReceiverSchoolCampJobCreater = "${AppUrl.localBaseURL}/api/service-receiver-schoolcamp-job-create";

  static String serviceReceiverAddCreditCards = "${AppUrl.localBaseURL}/api/service-receiver-add-credit-cards";
  static String serviceReceiverGetCreditCards = "${AppUrl.localBaseURL}/api/service-receiver-get-credit-cards";
  static String serviceReceiverJobBoardDetail = "${AppUrl.localBaseURL}/api/service-receiver-job-board-detail";
  static String serviceReceiverJobBoard = "${AppUrl.localBaseURL}/api/service-receiver-job-board";
  static String serviceReceiverProviderDetail = "${AppUrl.localBaseURL}/api/service-receiver-provider-detail";
  static String serviceReceiverAdd = "${AppUrl.localBaseURL}/api/service-receiver-rating";

  static String serviceReceiverUnSubscribe = "${AppUrl.localBaseURL}/api/service-receiver-unsubscribe";
  static String serviceSubscribe = "${AppUrl.localBaseURL}/api/subscription-package";
  static String serviceReceiverSubscribePackage = "${AppUrl.localBaseURL}/api/service-receiver-subscribe";
}

class ChatUrl {
  static String serviceReceiverChat = "${AppUrl.localBaseURL}/api/service-receiver-chat";
  static String serviceReceiverSendMessage = "${AppUrl.localBaseURL}/api/service-receiver-send-message";
  static String serviceProviderChat = "${AppUrl.localBaseURL}/api/service-provider-chat";
  static String serviceProviderSendMessage = "${AppUrl.localBaseURL}/api/service-provider-send-message";
}
