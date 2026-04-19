import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/core/routes/app_route_names.dart';
import 'package:smartinevntary/core/routes/app_router.dart';
import 'package:smartinevntary/core/services/local_storage.dart';
import 'package:smartinevntary/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:smartinevntary/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:smartinevntary/features/inventory/domain/usecases/get_all_item.dart';
import 'package:smartinevntary/features/inventory/domain/usecases/get_item_by_barcode.dart';
import 'package:smartinevntary/features/inventory/domain/usecases/update_item.dart';
import 'package:smartinevntary/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:smartinevntary/features/inventory/presentation/bloc/inventory_events.dart';
import 'package:smartinevntary/features/products/domain/usecases/get_product_by_id.dart';
import 'package:smartinevntary/features/products/presentation/bloc/product_events.dart';
import 'package:smartinevntary/features/products/presentation/bloc/products_bloc.dart';
import 'package:smartinevntary/features/reports/data/repositories/report_repository_impl.dart';
import 'package:smartinevntary/features/reports/domain/usecases/GetReport.dart';
import 'package:smartinevntary/features/reports/presentation/bloc/report_bloc.dart';
import 'package:smartinevntary/features/sale/data/datasources/sale_remote_datasource.dart';
import 'package:smartinevntary/features/sale/data/repositories/sale_repository_impl.dart';
import 'package:smartinevntary/features/sale/domain/usecases/execute_sale.dart';
import 'package:smartinevntary/features/sale/domain/usecases/get_sales_history.dart';
import 'package:smartinevntary/features/sale/presentation/bloc/sale_bloc.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/domain/usecases/add_item.dart';
import 'features/products/data/datasources/product_remote_datasource.dart';
import 'features/products/data/repositories/product_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //PRODUCTS BLOC
        BlocProvider(
          create: (context) {
            // PRODUCT DI
            final remote = ProductRemoteDatasource(FirebaseFirestore.instance);
            final repo = ProductRepositoryImpl(remote);
            return ProductsBloc(repo)..add(LoadProduct());
          },
        ),

        //AUTH BLOC
        BlocProvider(
          create: (context) {
            // AUTH DI
            final authRemote = AuthRemoteDatasource(FirebaseAuth.instance);
            final authRepo = AuthRepositoryImpl(authRemote);

            // LOCAL STORAGE DI
            final localStorage = LocalStorageServices();
            final loginUser = LoginUser(authRepo);
            final registerUser = RegisterUser(authRepo);
            final logoutUser = LogoutUser(authRepo);
            return AuthBloc(loginUser, registerUser, logoutUser, localStorage);
          },
        ),

        //INVENTORY BLOC
        BlocProvider(
          create: (context) {
            // 1. Initialize the Worker (Datasource)
            final inventoryRemote = InventoryRemoteDatasource(
              FirebaseFirestore.instance,
            );

            // 2. Initialize the Boss (Repository)
            final inventoryRepo = InventoryRepositoryImpl(inventoryRemote);

            // 3. Initialize the Secretaries (Use Cases)
            final addItemToInventory = AddItemToInventory(inventoryRepo);
            final getAllItems = GetAllItems(inventoryRepo);
            final getItemByBarcode = GetItemByBarcode(inventoryRepo);
            final updatedItem = UpdateItem(inventoryRepo);

            return InventoryBloc(
              addItemToInventory,
              getAllItems,
              getItemByBarcode,
              updatedItem,
            )..add(GetAllInventoryItems());
          },
        ),

        //SALE BLOC
        BlocProvider(
          create: (context) {
            final fireStore = FirebaseFirestore.instance;

            final saleRemoteDataSource = SaleRemoteDatasource(fireStore);
            final inventoryRemoteDataSource = InventoryRemoteDatasource(
              fireStore,
            );
            final productRemoteDataSource = ProductRemoteDatasource(fireStore);

            final saleRepository = SaleRepositoryImpl(saleRemoteDataSource);
            final inventoryRepository = InventoryRepositoryImpl(
              inventoryRemoteDataSource,
            );
            final productRepository = ProductRepositoryImpl(
              productRemoteDataSource,
            );

            final executeSale = ExecuteSale(saleRepository);
            final getSalesHistory = GetSalesHistory(saleRepository);
            final getProductById = GetProductById(productRepository);
            final getItemByBarcode = GetItemByBarcode(inventoryRepository);
            return SaleBloc(
              executeSale,
              getSalesHistory,
              getProductById,
              getItemByBarcode,
            );
          },
        ),

        //REPORT BLOC
        BlocProvider(
          create: (context) {
            final firestore = FirebaseFirestore.instance;
            final saleRemoteDatasource = SaleRemoteDatasource(firestore);
            final reportRepository = ReportRepositoryImpl(saleRemoteDatasource);
            final getReport = GetReport(reportRepository);
            return ReportBloc(getReport);
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Inventory',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        initialRoute: RouteNames.splash,
        onGenerateRoute: AppRouterManager.generateRoutes,
      ),
    );
  }
}
