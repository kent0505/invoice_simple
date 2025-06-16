import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils.dart';
import '../models/pro.dart';

part 'pro_event.dart';

abstract final class Identifiers {
  static const paywall_1 = 'paywall_1';
  static const paywall_2 = 'paywall_2';
}

class ProBloc extends Bloc<ProEvent, Pro> {
  ProBloc() : super(Pro()) {
    on<ProEvent>(
      (event, emit) => switch (event) {
        CheckPro() => _checkPro(event, emit),
      },
    );
  }

  void _checkPro(
    CheckPro event,
    Emitter<Pro> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    if (isIOS()) {
      emit(Pro(loading: true));

      try {
        late String identifier;

        if (event.initial) {
          final showCount = prefs.getInt('showCount') ?? 0;
          final isFirstOrSecondShow = showCount == 1 || showCount == 2;
          identifier = isFirstOrSecondShow
              ? Identifiers.paywall_2
              : Identifiers.paywall_1;
          await prefs.setInt('showCount', showCount + 1);
        } else {
          identifier = event.identifier;
        }

        final customerInfo = await Purchases.getCustomerInfo().timeout(
          const Duration(seconds: 3),
        );

        final isPro = customerInfo.entitlements.active.isNotEmpty;

        final offerings = await Purchases.getOfferings().timeout(
          const Duration(seconds: 3),
        );

        final offering = offerings.getOffering(identifier);

        emit(Pro(
          isPro: isPro,
          offering: offering,
        ));
      } catch (e) {
        logger(e);
        emit(Pro());
      }
    } else {
      emit(Pro(isPro: true));
    }
  }
}
