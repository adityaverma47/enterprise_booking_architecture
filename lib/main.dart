import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'di/app_module.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/booking_controller.dart';
import 'presentation/auth/screens/login_screen.dart';
import 'presentation/user/screens/user_home_screen.dart';
import 'presentation/user/screens/create_booking_screen.dart';
import 'presentation/provider/screens/provider_home_screen.dart';
import 'presentation/admin/screens/admin_home_screen.dart';
import 'core/constants/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await setupDependencies();
  
  // Register GetX controllers
  Get.put(getIt<AuthController>());
  Get.put(getIt<BookingController>());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Enterprise Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      getPages: [
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: AppRoutes.userHome,
          page: () => const UserHomeScreen(),
        ),
        GetPage(
          name: AppRoutes.createBooking,
          page: () => const CreateBookingScreen(),
        ),
        GetPage(
          name: AppRoutes.providerHome,
          page: () => const ProviderHomeScreen(),
        ),
        GetPage(
          name: AppRoutes.adminHome,
          page: () => const AdminHomeScreen(),
        ),
      ],
    );
  }
}
