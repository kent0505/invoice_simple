import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/business_cubit.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/client_cubit.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/items_cubit.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/edit_invoice_view.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/home_screen.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/inoice_preview_view.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/invoice_details_view.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/new_invoice_view.dart';
import 'package:invoice_simple/features/onboarding/ui/screens/onboard_screen.dart';
import 'package:invoice_simple/features/onboarding/ui/screens/splash_screen.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_clients_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_item_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_new_business_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/business_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/settings_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/signature_view.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: OnboardScreen.routePath,
      builder: (context, state) => const OnboardScreen(),
    ),
    GoRoute(
      path: HomeScreen.routePath,
      builder: (context, state) => const HomeScreen(),
    ),

    //
    GoRoute(
      path: NewInvoiceView.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BusinessCubit()),
          BlocProvider(create: (context) => ClientCubit()),
          BlocProvider(create: (context) => ItemsCubit()),
        ],
        child: NewInvoiceView(
          isEstimate: state.extra as bool? ?? false,
        ),
      ),
    ),
    GoRoute(
      path: InvoicePreviewView.routeName,
      builder: (context, state) => InvoicePreviewView(
        invoice: state.extra as InvoiceModel,
      ),
    ),
    GoRoute(
      path: InvoiceDetailsView.routeName,
      builder: (context, state) => InvoiceDetailsView(
        invoice: state.extra as InvoiceModel,
      ),
    ),
    GoRoute(
      path: EditInvoiceView.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ClientCubit()),
          BlocProvider(create: (context) => ItemsCubit()),
        ],
        child: EditInvoiceView(invoice: state.extra as InvoiceModel),
      ),
    ),
    GoRoute(
      path: SettingsView.routeName,
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: BusinessView.routeName,
      builder: (context, state) => BusinessView(
        clickable: state.extra as bool? ?? false,
      ),
    ),
    GoRoute(
      path: AddNewBusinessView.routeName,
      builder: (context, state) => const AddNewBusinessView(),
    ),
    GoRoute(
      path: SignatureView.routeName,
      builder: (context, state) => SignatureView(
        onSaved: (state.extra as Function(String path)),
      ),
    ),
    GoRoute(
      path: AddItemView.routeName,
      builder: (context, state) => AddItemView(
        clickable: state.extra as bool? ?? false,
      ),
    ),
    GoRoute(
      path: AddClientsView.routeName,
      builder: (context, state) => AddClientsView(
        clickable: state.extra as bool? ?? false,
      ),
    ),
  ],
);
