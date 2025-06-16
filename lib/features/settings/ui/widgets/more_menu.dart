import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class MoreMenu extends StatefulWidget {
  const MoreMenu({super.key, this.onDelete});

  final VoidCallback? onDelete;

  @override
  State<MoreMenu> createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showMenu() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideMenu,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(-160, -8), // adjust as needed
              showWhenUnlinked: false,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .10),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IntrinsicWidth(
                    child: GestureDetector(
                      onTap: () {
                        widget.onDelete?.call();
                        _hideMenu();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Delete account',
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 12,
                              color: AppColors.red,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.delete,
                            color: AppColors.red,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        icon: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: AppColors.black),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.more_horiz,
            color: AppColors.black,
            size: 20,
          ),
        ),
        onPressed: () {
          if (_overlayEntry == null) {
            _showMenu();
          } else {
            _hideMenu();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _hideMenu();
    super.dispose();
  }
}
