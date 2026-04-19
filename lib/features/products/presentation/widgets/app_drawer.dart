import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/core/routes/app_route_names.dart';
import 'package:smartinevntary/core/services/local_storage.dart';
import 'package:smartinevntary/core/theme/app_colors.dart';
import 'package:smartinevntary/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:smartinevntary/features/auth/presentation/bloc/bloc_events/auth_events.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final myAuth = context.read<AuthBloc>();
    final localStorage = LocalStorageServices();
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryLight),
            accountName: Text("Smart Inventory"),
            accountEmail: Text("admin@example.com"),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text("Inventory"),
            onTap: () {
              Navigator.pushNamed(context, '/inventory');
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text('Do you want to logout from your account!'),
                  title: Text('Logout!'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        myAuth.add(LogoutEvent());
                        localStorage.setData(false);
                        Navigator.pushNamed(context, RouteNames.login);
                      },
                      icon: Text(
                        'Yes',
                        style: TextStyle(
                          color: AppColors.errorRed,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Text('No', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
