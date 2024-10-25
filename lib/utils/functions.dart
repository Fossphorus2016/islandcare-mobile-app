import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

/// Displays a success toast message.
/// [message] is the text to be shown in the toast.
/// The background color is green, and the position is at the bottom.
void showSuccessToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: AppColors.successColor,
    gravity: ToastGravity.BOTTOM,
  );
}

/// Displays an error toast message.
/// [message] is the text to be shown in the toast.
/// The background color is red, and the position is at the bottom.
void showErrorToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: AppColors.errorColor,
    gravity: ToastGravity.BOTTOM,
  );
}

/// Displays a network error toast message.
/// [message] is the text to be shown in the toast.
/// The background color is red, and the position is at the top.
void showNetworkErrorToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: AppColors.errorColor,
    gravity: ToastGravity.TOP,
  );
}

/// Retrieves the last user login token from secure storage.
/// Returns the token if found, otherwise returns null.
Future<String?> getToken() async {
  var token = await storageService.readSecureStorage("userToken");
  return token;
}

/// Formats a [DateTime] object into a string with "dd/MM/yyyy" format.
/// Example: 9-9-2024 -> "09/09/2024".
String formatDateWithSlashFromDate(DateTime date) {
  return DateFormat("dd/MM/yyyy").format(date);
}

/// Formats a [DateTime] object into a string with "dd-MM-yyyy" format.
/// Example: 9/9/2024 -> "09-09-2024".
String formatDateWithDashFromDate(DateTime date) {
  return DateFormat("dd-MM-yyyy").format(date);
}

/// This function takes a string in the format "dd-MM-yyyy" and returns
/// a formatted `DateTime` object as a string.
/// Split the input date string by the '-' delimiter.
/// Example: "02-10-2024" becomes ["02", "10", "2024"].
/// Construct a DateTime object using the parts from the split string.
/// dateParts[2] -> year ("2024")
/// dateParts[1] -> month ("10")
/// dateParts[0] -> day ("02")
String formatDateWithDashFromString(String date) {
  // Check if the date string contains time by looking for a space.
  var hasTime = date.contains(' ');

  // If the string has time, extract only the date part.
  var onlyDate = hasTime ? date.split(' ')[0] : date;

  // Split the date part by the '-' delimiter (["yyyy", "MM", "dd"]).
  var dateParts = onlyDate.split('-');
  // print(dateParts);
  // Construct a DateTime object using the parts from the split string.
  var formatDate = DateTime(
      int.parse(dateParts[2]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[0]) // day
      );

  // Return the DateTime object as a formatted string.
  return formatDate.toString().split(' ')[0]; // Return only the date part.
}

String formatDateSlashToDashFromSplit(String date) {
  // Check if the date string contains time by looking for a space.
  var hasTime = date.contains(' ');

  // If the string has time, extract only the date part.
  var onlyDate = hasTime ? date.split(' ')[0] : date;

  // Split the date part by the '-' delimiter (["yyyy", "MM", "dd"]).
  var dateParts = onlyDate.split('/');
  print(dateParts);
  // Construct a DateTime object using the parts from the split string.
  var formatDate = DateTime(
      int.parse(dateParts[2]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[0]) // day
      );

  // Return the DateTime object as a formatted string.
  return formatDate.toString().split(' ')[0]; // Return only the date part.
}

/// Converts a date string from "dd/MM/yyyy" format to "dd-MM-yyyy" format.
/// The [date] string must be in "dd/MM/yyyy" format.
/// Example: "09/09/2024" -> "09-09-2024".
String changeDateFormatFromString(String date) {
  DateTime dateform = DateFormat("dd/MM/yyyy").parse(date);
  return DateFormat("dd-MM-yyyy").format(dateform);
}

/// Converts a date string from "dd-MM-yyyy" format to "dd/MM/yyyy" format.
/// The input [date] string must be in "dd-MM-yyyy" format.
/// Example: "09-09-2024" -> "09/09/2024".
String formatDateWithSlashFromString(String date) {
  return DateFormat("dd/MM/yyyy").format(DateTime.parse(date));
}

/// Returns the number of days in a given [month] for a specified [year].
/// Takes into account leap years for February.
int getDaysInMonth(int year, int month) {
  if (month == DateTime.february) {
    final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
    return isLeapYear ? 29 : 28;
  }
  const List<int> daysInMonth = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  return daysInMonth[month - 1];
}

/// Converts an entire sentence to camel case, where the first letter of each word
/// is capitalized and the rest are in lowercase.
/// Example: "hello world" -> "Hello World".
String toCamelCase(String text) {
  // Split the input text into individual words based on spaces.
  List<String> words = text.split(' ');

  // Map over each word, capitalize the first letter and lowercase the rest.
  List<String> capitalizedWords = words.map((word) {
    if (word.isEmpty) return ""; // Handle any empty strings.
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).toList();

  // Join the capitalized words back into a single string.
  return capitalizedWords.join(' ');
}

final urlRegExp = RegExp(
  r'(https?:\/\/[^\s<]+)(?![^<>]*>)',
  caseSensitive: false,
);

/// Create fingerprint token for login
/// params context type
/// return ui string
String encodeThumbLoginToken({required String id, required String email}) {
  var uI = id;
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String uIEncoded = stringToBase64.encode(uI.toString());

  String emialEncoded = stringToBase64.encode(email.toString());
  // var time = DateTime.now();
  String timeEncode = stringToBase64.encode(DateTime.now().toString());
  return "$uIEncoded|$emialEncoded|$timeEncode";
}

Future<String?> decodeThumbLoginToken({required String encodedToken}) async {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  List<String> parts = encodedToken.split('|');

  if (parts.length != 3) {
    return null;
    // throw const FormatException("Invalid encoded token format.");
  }

  // String idDecoded = stringToBase64.decode(parts[0]);
  String emailDecoded = stringToBase64.decode(parts[1]);
  // String timeDecoded = stringToBase64.decode(parts[2]);

  return emailDecoded;
}

class Utils {
  static void fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode nextFocus,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static snackBar(String? message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message!,
        ),
      ),
    );
  }
}

bool checkDocuFileTypes(context, fileExtension) {
  if (fileExtension == 'pdf' || fileExtension == 'docx' || fileExtension == 'doc') {
    return true;
  } else {
    showErrorToast("Please select file types pdf, docx and doc");
    return false;
  }
}

bool checkImageFileTypes(context, fileExtension) {
  if (fileExtension == 'png' || fileExtension == 'jpg' || fileExtension == 'jpeg') {
    return true;
  } else {
    showErrorToast("Please select file types png, jpg and jpeg");
    return false;
  }
}

void showProgress(context) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: CustomColors.primaryColor,
        content: SizedBox(
          height: 250,
          width: 250,
          child: Image.asset('assets/images/loaderLight.gif'),
        ),
      );
    },
  );
}
