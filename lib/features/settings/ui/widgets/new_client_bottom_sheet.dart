import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:invoice_simple/core/widgets/show_required_fields_dialog.dart';
import 'package:invoice_simple/features/settings/data/model/client_model.dart';
import 'package:invoice_simple/features/settings/ui/widgets/labeled_text_field.dart';

class NewClientBottomSheet extends StatefulWidget {
  const NewClientBottomSheet({super.key});

  @override
  State<NewClientBottomSheet> createState() => _NewClientBottomSheetState();
}

class _NewClientBottomSheetState extends State<NewClientBottomSheet> {
  final billToController = TextEditingController();
  final clientNameController = TextEditingController();
  final clientPhoneController = TextEditingController();
  final clientEmailController = TextEditingController();
  final clientAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    billToController.addListener(_onFieldsChanged);
    clientNameController.addListener(_onFieldsChanged);
    clientPhoneController.addListener(_onFieldsChanged);
    clientAddressController.addListener(_onFieldsChanged);
  }

  @override
  void dispose() {
    billToController.dispose();
    clientNameController.dispose();
    clientPhoneController.dispose();
    clientEmailController.dispose();
    clientAddressController.dispose();
    super.dispose();
  }

  void _onFieldsChanged() {
    setState(() {});
  }

  Future<void> importContact(BuildContext context) async {
    if (!await FlutterContacts.requestPermission()) {
      if (context.mounted) {
        showRequiredFieldsDialog(context, "Please allow access to contacts");
      }
      return;
    }

    final contact = await FlutterContacts.openExternalPick();
    if (contact == null) return;

    setState(() {
      clientNameController.text = contact.displayName;
      clientPhoneController.text =
          contact.phones.isNotEmpty ? contact.phones.first.number : '';
      clientEmailController.text =
          contact.emails.isNotEmpty ? contact.emails.first.address : '';
      clientAddressController.text = contact.addresses.isNotEmpty
          ? [
              contact.addresses.first.street,
              contact.addresses.first.city,
              contact.addresses.first.postalCode,
              contact.addresses.first.country,
            ].where((s) => s.isNotEmpty).join(', ')
          : '';
    });
  }

  Future<void> saveClient() async {
    if (isNotClientValid()) {
      showRequiredFieldsDialog(context, "Please fill all required fields");
      return;
    }

    final newClient = ClientModel(
      billTo: billToController.text.trim(),
      clientName: clientNameController.text.trim(),
      clientPhone: clientPhoneController.text.trim(),
      clientAddress: clientAddressController.text.trim(),
      clientEmail: clientEmailController.text.trim(),
    );

    final box = await Hive.openBox<ClientModel>(AppConstants.hiveClientBox);
    await box.add(newClient);

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Client saved successfully!")),
    );
  }

  bool isNotClientValid() {
    return billToController.text.trim().isEmpty ||
        clientNameController.text.trim().isEmpty ||
        clientPhoneController.text.trim().isEmpty ||
        clientAddressController.text.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: AppTextStyles.poFont20BlackWh400.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        saveClient();
                      },
                      child: Text(
                        "Done",
                        style: AppTextStyles.poFont20BlackWh600.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),

                // Header
                Text(
                  "New Client",
                  style: AppTextStyles.poFont20BlackWh600.copyWith(
                    fontSize: 26,
                  ),
                ),
                SizedBox(height: 23),

                // Bill To field
                TextField(
                  controller: billToController,
                  style: AppTextStyles.poFont20BlackWh400.copyWith(
                    fontSize: 12,
                    color: AppColors.blueAccent,
                  ),
                  cursorColor: AppColors.blueAccent,
                  decoration: InputDecoration(
                    hintText: "Bill To",
                    hintStyle: AppTextStyles.poFont20BlackWh400.copyWith(
                      fontSize: 12,
                      color: AppColors.blueGrey,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                ),

                const SizedBox(height: 16),

                // Contacts section header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Contacts",
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      fontSize: 12,
                      color: AppColors.blueGrey,
                    ),
                  ),
                ),

                // Contacts form
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 23,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      LabeledTextField(
                        label: 'Name',
                        onChanged: (val) {},
                        controller: clientNameController,
                        hintText: 'Must be filled',
                      ),
                      LabeledTextField(
                        label: 'Phone',
                        controller: clientPhoneController,
                        onChanged: (val) {},
                        hintText: 'Must be filled',
                        keyboardType: TextInputType.phone,
                      ),
                      LabeledTextField(
                        label: 'Address',
                        controller: clientAddressController,
                        onChanged: (val) {},
                        hintText: 'Must be filled',
                      ),
                      LabeledTextField(
                        label: 'E-Mail',
                        controller: clientEmailController,
                        onChanged: (val) {},
                        hintText: 'Optional',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        importContact(context);
                      },
                      child: Text(
                        "Import from Contacts",
                        style: AppTextStyles.poFont20BlackWh400.copyWith(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                FilledTextButton(
                  color: isNotClientValid() ? AppColors.blueGrey : null,
                  text: "Continue",
                  onPressed: () {
                    saveClient();
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
