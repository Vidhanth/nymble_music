import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nymble_music/presentation/constants/styles.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.controller,
    this.hint,
    this.onSubmit,
    this.onChanged,
    this.inputType,
    this.hideText = false,
    this.label,
    this.prefixText,
    this.maxLines = 1,
    this.maxLength,
    this.fillColor,
    this.textColor,
    this.labelColor,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.autofocus = false,
    this.borderRadius,
    this.autofillHints,
    this.focusNode,
    this.borderColor,
  });

  final TextEditingController controller;
  final String? hint, label, prefixText;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final TextInputType? inputType;
  final bool hideText, enabled, autofocus;
  final int maxLines;
  final Color? fillColor, textColor, labelColor, borderColor;
  final TextInputAction? textInputAction;
  final double? borderRadius;
  final List<String>? autofillHints;
  final FocusNode? focusNode;
  final int? maxLength;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final ValueNotifier<bool> showPassword = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: montserratText.copyWith(color: widget.labelColor),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
        ValueListenableBuilder(
            valueListenable: showPassword,
            builder: (context, showPasswordValue, child) {
              return TextFormField(
                autofillHints: widget.autofillHints,
                autofocus: widget.autofocus,
                enabled: widget.enabled,
                focusNode: widget.focusNode,
                keyboardType: widget.inputType,
                maxLength: widget.maxLength,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                  return const SizedBox();
                },
                onFieldSubmitted: ((value) {
                  widget.onSubmit?.call(value);
                }),
                onChanged: widget.onChanged,
                textInputAction: widget.textInputAction,
                controller: widget.controller,
                maxLines: widget.maxLines,
                obscureText: widget.inputType == TextInputType.visiblePassword ? !showPasswordValue : widget.hideText,
                inputFormatters: [
                  if (widget.inputType == TextInputType.phone || widget.inputType == TextInputType.number) ...[FilteringTextInputFormatter.digitsOnly]
                ],
                style: montserratText.copyWith(color: widget.textColor),
                decoration: InputDecoration(
                  suffixIcon: widget.inputType == TextInputType.visiblePassword
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              showPassword.value = !showPassword.value;
                            },
                            child: Icon(
                              showPasswordValue ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              // color: Colors.black.withOpacity(0.75),
                            ),
                          ),
                        )
                      : widget.controller.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  widget.controller.clear();
                                  widget.onChanged?.call(widget.controller.text);
                                },
                                child: const Icon(
                                  Icons.backspace_rounded,
                                ),
                              ),
                            )
                          : null,
                  prefixIcon: widget.prefixText != null
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.prefixText!,
                            style: montserratText.copyWith(color: widget.textColor ?? Colors.black),
                          ),
                        )
                      : null,
                  prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  hintText: widget.hint,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                    borderSide: widget.borderColor == null ? BorderSide.none : BorderSide(color: widget.borderColor!, width: 1.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                    borderSide: widget.borderColor == null ? BorderSide.none : BorderSide(color: widget.borderColor!, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                    borderSide: widget.borderColor == null ? BorderSide.none : BorderSide(color: widget.borderColor!, width: 1.5),
                  ),
                  filled: true,
                  fillColor: widget.fillColor ?? Theme.of(context).hoverColor,
                ),
              );
            }),
      ],
    );
  }
}
