import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/features/products/domain/usecases/get_product_by_id.dart';
import 'package:smartinevntary/features/sale/domain/usecases/execute_sale.dart';
import 'package:smartinevntary/features/sale/domain/usecases/get_sales_history.dart';
import 'package:smartinevntary/features/sale/presentation/bloc/sale_event.dart';
import 'package:smartinevntary/features/sale/presentation/bloc/sale_state.dart';
import '../../../inventory/domain/usecases/get_item_by_barcode.dart';

class SaleBloc extends Bloc<SalesEvent, SaleState> {
  final ExecuteSale executeSale;
  final GetSalesHistory getSalesHistory;
  final GetProductById getProductById;
  final GetItemByBarcode getItemByBarcode;

  SaleBloc(
    this.executeSale,
    this.getSalesHistory,
    this.getProductById,
    this.getItemByBarcode,
  ) : super(InitialSaleState()) {
    on<ScanBarcodeEvent>((event, emit) async {
      emit(LoadingSaleState());
      try {
        final productByBarcode = await getProductById.call((event.barcode));
        final inventory = await getItemByBarcode.call(productByBarcode!.id);
        emit(LoadedScannedState(productByBarcode, inventory?.quantity ?? '0'));
      } catch (e) {
        emit(ErrorSaleState(e.toString()));
      }
    });

    on<ExecuteSaleEvent>((event, emit) async {
      emit(LoadingSaleState());
      try {
        for (var item in event.saleItems) {
          await executeSale.call(item);
        }
        emit(InitialSaleState());
        add(GetAllSalesEvent());
      } catch (e) {
        emit(ErrorSaleState(e.toString()));
      }
    });

    on<GetAllSalesEvent>((event, emit) async {
      emit(LoadingSaleState());
      final sales = await getSalesHistory.call();
      emit(LoadedSaleState(sales));
    });
  }
}
