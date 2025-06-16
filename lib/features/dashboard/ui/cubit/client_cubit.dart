import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_simple/features/settings/data/model/client_model.dart';

class ClientCubit extends Cubit<ClientState> {
  ClientCubit() : super(ClientState.initial());

  void selectClient(ClientModel client) {
    emit(state.copyWith(selectedClient: client));
  }

  void clearClient() {
    emit(state.copyWith(removeClient: true));
  }
}

class ClientState {
  final ClientModel? selectedClient;

  const ClientState({this.selectedClient});

  factory ClientState.initial() {
    return const ClientState(selectedClient: null);
  }

  ClientState copyWith({
    ClientModel? selectedClient,
    bool removeClient = false,
  }) {
    return ClientState(
      selectedClient:
          removeClient ? null : (selectedClient ?? this.selectedClient),
    );
  }
}
