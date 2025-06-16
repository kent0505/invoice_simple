import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_simple/features/settings/data/model/business_user_model.dart';

class BusinessCubit extends Cubit<BusinessState> {
  BusinessCubit() : super(BusinessState.initial());

  void selectBusiness(BusinessUserModel business) {
    emit(state.copyWith(
      selectedBusiness: business,
      currency: business.currency,
    ));
  }

  void clearBusiness() {
    emit(state.copyWith(
      removeBusiness: true,
      currency: "USA",
    ));
  }
}

class BusinessState {
  final BusinessUserModel? selectedBusiness;
  final String currency;

  const BusinessState({
    this.selectedBusiness,
    required this.currency,
  });

  factory BusinessState.initial() {
    return BusinessState(
      selectedBusiness: null,
      currency: "USA",
    );
  }

  BusinessState copyWith({
    BusinessUserModel? selectedBusiness,
    bool removeBusiness = false,
    String? currency,
  }) {
    return BusinessState(
      selectedBusiness:
          removeBusiness ? null : (selectedBusiness ?? this.selectedBusiness),
      currency: currency ?? this.currency,
    );
  }
}
