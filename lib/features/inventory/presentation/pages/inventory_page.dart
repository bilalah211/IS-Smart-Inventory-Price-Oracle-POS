import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartinevntary/core/theme/app_colors.dart';
import 'package:smartinevntary/core/theme/app_textstyle.dart';
import 'package:smartinevntary/core/utils/flushbar_utils.dart';
import 'package:smartinevntary/core/utils/loader.dart';
import 'package:smartinevntary/core/utils/validator.dart';
import 'package:smartinevntary/core/widgets/my_appbar.dart';
import 'package:smartinevntary/core/widgets/rounded_button.dart';
import 'package:smartinevntary/core/widgets/shimmer_list_tile.dart';
import 'package:smartinevntary/features/auth/presentation/widgets/my_textfield.dart';
import 'package:smartinevntary/features/inventory/data/model/inventory_model.dart';
import 'package:smartinevntary/features/inventory/domain/entities/inventory.dart';
import 'package:smartinevntary/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:smartinevntary/features/inventory/presentation/bloc/inventory_events.dart';
import 'package:smartinevntary/features/inventory/presentation/bloc/inventory_states.dart';
import 'package:smartinevntary/features/products/data/models/product_model.dart';
import 'package:smartinevntary/features/products/presentation/bloc/products_bloc.dart';
import '../../../products/domain/entities/product.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final productIdController = TextEditingController();
  final productTitleController = TextEditingController();
  final productPriceController = TextEditingController();
  final productQuantityController = TextEditingController();
  late final inventoryBloc = context.read<InventoryBloc>();
  late final productBloc = context.read<ProductsBloc>();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    productTitleController.dispose();
    productPriceController.dispose();
    productQuantityController.dispose();
  }

  void _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final String barcode = productIdController.text.trim();

    final double? price = double.tryParse(productPriceController.text);
    final int? qty = int.tryParse(productQuantityController.text);

    if (price == null || qty == null) {
      FlushbarUtils.showError(context, message: 'Invalid price or quantity');
      return;
    }

    inventoryBloc.add(PrepareSavingEvent());

    final product = ProductModel(
      id: barcode,
      title: productTitleController.text.trim(),
      price: price,
      image: 'URL',
    );

    await productBloc.repositoryImpl.addProduct(product);

    final item = InventoryModel(productId: barcode, quantity: qty.toString());

    inventoryBloc.add(AddInventoryItem(item));

    productIdController.clear();
    productTitleController.clear();
    productPriceController.clear();
    productQuantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        showBackButton: true,
        title: 'Inventory',
        icon: Icons.arrow_back_ios_new,
      ),
      body: BlocListener<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state is InventoryLoaded) {
            Navigator.pop(context);
          }
        },
        child: _buildBlocBuilder(),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  //---[Inventory Bloc Builder]---
  BlocBuilder<InventoryBloc, InventoryState> _buildBlocBuilder() {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        if (state is InventoryInitial) {
          return Center(child: Text('No Product Added Yet!'));
        }

        if (state is InventoryLoading) {
          return Center(child: MyLoader());
        }
        if (state is InventoryLoaded) {
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];

              return FutureBuilder<Product?>(
                future: context
                    .read<ProductsBloc>()
                    .repositoryImpl
                    .getProductsById(item.productId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ShimmerListTile();
                  }
                  final double? price = double.tryParse(
                    snapshot.data!.price.toString(),
                  );
                  final product = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    child: _buildInventoryCard(product, item, price, index),
                  );
                },
              );
            },
          );
        }
        return Center(child: Text('Something went wrong.'));
      },
    );
  }

  //---[Inventory Card]---
  Widget _buildInventoryCard(
    Product product,
    InventoryItem item,
    double? price,
    int index,
  ) {
    return Card(
      child: ListTile(
        title: Text(
          product.title,
          style: AppTextStyles.bodyTextTitle.copyWith(
            color: Colors.grey.shade900,
          ),
        ),

        leading: CircleAvatar(child: Text("${index + 1}")),

        subtitle: Row(
          children: [
            Text(
              'Qty: ',
              style: AppTextStyles.bodyTextTitle.copyWith(
                color: AppColors.greyTextSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),

            Row(
              children: [
                Text(
                  item.quantity,
                  style: AppTextStyles.bodyTextTitle.copyWith(
                    color: AppColors.greyTextSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 10),
                if (int.parse(item.quantity) == 0) ...[
                  Icon(Icons.error, color: Colors.redAccent[200], size: 14),
                  SizedBox(width: 5),

                  Text(
                    'Out of Stock',
                    style: AppTextStyles.bodyTextTitle.copyWith(
                      color: Colors.redAccent[200],
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ] else if (int.parse(item.quantity) <= 5) ...[
                  Icon(Icons.warning, color: Colors.amber[300], size: 14),
                  SizedBox(width: 5),

                  Text(
                    'Low Stock',
                    style: AppTextStyles.bodyTextTitle.copyWith(
                      color: Colors.orangeAccent[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Text(
          '\$${price!.toString().replaceAll(RegExp(r'\.0$'), '')}',
          style: AppTextStyles.linkTextBlue.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  //---[Floating Action Button]---
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.primaryLight,
      label: Text(
        'Add Item',
        style: TextStyle(color: AppColors.bgWhite, fontSize: 16),
      ),
      icon: Icon(Icons.add, size: 26, color: AppColors.bgWhite),
      onPressed: () {
        _buildShowDialog(context);
      },
    );
  }

  //---[Alert Dialog For Add Items Fields + Save Button]---
  Future<dynamic> _buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: inventoryBloc,
          child: AlertDialog.adaptive(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 520,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .start,
                      children: [
                        //---[Upper Part]---
                        Row(
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 26,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Add Item',
                              style: AppTextStyles.bodyTextTitle.copyWith(
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        //---[Fields]---
                        _buildText(name: 'Barcode / ID', isRequired: true),
                        SizedBox(height: 5),
                        MyTextFormField(
                          controller: productIdController,
                          validator: AppValidators.validateBarcode,
                          text: 'Scan or Enter Barcode',
                          prefixIcon: Icon(Icons.qr_code_2),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: AppColors.primaryLight,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Center(
                                  child: SizedBox(
                                    height: 300,
                                    child: MobileScanner(
                                      onDetect: (capture) {
                                        final barcode =
                                            capture.barcodes.first.rawValue;
                                        if (barcode != null) {
                                          productIdController.text = barcode;
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildText(name: 'Title', isRequired: true),
                        SizedBox(height: 5),

                        MyTextFormField(
                          controller: productTitleController,
                          text: 'Enter item name',
                          validator: AppValidators.validateTitle,
                          prefixIcon: Icon(Icons.note_alt_rounded),
                        ),
                        SizedBox(height: 10),
                        _buildText(name: 'Price', isRequired: true),
                        SizedBox(height: 5),

                        MyTextFormField(
                          controller: productPriceController,

                          text: 'Enter item Price',
                          validator: AppValidators.validatePrice,
                          prefixIcon: Icon(Icons.price_change_sharp),
                        ),
                        SizedBox(height: 10),
                        _buildText(name: 'Quantity', isRequired: true),
                        SizedBox(height: 5),

                        MyTextFormField(
                          controller: productQuantityController,

                          text: 'Enter item quantity',
                          validator: AppValidators.validateQuantity,
                          prefixIcon: Icon(Icons.numbers),
                        ),

                        SizedBox(height: 30),

                        //---[Save Inventory Button]---
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: BlocBuilder<InventoryBloc, InventoryState>(
                            builder: (context, state) {
                              final isShowLoading = state is InventorySaving;
                              return RoundedContainer(
                                height:
                                    MediaQuery.of(context).size.height * 0.052,
                                width: MediaQuery.of(context).size.width * 0.3,
                                name: 'Save',
                                isLoading: isShowLoading,

                                onTap: isShowLoading ? null : _saveData,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

//---[Text Widget]---
Widget _buildText({
  required String name,
  Color? color,
  bool isRequired = false,
}) {
  return RichText(
    text: TextSpan(
      text: name,
      style: AppTextStyles.bodyTextSecondary.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      children: [
        if (isRequired)
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
            ), // Make the star red for clarity
          ),
      ],
    ),
  );
}
