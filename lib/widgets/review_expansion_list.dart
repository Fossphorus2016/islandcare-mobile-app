import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/custom_expansion_panel.dart';

class ReviewExpansionList extends StatefulWidget {
  const ReviewExpansionList({super.key, required this.name, this.rating, this.comment, this.imgProviderPath});

  final String name;
  final int? rating;
  final String? comment;
  final String? imgProviderPath;
  @override
  State<ReviewExpansionList> createState() => _ReviewExpansionListState();
}

class _ReviewExpansionListState extends State<ReviewExpansionList> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(expansionTileTheme: const ExpansionTileThemeData(shape: RoundedRectangleBorder(side: BorderSide.none))),
      child: CustomExpansionPanelList(
        borderColor: Colors.white,
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 1,
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            expanded = !expanded;
          });
        },
        children: [
          CustomExpansionPanel(
            canTapOnHeader: true,
            isExpanded: expanded,
            backgroundColor: Colors.white,
            headerBuilder: (context, isExpanded) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontFamily: "Rubik",
                      fontSize: 14,
                      color: CustomColors.primaryTextLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.imgProviderPath != null) ...[
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(500),
                      child: CachedNetworkImage(
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        imageUrl: widget.imgProviderPath.toString(),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ],
                ],
              );
            },
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Name:",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: CustomColors.primaryText,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (widget.rating != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Rating:",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: CustomColors.primaryText,
                          ),
                        ),
                        const SizedBox(width: 10),
                        RatingBar.builder(
                          initialRating: widget.rating!.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: false,
                          itemSize: 15,
                          itemCount: 5,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (widget.comment != null && widget.comment!.isNotEmpty && widget.comment != "null") ...[
                    Wrap(
                      children: [
                        Text(
                          "Comment:",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: CustomColors.primaryText,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.comment.toString(),
                          maxLines: 20,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: CustomColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
