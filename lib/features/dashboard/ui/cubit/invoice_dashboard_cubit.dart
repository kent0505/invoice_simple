import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceDashboardCubit extends Cubit<int> {
  InvoiceDashboardCubit() : super(0);

  void selectFilter(int index) => emit(index);
}
