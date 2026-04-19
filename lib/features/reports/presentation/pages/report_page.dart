import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/core/constants/app_strings.dart';
import 'package:smartinevntary/core/utils/loader.dart';
import 'package:smartinevntary/core/widgets/my_appbar.dart';
import 'package:smartinevntary/features/reports/domain/entities/report_summary.dart';
import 'package:smartinevntary/features/reports/presentation/bloc/report_states.dart';
import '../bloc/report_bloc.dart';

import '../bloc/report_event.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(LoadReport(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(showBackButton: true, title: AppStrings.reports),
      body: BlocBuilder<ReportBloc, ReportStates>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(child: MyLoader());
          }
          if (state is ReportsLoaded) {
            final data = state.reportSummary;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SUMMARY ROW ---
                  _buildSummary(data),
                  const SizedBox(height: 10),
                  _buildStatCard(
                    AppStrings.totalItems,
                    "${data.totalItems} units",
                    Colors.blue,
                    fullWidth: true,
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    AppStrings.bestSelling,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),

                  // --- TOP PRODUCTS LIST ---
                  _buildTopProductList(data),
                ],
              ),
            );
          }
          return const Center(child: Text("No Data Available"));
        },
      ),
    );
  }

  //TOP PRODUCT SUMMARY
  Widget _buildTopProductList(ReportSummary data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.topProduct.length,
      itemBuilder: (context, index) {
        final p = data.topProduct[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text("${index + 1}")),
            title: Text(
              p.productName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${p.totalQty} sold"),
            trailing: Text(
              "\$${p.totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  //SUMMARY
  Widget _buildSummary(ReportSummary data) {
    return Row(
      children: [
        _buildStatCard(
          "Revenue",
          "\$${data.totalRevenue.toStringAsFixed(2)}",
          Colors.green,
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          "Sales Count",
          "${data.totalTransactions}",
          Colors.purple,
        ),
      ],
    );
  }

  //STATE CARD
  Widget _buildStatCard(
    String title,
    String value,
    Color color, {
    bool fullWidth = false,
  }) {
    return Expanded(
      flex: fullWidth ? 0 : 1,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
