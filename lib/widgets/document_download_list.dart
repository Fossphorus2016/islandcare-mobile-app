import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class BasicDocumentDownloadList extends StatelessWidget {
  const BasicDocumentDownloadList({
    super.key,
    required this.onTap,
    required this.downloading,
    required this.downloadProgress,
    required this.fileStatus,
    required this.title,
  });
  final void Function()? onTap;
  final bool downloading;
  final String downloadProgress;
  final String fileStatus;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              color: CustomColors.red,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                downloading ? "$title $downloadProgress" : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
              ),
            ),
            DottedBorder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              radius: const Radius.circular(4),
              borderType: BorderType.RRect,
              color: CustomColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf_rounded,
                    color: CustomColors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    (fileStatus == "0")
                        ? "Pending"
                        : (fileStatus == "1")
                            ? "Approved"
                            : (fileStatus == "2")
                                ? "Rejected"
                                : "File Not Available",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: CustomColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadBasicDocumentList extends StatelessWidget {
  const UploadBasicDocumentList({
    super.key,
    required this.onTap,
    required this.title,
    required this.fileSelectText,
  });
  final void Function()? onTap;
  final String title;
  final String fileSelectText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              color: CustomColors.red,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
              ),
            ),
            DottedBorder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              radius: const Radius.circular(4),
              borderType: BorderType.RRect,
              color: CustomColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    fileSelectText,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: CustomColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
