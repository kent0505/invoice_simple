import 'package:flutter/widgets.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';

class InvoiceTableRow extends StatelessWidget {
  const InvoiceTableRow({
    super.key,
    required this.children,
    this.height = 44,
    this.textStyle,
    this.backgroundColor,
    this.showTopBorder = false,
    this.showBottomBorder = false,
  });

  final List<Widget> children;
  final double height;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final bool showTopBorder;
  final bool showBottomBorder;

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(
      color: AppColors.lightGrey,
      width: 1,
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        border: Border(
          top: showTopBorder ? borderSide : BorderSide.none,
          bottom: showBottomBorder ? borderSide : BorderSide.none,
        ),
      ),
      child: Row(
        children: List.generate(children.length, (index) {
          return Expanded(
            flex: index == 0 ? 6 : (index == 1 ? 2 : 3),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: (index != children.length - 1)
                      ? borderSide
                      : BorderSide.none,
                ),
              ),
              alignment: Alignment.center,
              child: children[index],
            ),
          );
        }),
      ),
    );
  }
}
