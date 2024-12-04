import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool status1 = false;
  bool status2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(30, 0, 0, 0),
                    offset: Offset(2, 2),
                    spreadRadius: 1,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: CustomColors.primaryColor,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            fontFamily: "Rubik",
            color: CustomColors.primaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Account Settings",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontFamily: "Rubik",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: CustomColors.red,
                    child: Icon(
                      Icons.lock,
                      color: CustomColors.white,
                    ),
                  ),
                  tileColor: CustomColors.white,
                  title: Text(
                    "Change Password",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: CustomColors.green,
                    child: Icon(
                      Icons.notifications_on_sharp,
                      color: CustomColors.white,
                    ),
                  ),
                  tileColor: CustomColors.white,
                  title: Text(
                    "Notifications",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: CustomColors.sky,
                    child: Icon(
                      Icons.pie_chart_rounded,
                      color: CustomColors.white,
                    ),
                  ),
                  tileColor: CustomColors.white,
                  title: Text(
                    "Statistics",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: CustomColors.orange,
                    child: Icon(
                      Icons.people,
                      color: CustomColors.white,
                    ),
                  ),
                  tileColor: CustomColors.white,
                  title: Text(
                    "About us",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
                ListTile(
                  tileColor: CustomColors.white,
                  title: Text(
                    "More Options",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  tileColor: CustomColors.white,
                  title: Text(
                    "Text Messages",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 38,
                    height: 20,
                    child: CupertinoSwitch(
                      activeColor: Colors.red,
                      value: status1,
                      onChanged: (value) {
                        setState(() {
                          status1 = value;
                        });
                      },
                    ),
                  ),
                ),
                ListTile(
                  tileColor: CustomColors.white,
                  title: Text(
                    "Phone Calls",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 38,
                    height: 20,
                    child: CupertinoSwitch(
                      activeColor: Colors.red,
                      value: status2,
                      onChanged: (val) {
                        setState(
                          () {
                            status2 = val;
                          },
                        );
                      },
                    ),
                  ),
                ),
                ListTile(
                  tileColor: CustomColors.white,
                  title: Text(
                    "Languages",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "English",
                          style: TextStyle(
                            color: CustomColors.hintText,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Rubik",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  tileColor: CustomColors.white,
                  title: Text(
                    "Currency",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "\$-USD",
                          style: TextStyle(
                            color: CustomColors.hintText,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Rubik",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  tileColor: CustomColors.white,
                  title: Text(
                    "Linkedin accounts",
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Facebook, Google",
                          style: TextStyle(
                            color: CustomColors.hintText,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Rubik",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
