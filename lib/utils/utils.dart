// import 'package:another_flushbar/flushbar.dart';
// import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode nextFocus,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // static toastMessage(String? message) {
  //   Fluttertoast.showToast(
  //     msg: message!,
  //     backgroundColor: Colors.black,
  //     textColor: Colors.white,
  //   );
  // }

  // static customErrorSnackBar(String message, BuildContext context) {
  //   showFlushbar(
  //     context: context,
  //     flushbar: Flushbar(
  //       forwardAnimationCurve: Curves.decelerate,
  //       margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  //       message: message,
  //       flushbarPosition: FlushbarPosition.BOTTOM,
  //       duration: const Duration(seconds: 3),
  //       borderRadius: BorderRadius.circular(2),
  //       backgroundColor: CustomColors.red,
  //       reverseAnimationCurve: Curves.bounceInOut,
  //       positionOffset: 20,
  //       icon: const Icon(
  //         Icons.error,
  //       ),
  //     )..show(
  //         context,
  //       ),
  //   );
  // }

  // static void customSuccesSnackBar(String message, BuildContext context) {
  //   showFlushbar(
  //     context: context,
  //     flushbar: Flushbar(
  //       forwardAnimationCurve: Curves.decelerate,
  //       margin: const EdgeInsets.symmetric(
  //         vertical: 20,
  //         horizontal: 10,
  //       ),
  //       message: message,
  //       flushbarPosition: FlushbarPosition.TOP,
  //       duration: const Duration(
  //         seconds: 3,
  //       ),
  //       borderRadius: BorderRadius.circular(
  //         2,
  //       ),
  //       backgroundColor: CustomColors.primaryColor,
  //       reverseAnimationCurve: Curves.bounceInOut,
  //       positionOffset: 20,
  //       icon: const Icon(
  //         Icons.verified,
  //       ),
  //     )..show(
  //         context,
  //       ),
  //   );
  // }

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
