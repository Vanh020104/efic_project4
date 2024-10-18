import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/entry_point.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/screens/designer/views/designer_schedule_screen.dart';
import 'package:shop/services/user_service.dart';
import 'package:shop/services/login_service.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LoginService _loginService = LoginService();
  final UserService _userService = UserService();
  String _name = '';
  String _email = '';
  String _imageSrc = '';
  bool isUser = false; 
  bool isDesigner = false; 

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    checkUserRole(); 
  }

  Future<void> checkUserRole() async {
    List<String>? roles = await _loginService.getRoles();
    if (roles != null) {
      setState(() {
        // Kiểm tra vai trò ROLE_USER
        isUser = roles.contains('ROLE_USER');
        // Kiểm tra vai trò ROLE_DESIGNER
        isDesigner = roles.contains('ROLE_DESIGNER');
      });
      if (isDesigner) {
        print("User is a designer!");
      } else if (isUser) {
        print("User is a normal user.");
      } else {
        print("User has no specific role.");
      }
    }
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      try {
        final userInfo = await _userService.getUserInfo(userId);
        setState(() {
          _name = userInfo['username'] ?? 'Unknown';
          _email = userInfo['email'] ?? 'Unknown';
          _imageSrc = userInfo['avatar'] ?? '';
        });
      } catch (e) {
        print('Failed to load user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ProfileCard(
            name: _name,
            email: _email,
            imageSrc: '',

            press: () {
              Navigator.pushNamed(context, userInfoScreenRoute);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding * 1.5),
            child: GestureDetector(
              onTap: () {},
              child: const AspectRatio(
                aspectRatio: 1.8,
                child:
                    NetworkImageWithLoader("https://i.imgur.com/dz0BBom.png"),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ProfileMenuListTile(
            text: "Orders",
            svgSrc: "assets/icons/Order.svg",
            press: () {
              Navigator.pushNamed(context, ordersScreenRoute);
            },
          ),

          // const SizedBox(height: defaultPadding),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       horizontal: defaultPadding, vertical: defaultPadding / 2),
          //   child: Text(
          //     "Settings",
          //     style: Theme.of(context).textTheme.titleSmall,
          //   ),
          // ),
          // ProfileMenuListTile(
          //   text: "List Designer",
          //   svgSrc: "assets/icons/Man.svg",
          //   press: () {
          //     Navigator.pushNamed(context, lisrDetailsScreenRoute);
          //   },
          // ),
          //  ProfileMenuListTile(
          //     text: "Register as Designer",
          //     svgSrc: "assets/icons/Man.svg",
          //     press: () {
          //       Navigator.pushNamed(context, registerDesignerScreenRoute);
          //     },
          //   ),
          //   ProfileMenuListTile(
          //     text: "My consulting list",
          //     svgSrc: "assets/icons/Sort.svg",
          //     press: () {
          //       Navigator.pushNamed(context, appointmentListScreenRoute);
          //     },
          //   ),
          
          const SizedBox(height: defaultPadding),

          
          if (isUser) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Help & Support for User",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ProfileMenuListTile(
            text: "Location",
            svgSrc: "assets/icons/Location.svg",
            press: () {
               Navigator.pushNamed(context, locationScreenRoute);
            },
          ),
            ProfileMenuListTile(
              text: "Get Help",
              svgSrc: "assets/icons/Help.svg",
              press: () {
                Navigator.pushNamed(context, getHelpScreenRoute);
              },
            ),
            ProfileMenuListTile(
            text: "List Designer",
            svgSrc: "assets/icons/Man.svg",
            press: () {
              Navigator.pushNamed(context, lisrDetailsScreenRoute);
            },
          ),
           ProfileMenuListTile(
              text: "Register as Designer",
              svgSrc: "assets/icons/Man.svg",
              press: () {
                Navigator.pushNamed(context, registerDesignerScreenRoute);
              },
            ),
            ProfileMenuListTile(
              text: "My consulting list",
              svgSrc: "assets/icons/Sort.svg",
              press: () {
                Navigator.pushNamed(context, appointmentListScreenRoute);
              },
            ),
           
          ],

          
          if (isDesigner) ...[
            const SizedBox(height: defaultPadding),
            Padding(
    padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
    child: Text(
      "Designer Options",
      style: Theme.of(context).textTheme.titleSmall,
    ),
  ),
  ProfileMenuListTile(
    text: "Manage Schedule",
    svgSrc: "assets/icons/Cash.svg",
    press: () {
      Navigator.pushNamed(context, designerScheduleScreenRoute);
    },
  ),
            ProfileMenuListTile(
              text: "FAQ",
              svgSrc: "assets/icons/FAQ.svg",
              press: () {},
              isShowDivider: false,
            ),
          ],

          const SizedBox(height: defaultPadding),
          ListTile(
            onTap: () async {
              await _loginService.logout();
              ScaffoldMessenger.of(context).showSnackBar(

              const SnackBar(
                content: Text(
                  'Logout successful!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: primaryColor,
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EntryPoint(),
                ),
              );
            },
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text(
              "Log Out",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          ),
        ],
      ),
    );
  }
}
