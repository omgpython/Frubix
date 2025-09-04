import 'package:frubix/main.dart';
import 'package:frubix/screens/admin/admin/add_admin_screen.dart';
import 'package:frubix/screens/admin/admin/admin_screen.dart';
import 'package:frubix/screens/admin/category/admin_add_category_screen.dart';
import 'package:frubix/screens/admin/category/admin_category_screen.dart';
import 'package:frubix/screens/admin/category/admin_edit_category_screen.dart';
import 'package:frubix/screens/admin/dashboard_screen.dart';
import 'package:frubix/screens/admin/order/admin_assigned_order_screen.dart';
import 'package:frubix/screens/admin/order/admin_completed_order_screen.dart';
import 'package:frubix/screens/admin/order/admin_order_detail_screen.dart';
import 'package:frubix/screens/admin/order/admin_pending_order_screen.dart';
import 'package:frubix/screens/admin/product/admin_add_product_screen.dart';
import 'package:frubix/screens/admin/product/admin_edit_product_screen.dart';
import 'package:frubix/screens/admin/product/admin_product_screen.dart';
import 'package:frubix/screens/admin/profile/admin_edit_profile_screen.dart';
import 'package:frubix/screens/admin/profile/admin_profile_screen.dart';
import 'package:frubix/screens/admin/user/admin_user_orders_screen.dart';
import 'package:frubix/screens/admin/user/admin_user_screen.dart';
import 'package:frubix/screens/user/home_screen.dart';
import 'package:frubix/screens/user/login_screen.dart';
import 'package:frubix/screens/user/order/address_screen.dart';
import 'package:frubix/screens/user/order/cart_screen.dart';
import 'package:frubix/screens/user/order/checkout_screen.dart';
import 'package:frubix/screens/user/order/order_detail_screen.dart';
import 'package:frubix/screens/user/order/order_screen.dart';
import 'package:frubix/screens/user/product/category_wise_product_screen.dart';
import 'package:frubix/screens/user/product/search_product_screen.dart';
import 'package:frubix/screens/user/profile/about_us_screen.dart';
import 'package:frubix/screens/user/profile/contact_us_screen.dart';
import 'package:frubix/screens/user/profile/faq_screen.dart';
import 'package:frubix/screens/user/profile/privacy_policy_screen.dart';
import 'package:frubix/screens/user/profile/profile_screen.dart';
import 'package:frubix/screens/user/register_screen.dart';
import 'package:frubix/screens/user/success_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/admin/admin/edit_admin_screen.dart';
import '../screens/admin/admin_login_screen.dart';
import '../screens/admin/product/admin_view_product_screen.dart';
import '../screens/user/product/product_detail_screen.dart';
import '../screens/user/profile/terms_screen.dart';
import '../screens/user/splash_screen.dart';

class Routes {
  static final String splashScreen = '/user/splash';

  //login - register
  static final String adminLoginScreen = '/admin/login';
  static final String userLoginScreen = '/user/login';
  static final String userRegisterScreen = '/user/register';

  static final String dashboardScreen = '/admin/dashboard';
  static final String homeScreen = '/user/home';

  //category
  static final String adminCategoryScreen = '/admin/category';
  static final String adminAddCategoryScreen = '/admin/category/add';
  static final String adminEditCategoryScreen = '/admin/category/edit/:id';
  static final String userCategoryWiseProductScreen =
      '/user/category/product/:id';

  //product
  static final String adminProductScreen = '/admin/product';
  static final String adminAddProductScreen = '/admin/product/add';
  static final String adminEditProductScreen = '/admin/product/edit/:id';
  static final String adminViewProductScreen = '/admin/product/view/:id';
  static final String userProductDetailScreen = '/user/product/detail/:id';
  static final String userSearchProductScreen = '/user/product/search';

  //order
  static final String userCartScreen = '/user/cart';
  static final String userAddressScreen = '/user/cart/address';
  static final String userCheckOutScreen = '/user/cart/checkout';
  static final String userSuccessScreen = '/user/success';
  static final String adminPendingOrderScreen = '/admin/order/pending';
  static final String adminAssignedOrderScreen = '/admin/order/assigned';
  static final String adminCompletedOrderScreen = '/admin/order/completed';
  static final String adminOrderDetailScreen =
      '/admin/order/details/:index/:id';
  static final String userOrderScreen = '/user/order';
  static final String userOrderDetailsScreen = '/user/order/details/:id';

  //profile
  static final String userProfileScreen = '/user/profile';
  static final String adminProfileScreen = '/admin/profile/:index';
  static final String adminEditProfileScreen =
      '/admin/profile/edit_profile/:index';
  static final String userContactUsScreen = '/user/profile/contact_us';
  static final String userAboutUsScreen = '/user/profile/about_us';
  static final String userFaqScreen = '/user/profile/faq';
  static final String userPrivacyPolicyScreen = '/user/profile/privacy_policy';
  static final String userTermsScreen = '/user/profile/terms';

  //admin
  static final String adminScreen = '/admin/admins';
  static final String addAdminScreen = '/admin/admins/add';
  static final String editAdminScreen = '/admin/admins/edit/:id';

  // user - admin
  static final String adminUserScreen = '/admin/users';
  static final String adminUserOrdersScreen = '/admin/users/orders/:id';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => RedirectScreen()),

      GoRoute(path: splashScreen, builder: (context, state) => SplashScreen()),

      //login - register
      GoRoute(
        path: adminLoginScreen,
        builder: (context, state) => AdminLoginScreen(),
      ),
      GoRoute(
        path: userLoginScreen,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: userRegisterScreen,
        builder: (context, state) => RegisterScreen(),
      ),

      GoRoute(
        path: dashboardScreen,
        builder: (context, state) => DashboardScreen(),
      ),
      GoRoute(path: homeScreen, builder: (context, state) => HomeScreen()),

      //Category
      GoRoute(
        path: adminCategoryScreen,
        builder: (context, state) => AdminCategoryScreen(),
      ),
      GoRoute(
        path: adminAddCategoryScreen,
        builder: (context, state) => AdminAddCategoryScreen(),
      ),
      GoRoute(
        path: adminEditCategoryScreen,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return AdminEditCategoryScreen(id: id!);
        },
      ),
      GoRoute(
        path: userCategoryWiseProductScreen,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return CategoryWiseProductScreen(id: id!);
        },
      ),

      //Products
      GoRoute(
        path: adminProductScreen,
        builder: (context, state) => AdminProductScreen(),
      ),
      GoRoute(
        path: adminAddProductScreen,
        builder: (context, state) => AdminAddProductScreen(),
      ),
      GoRoute(
        path: adminEditProductScreen,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return AdminEditProductScreen(id: id!);
        },
      ),
      GoRoute(
        path: adminViewProductScreen,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return AdminViewProductScreen(id: id!);
        },
      ),
      GoRoute(
        path: userProductDetailScreen,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return ProductDetailScreen(id: id!);
        },
      ),
      GoRoute(
        path: userSearchProductScreen,
        builder: (context, state) => SearchProductScreen(),
      ),

      //Order
      GoRoute(path: userCartScreen, builder: (context, state) => CartScreen()),
      GoRoute(
        path: userAddressScreen,
        builder: (context, state) => AddressScreen(),
      ),
      GoRoute(
        path: userCheckOutScreen,
        builder: (context, state) => CheckoutScreen(),
      ),
      GoRoute(
        path: userSuccessScreen,
        builder: (context, state) => SuccessScreen(),
      ),
      GoRoute(
        path: adminPendingOrderScreen,
        builder: (context, state) => AdminPendingOrderScreen(),
      ),
      GoRoute(
        path: adminAssignedOrderScreen,
        builder: (context, state) => AdminAssignedOrderScreen(),
      ),
      GoRoute(
        path: adminCompletedOrderScreen,
        builder: (context, state) => AdminCompletedOrderScreen(),
      ),
      GoRoute(
        path: adminOrderDetailScreen,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          final index = state.pathParameters['index'];
          return AdminOrderDetailScreen(index: index!, id: id!);
        },
      ),
      GoRoute(
        path: userOrderScreen,
        builder: (context, state) => OrderScreen(),
      ),
      GoRoute(
        path: userOrderDetailsScreen,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return OrderDetailScreen(id: id!);
        },
      ),

      //Profile
      GoRoute(
        path: userProfileScreen,
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: adminProfileScreen,
        builder: (context, state) {
          final index = state.pathParameters['index'];
          return AdminProfileScreen(index: index!);
        },
      ),
      GoRoute(
        path: adminEditProfileScreen,
        builder: (context, state) {
          final index = state.pathParameters['index'];
          return AdminEditProfileScreen(index: index!);
        },
      ),
      GoRoute(
        path: userContactUsScreen,
        builder: (context, state) => ContactUsScreen(),
      ),
      GoRoute(
        path: userAboutUsScreen,
        builder: (context, state) => AboutUsScreen(),
      ),
      GoRoute(path: userFaqScreen, builder: (context, state) => FaqScreen()),
      GoRoute(
        path: userPrivacyPolicyScreen,
        builder: (context, state) => PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: userTermsScreen,
        builder: (context, state) => TermsScreen(),
      ),

      //Admin
      GoRoute(path: adminScreen, builder: (context, state) => AdminScreen()),
      GoRoute(
        path: addAdminScreen,
        builder: (context, state) => AddAdminScreen(),
      ),
      GoRoute(
        path: editAdminScreen,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return EditAdminScreen(id: id!);
        },
      ),

      // User - Admin
      GoRoute(
        path: adminUserScreen,
        builder: (context, state) => AdminUserScreen(),
      ),
      GoRoute(
        path: adminUserOrdersScreen,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return AdminUserOrdersScreen(id: id!);
        },
      ),
    ],
  );
}
