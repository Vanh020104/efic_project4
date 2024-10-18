import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop/entry_point.dart';

import 'package:shop/screens/checkout/views/payment.dart';
import 'package:shop/screens/designer/views/add_home_des.dart';
import 'package:shop/screens/designer/views/appointment_screen.dart';
import 'package:shop/screens/designer/views/list_appointment_user.dart';
import 'package:shop/screens/designer/views/list_designer.dart';
import 'package:shop/screens/designer/views/designer_appointment_detail.dart';
import 'package:shop/screens/designer/views/create_schedule_screen.dart';
import 'package:shop/screens/designer/views/designer_schedule_screen.dart';
import 'package:shop/screens/designer/views/register_designer_screen.dart';
import 'package:shop/screens/home/views/thank_you.dart';
import 'package:shop/screens/order/views/cancel_page.dart';
import 'package:shop/screens/order/views/complete_page.dart';
import 'package:shop/screens/order/views/create_page.dart';
import 'package:shop/screens/order/views/delivered_page.dart';
import 'package:shop/screens/order/views/location.dart';
import 'package:shop/screens/order/views/order_infor.dart';
import 'package:shop/screens/order/views/pending_page.dart' as pending;
import 'package:shop/screens/order/views/pending_page.dart';


import 'screen_export.dart';

// Yuo will get 50+ screens and more once you have the full template
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

// NotificationPermissionScreen()
// PreferredLanguageScreen()
// SelectLanguageScreen()
// SignUpVerificationScreen()
// ProfileSetupScreen()
// VerificationMethodScreen()
// OtpScreen()
// SetNewPasswordScreen()
// DoneResetPasswordScreen()
// TermsOfServicesScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFaceIdScreen()
// OnSaleScreen()
// BannerLStyle2()
// BannerLStyle3()
// BannerLStyle4()
// SearchScreen()
// SearchHistoryScreen()
// NotificationsScreen()
// EnableNotificationScreen()
// NoNotificationScreen()
// NotificationOptionsScreen()
// ProductInfoScreen()
// ShippingMethodsScreen()
// ProductReviewsScreen()
// SizeGuideScreen()
// BrandScreen()
// CartScreen()
// EmptyCartScreen()
// PaymentMethodScreen()
// ThanksForOrderScreen()
// CurrentPasswordScreen()
// EditUserInfoScreen()
// OrdersScreen()
// OrderProcessingScreen()
// OrderDetailsScreen()
// CancleOrderScreen()
// DelivereOrdersdScreen()
// AddressesScreen()
// NoAddressScreen()
// AddNewAddressScreen()
// ServerErrorScreen()
// NoInternetScreen()
// ChatScreen()
// DiscoverWithImageScreen()
// SubDiscoverScreen()
// AddNewCardScreen()
// EmptyPaymentScreen()
// GetHelpScreen()

// ℹ️ All the comments screen are included in the full template
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
    // case preferredLanuageScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const PreferredLanguageScreen(),
    //   );
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  const LoginScreen(),
      );
      case registerDesignerScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  RegisterDesignerScreen(),
      );
      case designerScheduleScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  const DesignerScheduleScreen(),
      );
      case createScheduleScreenRoute:
  return MaterialPageRoute(
    builder: (context) => const CreateScheduleScreen(),
  );
      case appointmentDetailScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          final args = settings.arguments as Map<String, dynamic>;
          final int appointmentId = args['appointmentId'];
          return AppointmentDetail(appointmentId: appointmentId);
        },
      );
    case signUpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
      case locationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LocationPage(),
      );
       case penddingScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  PendingPage(),
      );
    // case profileSetupScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProfileSetupScreen(),
    //   );
    case passwordRecoveryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PasswordRecoveryScreen(),
      );
      case deliveredScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  DeliveredPage(),
      );
      case completedScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  CompletePage(),
      );
       case cancelScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  CancelPage(),
      );
     case appoinmentScreenRoute:
  final args = settings.arguments as Map<String, dynamic>; 

  return MaterialPageRoute(
    builder: (context) => AppointmentScreen(
      designerId: args['designerId'], 
      
    ),
  );


       case createScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  CreatePage(),
      );

      case addhomedesScreenRoute:
        return MaterialPageRoute(
          builder: (context) =>  HouseDescriptionForm(),
        );


    case lisrDetailsScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  DesignerListScreen(),
      );
    case productDetailsScreenRoute:
  return MaterialPageRoute(
    builder: (context) {
      final args = settings.arguments as Map<String, dynamic>;
      final int productId = args['productId'];
      return ProductDetailsScreen(productId: productId);
    },
  );
    case productReviewsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProductReviewsScreen(),
      );
    // case addReviewsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddReviewScreen(),
    //   );
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  const HomeScreen(),
      );
    // case brandScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const BrandScreen(),
    //   );
    // case discoverWithImageScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DiscoverWithImageScreen(),
    //   );
    // case subDiscoverScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SubDiscoverScreen(),
    //   );
    case discoverScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const DiscoverScreen(),
      );
    case onSaleScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnSaleScreen(),
      );
    case kidsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const KidsScreen(),
      );
    case searchScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
       case appointmentListScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const AppointmentListScreen(),
      );
    // case searchHistoryScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SearchHistoryScreen(),
    //   );
    case bookmarkScreenRoute:
  return MaterialPageRoute(
    builder: (context) {
      final args = settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('categoryId')) {
        final int categoryId = args['categoryId'];
        return BookmarkScreen(categoryId: categoryId); // Truyền categoryId vào BookmarkScreen
      } else {
        return BookmarkScreen(); // Hoặc xử lý trường hợp không có categoryId
      }
    },
  );
    case entryPointScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );
    case profileScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  ProfileScreen(),
      );
    // case getHelpScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const GetHelpScreen(),
    //   );
    // case chatScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ChatScreen(),
    //   );
    case userInfoScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    case testScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  TestPage(),
      );
    // case currentPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CurrentPasswordScreen(),
    //   );
    // case editUserInfoScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EditUserInfoScreen(),
    //   );
        // Define your routes
    // case detailOrderScreenRoute:
    //   final orderId = settings.arguments as String; 
    //   return MaterialPageRoute(
    //     builder: (context) => pending.OrderDetailPage(orderId: orderId),
    //   );

    case notificationsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      );
    case noNotificationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NoNotificationScreen(),
      );
    case enableNotificationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EnableNotificationScreen(),
      );
    case notificationOptionsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationOptionsScreen(),
      );
    // case selectLanguageScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SelectLanguageScreen(),
    //   );
    // case noAddressScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoAddressScreen(),
    //   );
    case addressesScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  const AddressesScreen(),
      );
    // case addNewAddressesScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewAddressScreen(),
    //   );
    case ordersScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OrdersScreen(),
      );

    case orderInfoScreenRoute:
    return MaterialPageRoute(
      builder: (context) =>  OrderInfo(),
    );
    // case orderProcessingScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderProcessingScreen(),
    //   );
    // case orderDetailsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderDetailsScreen(),
    //   );
    // case cancleOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancleOrderScreen(),
    //   );
    // case deliveredOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DelivereOrdersdScreen(),
    //   );
    // case cancledOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancledOrdersScreen(),
    //   );
    case preferencesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PreferencesScreen(),
      );
    // case emptyPaymentScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EmptyPaymentScreen(),
    //   );
    case emptyWalletScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EmptyWalletScreen(),
      );
    case walletScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const WalletScreen(),
      );
    case cartScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const CartScreen(),
      );
    // case paymentMethodScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const PaymentMethodScreen(),
    //   );
    case paymentScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PaymentScreen(),
      );

    // case addNewCardScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewCardScreen(),
    //   );
    // case thanksForOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ThanksForOrderScreen(),
    //   );
    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (context) => const OnBordingScreen(),
      );
  }
}
