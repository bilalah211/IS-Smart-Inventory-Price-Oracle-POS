import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/core/utils/loader.dart';
import 'package:smartinevntary/core/widgets/my_appbar.dart';
import 'package:smartinevntary/features/sale/presentation/bloc/sale_bloc.dart';
import 'package:smartinevntary/features/sale/presentation/bloc/sale_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyle.dart';
import '../bloc/sale_event.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  @override
  void initState() {
    super.initState();

    context.read<SaleBloc>().add(GetAllSalesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        showBackButton: true,
        title: 'Sales History',
        icon: Icons.arrow_back_ios_new,
      ),
      body: BlocBuilder<SaleBloc, SaleState>(
        builder: (context, state) {
          if (state is LoadingSaleState) {
            return Center(child: MyLoader());
          }
          if (state is ErrorSaleState) {
            return Center(child: Text('Something Went Wrong'));
          }
          if (state is LoadedSaleState) {
            //Sale List View
            return _buildSaleList(state);
          }
          return Center(child: Text('No Sale History Yet!'));
        },
      ),
    );
  }

  Widget _buildSaleList(LoadedSaleState state) {
    return ListView.builder(
      itemCount: state.saleItem.length,
      itemBuilder: (context, index) {
        final item = state.saleItem[index];
        final double qty = double.tryParse(item.quantitySold.toString()) ?? 0;
        final double price = double.tryParse(item.productPrice.toString()) ?? 0;

        //Calculate total as an integer
        final totalPrice = qty * price;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Card(
            child: ListTile(
              title: Text(
                item.productName,
                style: AppTextStyles.bodyTextTitle.copyWith(
                  color: Colors.grey.shade900,
                  fontSize: 20,
                  letterSpacing: 1,
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
                        qty.toStringAsFixed(0),
                        style: AppTextStyles.bodyTextTitle.copyWith(
                          color: AppColors.greyTextSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Text(
                '\$${totalPrice.toString()}',
                style: AppTextStyles.linkTextBlue.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
