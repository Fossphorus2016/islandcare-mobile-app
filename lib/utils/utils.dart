import 'package:flutter/material.dart';

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

customErrorSnackBar(context, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      closeIconColor: Colors.white,
      backgroundColor: const Color(0xffFF0000),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.cancel_outlined,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

customSuccesSnackBar(context, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      closeIconColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 156, 202, 177),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

bool checkDocuFileTypes(context, fileExtension) {
  if (fileExtension == 'pdf' || fileExtension == 'docx' || fileExtension == 'doc') {
    return true;
  } else {
    customErrorSnackBar(context, "Please select file types pdf, docx and doc");
    return false;
  }
}

bool checkImageFileTypes(context, fileExtension) {
  if (fileExtension == 'png' || fileExtension == 'jpg' || fileExtension == 'jpeg') {
    return true;
  } else {
    customErrorSnackBar(context, "Please select file types png, jpg and jpeg");
    return false;
  }
}

class ServiceGiverColor {
  static Color black = const Color(0xFF181c33);
  static Color activeDrawerTile = const Color(0xFFed1c24);
  static Color white = Colors.white;
  static Color green = const Color(0xFF50cd89);
  static Color redButton = const Color(0xFFf1416c);
  static Color redButtonLigth = const Color.fromARGB(150, 241, 65, 108);
  static Color grey = const Color.fromARGB(1000, 228, 230, 239);
  static Color backGroundColor = Colors.grey;
  static Color activeRatingStar = Colors.orange;
}
