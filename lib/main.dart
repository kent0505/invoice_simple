import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/helpers/custom_bloc_observer.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/settings/data/model/business_user_model.dart';
import 'package:invoice_simple/features/settings/data/model/client_model.dart';
import 'package:invoice_simple/features/settings/data/model/item_model.dart';
import 'package:invoice_simple/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();

  Hive.registerAdapter(BusinessUserModelAdapter());
  await Hive.openBox<BusinessUserModel>(AppConstants.hiveBusinessBox);

  Hive.registerAdapter(ItemModelAdapter());
  await Hive.openBox<ItemModel>(AppConstants.hiveItemBox);

  Hive.registerAdapter(ClientModelAdapter());
  await Hive.openBox<ClientModel>(AppConstants.hiveClientBox);

  Hive.registerAdapter(InvoiceModelAdapter());
  await Hive.openBox<InvoiceModel>(AppConstants.hiveInvoiceBox);

  Bloc.observer = CustomBlocObserver();

  runApp(MyApp());
}
