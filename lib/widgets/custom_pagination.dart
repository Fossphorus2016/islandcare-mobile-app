import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:island_app/utils/app_colors.dart';

class CustomPagination extends StatelessWidget {
  const CustomPagination({
    super.key,
    required this.currentPageIndex,
    required this.totalRowsCount,
    required this.nextPage,
    required this.previousPage,
    required this.gotoPage,
    required this.gotoFirstPage,
    required this.gotoLastPage,
  });
  final void Function()? nextPage;
  final void Function()? previousPage;
  final void Function(int) gotoPage;
  final void Function()? gotoFirstPage;
  final void Function()? gotoLastPage;
  final int currentPageIndex;
  final int totalRowsCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 20),
          InkWell(
            onTap: gotoFirstPage,
            child: Container(
              padding: const EdgeInsets.all(05),
              width: MediaQuery.of(context).size.width > 665 ? 30 : 20,
              height: MediaQuery.of(context).size.width > 665 ? 30 : 20,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(05)),
              child: currentPageIndex > 0 ? const SvgPicture(SvgAssetLoader("assets/images/icons/active-skip-backward.svg")) : const SvgPicture(SvgAssetLoader("assets/images/icons/step-backward.svg")),
            ),
          ),
          const SizedBox(width: 05),
          InkWell(
            onTap: previousPage,
            child: Container(
              padding: const EdgeInsets.all(05),
              width: MediaQuery.of(context).size.width > 665 ? 30 : 20,
              height: MediaQuery.of(context).size.width > 665 ? 30 : 20,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(05)),
              child: currentPageIndex > 0 ? const SvgPicture(SvgAssetLoader("assets/images/icons/active-backward.svg")) : const SvgPicture(SvgAssetLoader("assets/images/icons/backward.svg")),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double parentContainerWidth = constraints.maxWidth;
                var totalLoop = (parentContainerWidth / 40).floor();
                var startloop = currentPageIndex > totalLoop ? (totalLoop - currentPageIndex).abs() : 0;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var i = 0; i <= totalLoop; i++) ...[
                      if (i <= totalRowsCount) ...[
                        InkWell(
                          onTap: () {
                            if (currentPageIndex > totalLoop) {
                              gotoPage(startloop + i);
                            } else {
                              gotoPage(i);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(05),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: currentPageIndex == (startloop + i) ? ServiceRecieverColor.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(05),
                              border: Border.all(color: currentPageIndex == (startloop + i) ? ServiceRecieverColor.primaryColor : Colors.grey.shade100),
                            ),
                            child: Center(
                              child: Text(
                                "${startloop + i + 1}",
                                maxLines: 1,
                                style: TextStyle(
                                  color: currentPageIndex == (startloop + i) ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 05),
                      ],
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: nextPage,
            child: Container(
              padding: const EdgeInsets.all(05),
              width: MediaQuery.of(context).size.width > 665 ? 30 : 20,
              height: MediaQuery.of(context).size.width > 665 ? 30 : 20,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(05)),
              child: currentPageIndex < totalRowsCount ? const SvgPicture(SvgAssetLoader("assets/images/icons/active-forward.svg")) : const SvgPicture(SvgAssetLoader("assets/images/icons/forward.svg")),
            ),
          ),
          const SizedBox(width: 05),
          InkWell(
            onTap: gotoLastPage,
            child: Container(
              padding: const EdgeInsets.all(05),
              width: MediaQuery.of(context).size.width > 665 ? 30 : 20,
              height: MediaQuery.of(context).size.width > 665 ? 30 : 20,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(05)),
              child: currentPageIndex < totalRowsCount ? const SvgPicture(SvgAssetLoader("assets/images/icons/active-skip-forward.svg")) : const SvgPicture(SvgAssetLoader("assets/images/icons/step-forward.svg")),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
