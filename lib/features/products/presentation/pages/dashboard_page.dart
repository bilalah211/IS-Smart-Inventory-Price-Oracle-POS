import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartinevntary/core/constants/app_assets.dart';
import 'package:smartinevntary/core/constants/app_strings.dart';
import 'package:smartinevntary/core/routes/app_route_names.dart';
import 'package:smartinevntary/core/theme/app_colors.dart';
import 'package:smartinevntary/core/theme/app_textstyle.dart';
import 'package:smartinevntary/core/utils/flushbar_utils.dart';
import 'package:smartinevntary/core/widgets/my_appbar.dart';
import 'package:smartinevntary/features/products/data/models/cart_item.dart';
import 'package:smartinevntary/features/products/domain/entities/dashboard_items.dart';
import 'package:smartinevntary/features/products/presentation/bloc/products_bloc.dart';
import 'package:smartinevntary/features/products/presentation/widgets/app_drawer.dart';
import 'package:smartinevntary/features/sale/domain/entities/sale.dart';
import 'package:smartinevntary/features/sale/presentation/bloc/sale_bloc.dart';
import 'package:smartinevntary/features/sale/presentation/bloc/sale_event.dart';
import 'package:smartinevntary/features/sale/presentation/bloc/sale_state.dart';
import '../../../../core/widgets/rounded_button.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  TextEditingController tController = TextEditingController();
  TextEditingController pController = TextEditingController();
  final List<CartItem> itemCart = [];
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();

    context.read<SaleBloc>().add(GetAllSalesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      appBar: MyAppbar(
        title: AppStrings.dashboard,
        icon: Icons.menu,
        actions: [Icon(Icons.notifications, color: Colors.white)],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
        child: Column(
          children: [
            //---[TODAY TOTAL SALES ]---
            _todayTotalSaleBloc(),
            SizedBox(height: 30),

            //---[SCAN BUTTON]---
            _buildScanButton(context),
            SizedBox(height: 20),

            //---[TILES INVENTORY,SALES]---
            _buildTiles(),
          ],
        ),
      ),
    );
  }

  //TILES+INVENTORY+SALES
  Widget _buildTiles() {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return _buildDashboardTiles(context, item);
        },
      ),
    );
  }

  //SCAN BUTTON
  Widget _buildScanButton(BuildContext context) {
    return RoundedContainer(
      name: AppStrings.scan,
      onTap: () async {
        _buildShowSaleModalBottomSheet(context);
      },
    );
  }

  //TOTAL TODAY SALE BLOC TOP SECTION
  BlocBuilder<SaleBloc, SaleState> _todayTotalSaleBloc() {
    return BlocBuilder<SaleBloc, SaleState>(
      builder: (context, state) {
        double todayTotal = 0;
        if (state is LoadedSaleState) {
          final now = DateTime.now();

          todayTotal = state.saleItem
              .where((item) {
                return item.saleDate.year == now.year &&
                    item.saleDate.month == now.month &&
                    item.saleDate.day == now.day;
              })
              .fold(0, (sum, item) {
                final qty = double.tryParse(item.quantitySold) ?? 0;
                final price = double.tryParse(item.productPrice) ?? 0;
                return sum + (qty * price);
              });
        }
        return Container(
          padding: EdgeInsetsGeometry.all(50),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            border: Border.all(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              'Today Sales: \$${todayTotal.toStringAsFixed(2)}',
              style: AppTextStyles.bodyTextTitle.copyWith(fontSize: 22),
            ),
          ),
        );
      },
    );
  }

  //SALE BOTTOM SHEET
  Future<dynamic> _buildShowSaleModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (context) {
        return BlocListener<SaleBloc, SaleState>(
          listener: (context, state) {
            if (state is InitialSaleState) {
              Navigator.pop(context);
            }

            if (state is ErrorSaleState) {
              FlushbarUtils.showError(context, message: state.message);
            }
          },
          child: StatefulBuilder(
            builder: (context, setModalState) {
              double totalAmount = itemCart.fold(
                0,
                (sum, item) => sum + (item.product.price * item.quantity),
              );

              return Container(
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),

                      child: Row(
                        children: [
                          Container(
                            height: 38,

                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.bgWhite,
                                size: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: 80),
                          Text(
                            AppStrings.scanItem,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SCANNER SECTION
                    _scannerSection(context, setModalState),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        AppStrings.currentSale,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(),

                    // LISTVIEW SECTION
                    Expanded(
                      child: itemCart.isEmpty
                          ? const Center(
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Icon(Icons.document_scanner),
                                  Text(AppStrings.notItemScanned),
                                ],
                              ),
                            )
                          : _itemsListView(),
                    ),

                    //BOTTOM SUMMARY & SAVE ACTION
                    _bottomSummaryCard(totalAmount, context),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  //SCANNER SECTION
  Widget _scannerSection(BuildContext context, StateSetter setModalState) {
    return SizedBox(
      height: 250,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
          bottom: Radius.circular(25),
        ),
        child: MobileScanner(
          onDetect: (capture) async {
            final barcode = capture.barcodes.first.rawValue;
            if (barcode != null && !isProcessing) {
              isProcessing = true;
              final product = await context
                  .read<ProductsBloc>()
                  .repositoryImpl
                  .getProductsById(barcode);

              if (product != null && context.mounted) {
                setModalState(() {
                  int index = itemCart.indexWhere(
                    (item) => item.product.id == barcode,
                  );
                  if (index != -1) {
                    itemCart[index].quantity++;
                  } else {
                    itemCart.add(CartItem(product: product, quantity: 1));
                  }
                });
              }
              await Future.delayed(const Duration(seconds: 1));
              isProcessing = false;
            }
          },
        ),
      ),
    );
  }

  //ITEMS LISTVIEW
  Widget _itemsListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemCart.length,
      itemBuilder: (context, index) {
        final product = itemCart[index].product;

        return ListTile(
          title: Text(
            product.title,
            style: AppTextStyles.bodyTextTitle.copyWith(
              color: Colors.grey.shade900,
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: .start,
              children: [
                SizedBox(
                  height: 30,
                  child: Text(
                    'Qty:',
                    style: AppTextStyles.bodyTextTitle.copyWith(
                      color: AppColors.greyTextSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                _buildMyTextFormField(index),
              ],
            ),
          ),
          trailing: Text(
            '\$${product.price.toString()}',
            style: AppTextStyles.linkTextBlue.copyWith(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }

  //QUANTITY FIELD
  Widget _buildMyTextFormField(int index) {
    return SizedBox(
      width: 65,
      height: 35,
      child: TextFormField(
        initialValue: itemCart[index].quantity.toString(),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(4),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: (value) {
          setState(() {
            itemCart[index].quantity = int.tryParse(value) ?? 1;
          });
        },
      ),
    );
  }

  //SUMMARY CARD + SAVE BUTTON
  Widget _bottomSummaryCard(double totalAmount, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.total,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${totalAmount.toStringAsFixed(2)}",
                style: AppTextStyles.linkTextBlue.copyWith(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 15),

          _saveSaleButton(context),
        ],
      ),
    );
  }

  //SAVE BUTTON
  Widget _saveSaleButton(BuildContext context) {
    return BlocBuilder<SaleBloc, SaleState>(
      builder: (context, state) {
        bool isLoading = state is LoadingSaleState;

        return RoundedContainer(
          name: AppStrings.save,
          isLoading: isLoading,
          onTap: () {
            if (itemCart.isEmpty) {
              FlushbarUtils.showWarning(
                context,
                message: "Please scan at least one item before saving",
              );
              return;
            }

            final List<SaleItem> saleItems = itemCart.map((item) {
              return SaleItem(
                productId: item.product.id,
                productName: item.product.title,
                productPrice: item.product.price.toString(),
                quantitySold: item.quantity.toString(),
                saleDate: DateTime.now(),
              );
            }).toList();

            context.read<SaleBloc>().add(ExecuteSaleEvent(saleItems));

            setState(() {
              itemCart.clear();
            });
          },
        );
      },
    );
  }

  //DASHBOARD TILE
  Widget _buildDashboardTiles(BuildContext context, DashboardItems item) {
    final colorTiles = _getIconColor(item.id);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, item.routeName),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            // Image Wrapper
            Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: colorTiles,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(item.iconPath, fit: BoxFit.contain),
            ),
            const SizedBox(width: 15),

            // Text Section
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyles.bodyTextTitle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),

            // Action Icon
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  //DASHBOARD ITEMS
  List<DashboardItems> items = [
    DashboardItems(
      id: '1',
      title: 'Inventory',
      iconPath: AppAssets.inventory,
      routeName: RouteNames.inventory,
    ),
    DashboardItems(
      id: '2',
      title: 'Sales',
      iconPath: AppAssets.sale,
      routeName: RouteNames.sales,
    ),
    DashboardItems(
      id: '3',
      title: 'Reports',
      iconPath: AppAssets.reports,
      routeName: RouteNames.reports,
    ),
  ];

  //COLORS INDEX
  Color _getIconColor(String id) {
    switch (id) {
      case '1':
        return Colors.green.shade50;

      case '2':
        return Colors.purple.shade50;
      case '3':
        return Colors.orange.shade50;
      default:
        return Colors.grey.shade200;
    }
  }
}
