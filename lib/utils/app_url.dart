class AppUrl {
  static String localBaseURL = "http://192.168.10.238:8000"; //"https://islandcare.bm";
  static String webBaseURL = "http://192.168.10.238:8000"; // "https://islandcare.bm";
  static String webStorageUrl = "$webBaseURL/storage";
  static String localStorageUrl = "$localBaseURL/storage";
  static String localImageUser = "assets/images/user.png";
  static String services = "$webBaseURL/api/services";
  static String bankName = "$webBaseURL/api/bank-names";
  static String sampleImage = "$webBaseURL/storage/avatar/sample.jpg";
}

class NotificationUrl {
  static String getNotification = "${AppUrl.webBaseURL}/api/get-notifications";
  static String notificationMarkRead = "${AppUrl.webBaseURL}/api/mark-notifications-as-read";
}

class BankUrl {
  static String selectBank = "${AppUrl.webBaseURL}/api/select-bank";
  static String deleteBank = "${AppUrl.webBaseURL}/api/delete-bank";
}

class ManageCardUrl {
  static String chargeCard = "${AppUrl.webBaseURL}/api/charge-card";
}

class SessionUrl {
  static String login = "${AppUrl.webBaseURL}/api/login";
  static String register = "${AppUrl.webBaseURL}/api/register";
  static String signup = "${AppUrl.webBaseURL}/api/signup";
  static String emailVerification = "${AppUrl.webBaseURL}/api/email-verification";
  static String updatePassword = "${AppUrl.webBaseURL}/api/password-update";
}

class CareGiverUrl {
  static String serviceProviderProfile = "${AppUrl.webBaseURL}/api/service-provider-profile";
  static String serviceProviderProfileUpdate = "${AppUrl.webBaseURL}/api/service-provider-profile/update";
  static String serviceProviderProfileReviews = "${AppUrl.webBaseURL}/api/provider-reviews";
  static String serviceProviderDashboard = "${AppUrl.webBaseURL}/api/service-provider-dashboard";
  static String serviceProviderDashboardSearch = "${AppUrl.webBaseURL}/api/service-provider-job-search";

  static String serviceProviderBankDetails = "${AppUrl.webBaseURL}/api/service-receiver-bank-details";
  static String serviceProviderAllJob = "${AppUrl.webBaseURL}/api/service-provider-my-jobs";
  static String serviceProviderJobDetail = "${AppUrl.webBaseURL}/api/service-provider-job-detail";
  static String addServiceProviderBank = "${AppUrl.webBaseURL}/api/add-service-receiver-bank";

  static String serviceProviderJobApply = "${AppUrl.webBaseURL}/api/service-provider-job-apply";
  static String serviceProviderProfilePercentage = "${AppUrl.webBaseURL}/api/profile-percentage";
}

class CareReceiverURl {
  static String serviceReceiverProfileEdit = "${AppUrl.webBaseURL}/api/service-receiver-profile";
  static String serviceReceiverApplicantDetails = "${AppUrl.webBaseURL}/api/service-receiver-my-application-applicant-details";
  static String serviceReceiverApplicantionApplicantsAccept = "${AppUrl.webBaseURL}/api/service-receiver-my-application-applicant-details-approve";
  static String serviceReceiverApplicantionApplicants = "${AppUrl.webBaseURL}/api/service-receiver-my-application-applicants";
  static String serviceReceiverApplicantionApplicantsDetailReject = "${AppUrl.webBaseURL}/api/service-receiver-my-application-applicant-details-reject";
  static String serviceReceiverBankDetails = "${AppUrl.webBaseURL}/api/service-receiver-bank-details";
  static String addServiceReceiverBank = "${AppUrl.webBaseURL}/api/add-service-receiver-bank";
  static String serviceReceiverJobCompleted = "${AppUrl.webBaseURL}/api/service-receiver-job-completed";
  static String serviceReceiverHireCandicate = "${AppUrl.webBaseURL}/api/service-receiver-hire-candicate";
  static String serviceReceiverDashboard = "${AppUrl.webBaseURL}/api/service-receiver-dashboard";
  static String serviceReceiverAddFavourite = "${AppUrl.webBaseURL}/api/service-receiver-add-to-favourite";
  static String serviceReceiverFavourite = "${AppUrl.webBaseURL}/api/service-receiver-favourites";
  static String serviceReceiverProfile = "${AppUrl.webBaseURL}/api/service-receiver-profile";
  static String serviceReceiverApplication = "${AppUrl.webBaseURL}/api/service-receiver-my-application";

  static String serviceReceiverSeniorCareJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-seniorcare-job-create";
  static String serviceReceiverPetCareJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-petcare-job-create";
  static String serviceReceiverHouseKeepingJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-housekeeping-job-create";
  static String serviceReceiverLearningJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-child-care-job-create";
  static String serviceReceiverSchoolCampJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-schoolcamp-job-create";

  static String serviceReceiverAddCreditCards = "${AppUrl.webBaseURL}/api/service-receiver-add-credit-cards";
  static String serviceReceiverGetCreditCards = "${AppUrl.webBaseURL}/api/service-receiver-get-credit-cards";
  static String serviceReceiverJobBoardDetail = "${AppUrl.webBaseURL}/api/service-receiver-job-board-detail";
  static String serviceReceiverJobBoard = "${AppUrl.webBaseURL}/api/service-receiver-job-board";
  static String serviceReceiverProviderDetail = "${AppUrl.webBaseURL}/api/service-receiver-provider-detail";
  static String serviceReceiverRating = "${AppUrl.webBaseURL}/api/service-receiver-rating";

  static String serviceReceiverUnSubscribe = "${AppUrl.webBaseURL}/api/service-receiver-unsubscribe";
  static String serviceSubscribe = "${AppUrl.webBaseURL}/api/subscription-package";
  static String serviceReceiverSubscribePackage = "${AppUrl.webBaseURL}/api/service-receiver-subscribe";
}

class ChatUrl {
  static String getChat = "${AppUrl.webBaseURL}/api/get-chat";
  static String serviceReceiverAllChats = "${AppUrl.webBaseURL}/api/service-receiver-chats";
  static String serviceReceiverChat = "${AppUrl.webBaseURL}/api/service-receiver-chat";
  static String serviceReceiverSendMessage = "${AppUrl.webBaseURL}/api/service-receiver-send-message";
  static String serviceReceiverChatMessageStatus = "${AppUrl.webBaseURL}/api/service-receiver-message-status";
  static String serviceProviderChats = "${AppUrl.webBaseURL}/api/service-provider-chats";
  static String serviceProviderSendMessage = "${AppUrl.webBaseURL}/api/service-provider-send-message";
  static String serviceProviderChatMessageStatus = "${AppUrl.webBaseURL}/api/service-provider-message-status";
}
