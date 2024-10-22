import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/carereceiver/utils/bottom_navigation_provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class GiverCustomAppBar extends StatelessWidget {
  const GiverCustomAppBar({
    super.key,
    required this.profileStatus,
    required this.showProfileIcon,
    this.title,
  });

  final bool profileStatus;
  final bool showProfileIcon;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: ServiceGiverColor.black,
      centerTitle: true,
      title: title != null
          ? Text(
              title.toString(),
              style: TextStyle(
                fontSize: 20,
                color: CustomColors.white,
                fontWeight: FontWeight.w600,
                fontFamily: "Rubik",
              ),
            )
          : null,
      actions: [
        GestureDetector(
          onTap: () {
            if (profileStatus) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: const Text(
                    "Please Complete Your \n Profile For Approval",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: profileStatus
                ? const Badge(
                    child: Icon(
                      Icons.message_outlined,
                      size: 30,
                    ),
                  )
                : const Icon(
                    Icons.message_outlined,
                    size: 30,
                  ),
          ),
        ),
        if (showProfileIcon) ...[
          InkWell(
            onTap: () => Provider.of<BottomNavigationProvider>(context, listen: false).updatePage(2),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(15, 0, 0, 0),
                      blurRadius: 4,
                      spreadRadius: 4,
                      offset: Offset(2, 2), // Shadow position
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Consumer<ServiceGiverProvider>(
                        builder: (context, provider, child) {
                          if (provider.fetchProfile == null) {
                            return Shimmer.fromColors(
                              baseColor: CustomColors.white,
                              highlightColor: CustomColors.primaryLight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFFFFFF),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(15, 0, 0, 0),
                                        blurRadius: 4,
                                        spreadRadius: 4,
                                        offset: Offset(2, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: CustomColors.paraColor,
                                  ),
                                ),
                              ),
                            );
                          }
                          return CachedNetworkImage(
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            imageUrl: "${provider.fetchProfile!.folderPath}/${provider.fetchProfile!.data!.avatar}",
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
