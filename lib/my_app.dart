import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_simple/core/routes/app_router.dart';
import 'package:invoice_simple/core/themes.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/invoice_dashboard_cubit.dart';
import 'package:invoice_simple/features/pro/bloc/pro_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InvoiceDashboardCubit(),
        ),
        BlocProvider(
          create: (context) => ProBloc()
            ..add(
              CheckPro(
                identifier: Identifiers.paywall_1,
                initial: true,
              ),
            ),
        ),
      ],
      child: MaterialApp.router(
        theme: theme,
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
      ),
    );
  }
}
