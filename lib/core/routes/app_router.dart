import 'package:flutter/material.dart';
import 'package:smartinevntary/core/routes/app_route_names.dart';
import 'package:smartinevntary/features/auth/presentation/pages/login_page.dart';
import 'package:smartinevntary/features/auth/presentation/pages/splash_page.dart';
import 'package:smartinevntary/features/products/presentation/pages/dashboard_page.dart';
import 'package:smartinevntary/features/inventory/presentation/pages/inventory_page.dart';
import '../../features/reports/presentation/pages/report_page.dart';
import '../../features/sale/presentation/pages/sale_page.dart';

class AppRouterManager {
  static Route<dynamic> generateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (context) => SplashPage());

      case RouteNames.login:
        return MaterialPageRoute(builder: (context) => LoginPage());

      case RouteNames.dashboard:
        return MaterialPageRoute(builder: (context) => DashboardPage());

      case RouteNames.inventory:
        return MaterialPageRoute(builder: (context) => InventoryPage());

      case RouteNames.sales:
        return MaterialPageRoute(builder: (context) => SalePage());

      case RouteNames.reports:
        return MaterialPageRoute(builder: (context) => ReportsPage());
      default:
        return MaterialPageRoute(
          builder: (context) => Center(child: Text('No Route Define Yet!')),
        );
    }
  }
}
