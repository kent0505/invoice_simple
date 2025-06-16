import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/features/settings/data/model/client_model.dart';
import 'package:invoice_simple/features/settings/ui/widgets/search_field.dart';

class AddClientsViewBody extends StatefulWidget {
  const AddClientsViewBody({
    super.key,
    required this.myController,
    required this.clickable,
  });

  final bool clickable;
  final TextEditingController myController;

  @override
  State<AddClientsViewBody> createState() => _AddClientsViewBodyState();
}

class _AddClientsViewBodyState extends State<AddClientsViewBody> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    widget.myController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      searchText = widget.myController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    widget.myController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingHorizontal,
        ),
        child: Column(
          children: [
            SearchField(
              controller: widget.myController,
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box<ClientModel>(AppConstants.hiveClientBox)
                  .listenable(),
              builder: (context, Box<ClientModel> box, _) {
                final clients = box.values.toList();

                final filteredClients = searchText.isEmpty
                    ? clients
                    : clients
                        .where((client) => (client.clientName)
                            .toLowerCase()
                            .contains(searchText))
                        .toList();

                if (filteredClients.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      "No clients found.",
                      style: AppTextStyles.poFont20BlackWh400.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredClients.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final client = filteredClients[index];
                    return ListTile(
                      title: GestureDetector(
                        onTap: widget.clickable
                            ? () {
                                context.pop(client);
                              }
                            : null,
                        child: Text(
                          client.clientName,
                          style: AppTextStyles.poFont20BlackWh400.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
