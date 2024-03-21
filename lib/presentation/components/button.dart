import 'package:flutter/material.dart';
import 'package:nymble_music/presentation/constants/colors.dart';
import 'package:nymble_music/presentation/constants/styles.dart';
import 'package:nymble_music/utils/extensions.dart';

class Button extends StatefulWidget {
  final Function? onTap, onDisabledTap;
  final String label;
  final bool isPrimary, isProminent, showLoading, boldLabel, enabled;
  final Color? customColor;
  final Size? minimumSize;
  final double radius, borderWidth;
  final Color? customTextColor;

  const Button({
    super.key,
    this.onTap,
    this.onDisabledTap,
    required this.label,
    this.isPrimary = true,
    this.isProminent = true,
    this.showLoading = true,
    this.boldLabel = false,
    this.enabled = true,
    this.borderWidth = 1.5,
    this.customColor,
    this.minimumSize,
    this.radius = 10,
    this.customTextColor,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!widget.enabled) {
          widget.onDisabledTap?.call();
          return;
        }
        if (isLoading) return;
        setState(() {
          isLoading = true;
        });
        await widget.onTap?.call();
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.isProminent
            ? widget.enabled
                ? widget.customColor ?? (widget.isPrimary ? primaryColor : accentColor)
                : Colors.grey
            : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius)),
        elevation: widget.isProminent ? 5 : 0,
        shadowColor: widget.isProminent ? null : Colors.transparent,
        foregroundColor: widget.enabled
            ? widget.customColor ??
                (widget.isProminent
                    ? widget.isPrimary
                        ? accentColor
                        : primaryColor
                    : widget.isPrimary
                        ? primaryColor
                        : accentColor)
            : Colors.grey,
        side: BorderSide(
            color: widget.enabled ? widget.customColor ?? (widget.isPrimary ? primaryColor : accentColor) : Colors.grey,
            width: widget.enabled
                ? widget.isProminent
                    ? 0
                    : widget.isPrimary
                        ? widget.borderWidth
                        : widget.borderWidth
                : widget.borderWidth),
        minimumSize: widget.minimumSize ??
            Size(
              double.infinity,
              (context.height * 0.08).clamp(30, 50),
            ),
      ),
      child: (widget.showLoading && isLoading)
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: widget.isProminent
                    ? widget.enabled
                        ? (widget.isPrimary ? Colors.white : Colors.black)
                        : Colors.white
                    : widget.enabled
                        ? widget.customColor ?? (widget.isPrimary ? primaryColor : accentColor)
                        : Colors.grey,
              ),
            )
          : Text(
              widget.label,
              style: montserratText.copyWith(
                fontWeight: widget.boldLabel ? FontWeight.bold : FontWeight.normal,
                color: widget.customTextColor ??
                    (widget.isProminent
                        ? widget.enabled
                            ? (widget.isPrimary ? Colors.white : Colors.black)
                            : Colors.white
                        : widget.enabled
                            ? widget.customColor ?? (widget.isPrimary ? primaryColor : accentColor)
                            : Colors.grey),
              ),
            ),
    );
  }
}
